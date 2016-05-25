clc;
clear;
close all;

% I = array(im2double(imread('dataset/GER7/GER1.bmp')),...
%      im2double(imread('dataset/GER7/GER2.bmp')),...
%      im2double(imread('dataset/GER7/GER3.bmp')),...
%      im2double(imread('dataset/GER7/GER4.bmp'))...
%      );
m_cant=4;
f_cant=2;
i_cant=4;
I = [];
%I(1).img = im2double(imread('dataset/GER7/GER1.bmp'));
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

medfile(1).name = 'dataset/GER7/GER1.bmp';
medfile(2).name = 'dataset/GER7/GER2.bmp';
medfile(3).name = 'dataset/GER7/GER3.bmp';
medfile(4).name = 'dataset/GER7/GER4.bmp';



GT(1).img = imread('dataset/GER7-GT/GER1-GT.png');
GT(2).img = imread('dataset/GER7-GT/GER2-GT.png');
GT(3).img = imread('dataset/GER7-GT/GER3-GT.png');
GT(4).img = imread('dataset/GER7-GT/GER4-GT.png');

fondo(1).m='median';
fondo(2).m='average';


metodos(1).m='none';

metodos(2).m='anisodiff';
metodos(2).args.iterations=0;
metodos(2).args.delta_t=1/20;
metodos(2).args.kappa=70;

% metodos(2).n=1;
% metodos(2).arg(1)=1;
% metodos(2).args(1).min=0;
% metodos(2).args(1).delta=1;
% metodos(2).args(1).max=50;
% metodos(2).args(1).data=0;
% metodos(2).args(2).data=1/20;
% metodos(2).args(3).data=70;

metodos(3).m='median';
metodos(3).n=1;
metodos(3).args(1).min=0;
metodos(3).args(1).delta=1;
metodos(3).args(1).max=50;

metodos(4).m='coherence';
metodos(4).n=1;
metodos(4).args(1).min=0;
metodos(4).args(1).delta=1;
metodos(4).args(1).max=50;


global fid
global fidcsv
fid = fopen('CoherenciaMedianaDatos.log','at');
fidcsv = fopen('CoherenciaMedianaDatos.csv','at');
%%
for i=1:i_cant
    %load(strcat(medfile(i).name,int2str(k),'x',int2str(k),'.mat'),'mediana');
    %image=adapthisteq(I(i).img-im2double(mediana));
    metodos(2).args.iterations=10;
    metodos(2).args.filename=I(i).name;
    metodos(2).args.directory='pre_process/';
    image=adapthisteq(I(i).img);
    Inorm = (image-min(image(:)))/(max(image(:))-min(image(:)));
    data=preprocess(Inorm,metodos(2).m,metodos(2).args);
end;

%%
% Metodo Anisodiff:
%   Vario solo iteraciones
auc=0;
resultados = zeros(2,2,'double');
tmp=[];
metodos(2).args.iterations=1;
for k=103:109
    if (rem(k,2)==0)
        continue;
    end;
    load(strcat(medfile(1).name,int2str(k),'x',int2str(k),'.mat'),'mediana');
    tmp(1).mask = getmask(I(1).img);
    tmp(1).img = adapthisteq(I(1).img-im2double(mediana));
    tmp(1).img = (tmp(1).img-min(tmp(1).img(:)))/(max(tmp(1).img(:))-min(tmp(1).img(:)));
    load(strcat(medfile(2).name,int2str(k),'x',int2str(k),'.mat'),'mediana');
    tmp(2).mask = getmask(I(2).img);
    tmp(2).img = adapthisteq(I(2).img-im2double(mediana));
    tmp(2).img = (tmp(2).img-min(tmp(2).img(:)))/(max(tmp(2).img(:))-min(tmp(2).img(:)));
    load(strcat(medfile(3).name,int2str(k),'x',int2str(k),'.mat'),'mediana');
    tmp(3).mask = getmask(I(3).img);
    tmp(3).img = adapthisteq(I(3).img-im2double(mediana));
    tmp(3).img = (tmp(3).img-min(tmp(3).img(:)))/(max(tmp(3).img(:))-min(tmp(3).img(:)));
    load(strcat(medfile(4).name,int2str(k),'x',int2str(k),'.mat'),'mediana');
    tmp(4).mask = getmask(I(4).img);
    tmp(4).img = adapthisteq(I(4).img-im2double(mediana));
    tmp(4).img = (tmp(4).img-min(tmp(4).img(:)))/(max(tmp(4).img(:))-min(tmp(4).img(:)));
    for j=1:150
        scores=[];
        labels=[];
        for i=1:i_cant
            image=tmp(i).img;
            mask=logical(tmp(i).mask);
            %preprocess(image,metodos(2).m,metodos(2).args);
            data=CoherenceFilter(image,struct('T',1));
            %CoherenceFilter(toprocess,struct('T',1,'rho',1,'Scheme','O'));
            %preprocess(image,metodos(2).m,metodos(2).args);
            tmp(i).img=data;
            GT_aux = (GT(i).img+GT(i).img)-1;
            scores=vertcat(scores(:),data(mask));
            labels=vertcat(labels(:),GT_aux(mask));
        end;
        [TPR,TNR,info]=vl_roc(labels,scores);
%        indice=(k-1)/2;
%        resultados(indice,j) = double(info.auc);
        fprintf(fid, '%ix%i, %i\n',k,k,j);
        fprintf(fidcsv, '%i, %i, %f, %f\n',k,j,info.auc,info.eer);
%        if (info.auc>auc)
%            auc=info.auc;
%            mejor_k=k;
%            mejor_j=j;
%        end;
    end;
end;
fclose(fid);
%%
% Metodo Anisodiff:
%   Busqueda con saltos grandes
auc=0;
resultados = zeros(2,2,'double');
tmp=[];
metodos(2).args.iterations=1;
for k=139:139
    if (rem(k,2)==0)
        continue;
    end;
    
    %%filtro = fspecial('average',k);
    mediana = medfilt2(I(1).int,[k k]);
    %%media = imfilter(I(1).img,filtro);
    tmp(1).mask = getmask(I(1).img);
    tmp(1).img = adapthisteq(I(1).img-im2double(mediana));
    tmp(1).img = (tmp(1).img-min(tmp(1).img(:)))/(max(tmp(1).img(:))-min(tmp(1).img(:)));
    %%media = imfilter(I(2).img,filtro);
    mediana = medfilt2(I(2).int,[k k]);
    tmp(2).mask = getmask(I(2).img);
    tmp(2).img = adapthisteq(I(2).img-im2double(mediana));
    tmp(2).img = (tmp(2).img-min(tmp(2).img(:)))/(max(tmp(2).img(:))-min(tmp(2).img(:)));
    %%media = imfilter(I(3).img,filtro);
    mediana = medfilt2(I(4).int,[k k]);
    tmp(3).mask = getmask(I(3).img);
    tmp(3).img = adapthisteq(I(3).img-im2double(mediana));
    tmp(3).img = (tmp(3).img-min(tmp(3).img(:)))/(max(tmp(3).img(:))-min(tmp(3).img(:)));
    %%media = imfilter(I(4).img,filtro);
    mediana = medfilt2(I(4).int,[k k]);
    tmp(4).mask = getmask(I(4).img);
    tmp(4).img = adapthisteq(I(4).img-im2double(mediana));
    tmp(4).img = (tmp(4).img-min(tmp(4).img(:)))/(max(tmp(4).img(:))-min(tmp(4).img(:)));
    for j=1:150
        scores=[];
        labels=[];
        for i=1:i_cant
            image=tmp(i).img;
            mask=logical(tmp(i).mask);
            %preprocess(image,metodos(2).m,metodos(2).args);
            data=CoherenceFilter(image,struct('T',1));
            %data=CoherenceFilter(image,struct('T',1,'rho',1,'Scheme','O','eigenmode','3'));
            %preprocess(image,metodos(2).m,metodos(2).args);
            tmp(i).img=data;
            GT_aux = (GT(i).img+GT(i).img)-1;
            scores=vertcat(scores(:),data(mask));
            labels=vertcat(labels(:),GT_aux(mask));
        end;
        [TPR,TNR,info]=vl_roc(labels,scores);
%        indice=(k-1)/2;
%        resultados(indice,j) = double(info.auc);
        fprintf(fid, '%ix%i, %i\n',k,k,j);
        fprintf(fidcsv, '%i, %i, %f, %f\n',k,j,info.auc,info.eer);
%        if (info.auc>auc)
%            auc=info.auc;
%            mejor_k=k;
%            mejor_j=j;
%        end;
    end;
end;
fclose(fid);


%%
% Metodo Anisodiff:
%   Vario solo iteraciones
auc=0;
resultados = zeros(2,2,'double');
metodos(2).args.iterations=70;
metodos(2).args.directory='pre_process/';

for k=83:119
    if (rem(k,2)==0)
        continue;
    end;
    for i=1:i_cant
        load(strcat(medfile(i).name,int2str(k),'x',int2str(k),'.mat'),'mediana');
        image=adapthisteq(I(i).img-im2double(mediana));
        %image=adapthisteq(I(i).img);
        Inorm = (image-min(image(:)))/(max(image(:))-min(image(:)));
        metodos(2).args.filename=strcat(I(i).name, int2str(k),'x',int2str(k));
        data=preprocess(Inorm,metodos(2).m,metodos(2).args);
    end;
    for h=1:metodos(2).args.iterations
        scores=[];
        labels=[];
        for i=1:i_cant
            load(strcat(metodos(2).args.directory,I(i).name, int2str(k),'x',int2str(k),'x',int2str(h),'.mat'),'diff_im');
            GT_aux = (GT(i).img+GT(i).img)-1;
            scores=[scores,diff_im];
            labels=[labels,GT_aux];
            delete(strcat(metodos(2).args.directory,I(i).name, int2str(k),'x',int2str(k),'x',int2str(h),'.mat'));
        end;
        [TPR,TNR,info]=vl_roc(labels,scores);
        fprintf(fid, '%ix%i, %i\n',k,k,h);
        fprintf(fidcsv, '%i, %i, %f, %f\n',k,h,info.auc,info.eer);
    end;
end;
%end;
fclose(fid);


%%
% Generar una imagen
clc
clear all
close all
image = im2double(imread('dataset/GER7/GER2.bmp'));
load(strcat('dataset/GER7/average/GER2.bmp119x119.mat'),'media');
img = adapthisteq(image-im2double(media));
img = (img-min(img(:)))/(max(img(:))-min(img(:)));
metodos(2).m='anisodiff';
metodos(2).args.iterations=70;
metodos(2).args.delta_t=1/20;
metodos(2).args.kappa=70;
result=preprocess(img,metodos(2).m,metodos(2).args);
figure,imshow(result);
%%
clc
clear all
close all
image = imread('dataset/GER7/GER2.bmp');
filtro = fspecial('average',119);
media = imfilter(image,filtro);
img = adapthisteq(im2double(image)-im2double(media));
img = (img-min(img(:)))/(max(img(:))-min(img(:)));
imshow(img);
%%
umbralar = img;
t = graythresh(umbralar);
umbralada=umbralar;
umbralada(umbralar <= t)=0;
umbralada(umbralar > t)=1;
figure,imshow(umbralada);