%%
%
%   En este script podemos realizar pruebas y los resultados se iran
%   cargando en el archivo que se levanta (testing.data).
%
%

%%
clear;
close all;
clc;
%%
%Cargo la imagen y normalizo
I = im2double(imread('dataset/GER7TH/GER1.bmp'));
GT = im2double(imread('dataset/GER7-GTTH/GER1-GT.png'));
Inorm = (I-min(I(:)))/(max(I(:))-min(I(:)));

%Calculo la mascara
I2=Inorm + Inorm;
mask=I2;
mask(I2 > (30/255))=1;
mask(I2 <= (30/255))=0;

%Preproceso
[preprocessed,background] = preprocess_v1(I,mask);

file=fopen('testing.data','at');

%Defino los parametros a utilizar en el filtro de coherencia
%FALTA: faltaria parametrizar los valores de preprocesamiento y agregarlo
%al savedata de alguna manera para que se guarden
options=struct('T',3, ...
               'rho',2, ...
               'sigma',0.25, ...
               'eigenmode',4, ...
               'lambda_c',1, ...
               'lambda_e',0, ...
               'lambda_h',0.5);
           
filtered_image = CoherenceFilter(preprocessed,options);
segm=segmentation(filtered_image,mask);
[area,error,threshold]=area_roc(GT,segm);

%Armo los resultados
results=struct('area',area, ...
               'error',error, ...
               'threshold',threshold);

%Guardo los resultados           
savedata(options,results,file);
fprintf(file,'\n');
fclose(file);
