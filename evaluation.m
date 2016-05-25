%%Evaluacion de parametros obtenidos
clc;
clear all;
close all;
I(1).img = im2double(imread('dataset/GER7/GER1.bmp'));
I(1).int = imread('dataset/GER7/GER1.bmp');
I(1).name = 'GER1';
I(2).img = im2double(imread('dataset/GER7/GER2.bmp'));
I(2).name = 'GER2';
I(2).int = imread('dataset/GER7/GER2.bmp');
I(3).img = im2double(imread('dataset/GER7/GER3.bmp'));
I(3).name = 'GER3';
I(3).int = imread('dataset/GER7/GER3.bmp');
I(4).img = im2double(imread('dataset/GER7/GER4.bmp'));
I(4).name = 'GER4';
I(4).int = imread('dataset/GER7/GER4.bmp');



metodos(2).m='anisodiff';
metodos(2).args.delta_t=1/20;
metodos(2).args.kappa=70;


%% Anisotropico con Media

% Parametros obtenidos:
% 
% Iteraciones: 18
% Tamaño de ventana: 119

filtro = fspecial('average',119);
media = imfilter(I(2).img,filtro); 
mask = getmask(I(2).img);
sin_fondo = adapthisteq(I(2).img-im2double(media));
normalizada = (sin_fondo-min(sin_fondo(:)))/(max(sin_fondo(:))-min(sin_fondo(:)));
mask=logical(mask);

metodos(2).args.iterations=18;

preprocesada = preprocess(normalizada,metodos(2).m,metodos(2).args);

figure,
subplot(1,2,1),imshow(preprocesada);
options = struct('FrangiScaleRange', [1 15], 'FrangiScaleRatio', 1, 'FrangiBetaOne', 0.5, 'FrangiBetaTwo', 15, 'verbose',true,'BlackWhite',true);
fringe = Frangi1998(imcomplement(preprocesada),mask,1,options);
fringe = (fringe-min(fringe(:)))/(max(fringe(:))-min(fringe(:)));
fringe(fringe>0.02)=1;
figure,
subplot(1,1,1),imshow(fringe);

%tr = graythresh(normalizada);

%umbral = normalizada;
%umbral(umbral <= tr)=0;
%umbral(umbral > tr)=1;

%subplot(1,2,2),imshow(umbral);

%% Anisotropico con Mediana

% Parametros obtenidos:
% 
% Iteraciones: 19
% Tamaño de ventana: 115
% Valor de area: 

mediana = medfilt2(I(2).int,[115 115]); 
mask = getmask(I(2).img);
sin_fondo = adapthisteq(I(2).img-im2double(mediana));
normalizada = (sin_fondo-min(sin_fondo(:)))/(max(sin_fondo(:))-min(sin_fondo(:)));
mask=logical(mask);

metodos(2).args.iterations=19;

preprocesada = preprocess(normalizada,metodos(2).m,metodos(2).args);

figure,
subplot(1,1,1),imshow(preprocesada);

%tr = graythresh(normalizada);

%umbral = normalizada;
%umbral(umbral <= tr)=0;
%umbral(umbral > tr)=1;

%subplot(1,2,2),imshow(umbral);

%% Coherencia con Media

% Parametros obtenidos:
% 
% Iteraciones: 150
% Tamaño de ventana: 129
% Valor de area: 

filtro = fspecial('average',129);
media = imfilter(I(2).img,filtro); 
mask = getmask(I(2).img);
sin_fondo = adapthisteq(I(2).img-im2double(media));
normalizada = (sin_fondo-min(sin_fondo(:)))/(max(sin_fondo(:))-min(sin_fondo(:)));
mask=logical(mask);

preprocesada = CoherenceFilter(normalizada,struct('T',150));

figure,
subplot(1,1,1),imshow(preprocesada);

%tr = graythresh(normalizada);

%umbral = normalizada;
%umbral(umbral <= tr)=0;
%umbral(umbral > tr)=1;

%subplot(1,2,2),imshow(umbral);


%% Coherencia con Mediana

% Parametros obtenidos:
% 
% Iteraciones: 150
% Tamaño de ventana: 131
% Valor de area: 

mediana = medfilt2(I(2).int,[131 131]); 
mask = getmask(I(2).img);
sin_fondo = adapthisteq(I(2).img-im2double(mediana));
normalizada = (sin_fondo-min(sin_fondo(:)))/(max(sin_fondo(:))-min(sin_fondo(:)));
mask=logical(mask);

preprocesada = CoherenceFilter(normalizada,struct('T',150));


figure,
subplot(1,1,1),imshow(preprocesada);
%tr = graythresh(normalizada);

%umbral = normalizada;
%umbral(umbral <= tr)=0;
%umbral(umbral > tr)=1;

%subplot(1,2,2),imshow(umbral);
