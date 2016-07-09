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

% M.img = im2double(imread('DRIVE/training/images/29_training.tif'));
% M.mask = imread('DRIVE/training/mask/29_training_mask.gif');
% 
% final = Soares2006(M.img(:,:,2), M.mask, 0,struct('scales',[1 1.2 1.4 1.6]));
% imshow(final);
% final = Soares2006(imcomplement(M.img(:,:,2)), M.mask, 0,struct('scales',[1 2]));
% imshow(final);
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
unary=0;
figure,
subplot(1,2,1),imshow(preprocesada);
fringe = Frangi1998(preprocesada,mask,unary);
%fringe = Zana2001(imcomplement(preprocesada),mask,unary, struct('l',90));
%fringe = Soares2006(preprocesada,mask,unary, struct('scales',[0.75  1.25 1.75 2.25]));
fringe=(fringe-min(fringe(:)))/(max(fringe(:))-min(fringe(:)));
if (unary==1) 
    fringe_sum = fringe(:,:,1)+fringe(:,:,2)+fringe(:,:,3)+fringe(:,:,4)+fringe(:,:,5)+fringe(:,:,6)+fringe(:,:,7);

    figure,
    subplot(1,1,1),imshow(fringe_sum);

    figure,
    subplot(2,4,1),imshow(fringe(:,:,1));
    subplot(2,4,2),imshow(fringe(:,:,2));
    subplot(2,4,3),imshow(fringe(:,:,3));
    subplot(2,4,4),imshow(fringe(:,:,4));
    subplot(2,4,5),imshow(fringe(:,:,5));
    subplot(2,4,6),imshow(fringe(:,:,6));
    subplot(2,4,7),imshow(fringe(:,:,7));
else
    figure, imshow(fringe,[]);
end;

%mached filter

 %options = struct('sigmas', sqrt([0.10 0.5 1.25 1.5]));
 options = struct('sigmas', sqrt([10 18 26 34 42]));
 mf= MatchedFilterResponses(imcomplement(preprocesada), mask, 0, options);/
 figure,
% subplot(2,2,1),imshow(mf(:,:,1)),
% subplot(2,2,2),imshow(mf(:,:,2)),
% subplot(2,2,3),imshow(mf(:,:,2)),
% subplot(2,2,4),imshow(mf(:,:,2));
% 
% mfor = mf(:,:,1) + mf(:,:,2) + mf(:,:,3) + mf(:,:,4);
% mfor(mfor<graythresh(mfor))=0;
% mfor(mfor>=graythresh(mfor))=1;
% 
% figure,
 imshow(mf,[]);

%tr = graythresh(normalizada);

%umbral = normalizada;
%umbral(umbral <= tr)=0;
%umbral(umbral > tr)=1;

%subplot(1,2,2),imshow(umbral);

%nguyen
options.w=5;
options.step=2;
options.first=1;
 INguyen= Nguyen2013(imcomplement(preprocesada),logical(mask), 0,options);
figure,
imshow(INguyen,[]);
%soares
%options = struct('scales', [230 240 250 255]);
%options = struct('scales', [2 3 4 5]);
options = struct('scales', [ 4 5 6 7 ]);
soares=Soares2006(imcomplement(preprocesada), mask, 0, options);
figure,
imshow(soares,[]);

%Sum of tophat
options.length=45;
options.angles= 0:22.5:180;

sot=SumOfTopHat(imcomplement(preprocesada), mask, options);
figure,
imshow(sot,[]);

%Zana 2001

zana=Zana2001(imcomplement(preprocesada),mask,0, struct('l',40));
zanan = zeros(size(I,1), size(I,2), 2);
        z1 = zana;
        z1(z1<0) = 0;
        z2 = zana;
        z2(z2>0) = 0;
        zanan(:,:,1) = z1;
        zanan(:,:,2) = z2;
figure,
imshow(imcomplement(z2),[]);

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
%%

%% Feature Extraction

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



%Options Nguyen
%options.w=15;
%options.step=2;
options.symmetric.sigma=19.2;
options.symmetric.len=0:2:72;
options.symmetric.sigma0=3;
options.symmetric.alpha=0.01;

options.asymmetric.sigma=16;
options.asymmetric.len=0:2:48;
options.asymmetric.sigma0=2;
options.asymmetric.alpha=0.1;



final=Azzopardi2015(imcomplement(preprocesada), mask, 0, options);
figure,
imshow(final(:,:));