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

GT(1).img = imread('dataset/GER7-GT/GER1-GT.png');
GT(2).img = imread('dataset/GER7-GT/GER2-GT.png');
GT(3).img = imread('dataset/GER7-GT/GER3-GT.png');
GT(4).img = imread('dataset/GER7-GT/GER4-GT.png');


%% Anisotropico con Mediana

% Parametros obtenidos:
% 
% Iteraciones: 19
% Tamaño de ventana: 115
% Valor de area: 
metodos(1).m='anisodiff';
metodos(1).args.delta_t=1/20;
metodos(1).args.kappa=70;
metodos(1).args.iterations=19;

scores=[];
labels=[];
options = struct('sigmas', sqrt([10 18 26 34 42]));
for k=1:4
    mediana = medfilt2(I(k).int,[115 115]); 
    mask = getmask(I(k).img);
    sin_fondo = adapthisteq(I(k).img-im2double(mediana));
    normalizada = (sin_fondo-min(sin_fondo(:)))/(max(sin_fondo(:))-min(sin_fondo(:)));
    mask=logical(mask);
    preprocesada= preprocess(normalizada,metodos(1).m,metodos(1).args);
    data= MatchedFilterResponses(imcomplement(preprocesada), mask, 0, options);
 
    GT_aux = (GT(k).img+GT(k).img)-1;
    scores=vertcat(scores(:),data(mask));
    labels=vertcat(labels(:),GT_aux(mask));

end;
%%
figure,vl_roc(labels,scores);
figure,vl_pr(labels,scores);
