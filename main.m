%%
%Cargo la imagen
clc;
clear;
close all;

% I = array(im2double(imread('dataset/GER7/GER1.bmp')),...
%      im2double(imread('dataset/GER7/GER2.bmp')),...
%      im2double(imread('dataset/GER7/GER3.bmp')),...
%      im2double(imread('dataset/GER7/GER4.bmp'))...
%      );
m_cant=1;
i_cant=4;
I = [];
%I(1).img = im2double(imread('dataset/GER7/GER1.bmp'));
load(strcat('dataset/GER7/GER1.bmp81x81.mat'),'mediana');
I(1).img = adapthisteq(im2double(imread('dataset/GER7/GER1.bmp')) - im2double(mediana));
load(strcat('dataset/GER7/GER2.bmp81x81.mat'),'mediana');
I(2).img = adapthisteq(im2double(imread('dataset/GER7/GER2.bmp')) - im2double(mediana));
load(strcat('dataset/GER7/GER3.bmp81x81.mat'),'mediana');
I(3).img = adapthisteq(im2double(imread('dataset/GER7/GER3.bmp')) - im2double(mediana));
load(strcat('dataset/GER7/GER4.bmp81x81.mat'),'mediana');
I(4).img = adapthisteq(im2double(imread('dataset/GER7/GER4.bmp')) - im2double(mediana));


GT(1).img = imread('dataset/GER7-GT/GER1-GT.png');
GT(2).img = imread('dataset/GER7-GT/GER2-GT.png');
GT(3).img = imread('dataset/GER7-GT/GER3-GT.png');
GT(4).img = imread('dataset/GER7-GT/GER4-GT.png');

% metodos(1).m='none';
metodos(1).m='anisodiff';
% metodos(3).m='median';
% metodos(4).m='coherence';
% leyendas={'none','anisodiff','median','coherence'};

metodos(2).m='anisodiff';
metodos(2).args.filename='anisodiffprueba';
metodos(2).args.directory='pre_process/';
metodos(2).args.iterations=10;
metodos(2).args.delta_t=1/20;
metodos(2).args.kappa=70;


%%
for j=1:m_cant
    scores=[];
    labels=[];
    for i=1:i_cant
        image=I(i).img;
        Inorm = (image-min(image(:)))/(max(image(:))-min(image(:)));
        img(i,j).data=preprocess(Inorm,metodos(j).m,metodos(2).args);
        GT_aux = (GT(i).img+GT(i).img)-1;
        scores=[scores,img(i,j).data];
        labels=[labels,GT_aux];
        %figure(j+1),imshow(img),title(sprintf('Metodo: %s',metodos(j).m));
    end;
    [TPR(j).data,TNR(j).data,INFO(j).info]=vl_roc(labels,scores);
    %sprintf('Metodo: %s -> aau: %f',metodos(j).m,INFO.auc);
    %data(j)=[TPR,TNR];
end;
%figure(1),title('Comparativo de algoritmos');
%%
figure(6666);
for j=1:m_cant
    subplot(2,2,j),imshow(img(1,j).data);
    title(sprintf('Metodo: %s',metodos(j).m));
end;
figure(7777);
for j=1:m_cant
    j
    subplot(2,2,j),plot(1-TNR(j).data,TPR(j).data),title(sprintf('Metodo: %s -> aau: %f',metodos(j).m,INFO(j).info.auc));
end;


%%
Inorm = (I-min(I(:)))/(max(I(:))-min(I(:)));
% img=preprocess(I);
img=Inorm;
img=adapthisteq(img);
figure,
subplot(1,1,1),imshow(img), title('Imagen 3,1');



%%
I2=Inorm + Inorm;

mask=I2;
mask(I2 > (30/255))=1;
mask(I2 <= (30/255))=0;
% figure,
% subplot(1,1,1),imshow(mask), title('Imagen 3,1');


img=coherence(img,5,15,0.25);

figure,
subplot(1,1,1),imshow(img), title('Imagen 3,1');

% figure,
% subplot(1,1,1),imshow(mask), title('Imagen 3,1');

%%
adapted = adapthisteq(img);
figure,
subplot(1,1,1),imshow(adapted), title('Imagen 3,1');
%%
media=preprocess(img);
media_realzada = adapthisteq(media);
figure,
subplot(1,1,1),imshow(media_realzada), title('Imagen 3,1');
%%
threshold=0.51;
segm = media_realzada;
segm = 1-segm;
segm(img <= threshold) = 0;
segm(img > threshold) = 1;
se = strel('disk',2);
erodedmask = imerode(mask,se);
segm(erodedmask < 1) = 0;

segm=logical(segm);
figure,
subplot(1,1,1),imshow(segm), title('Imagen 3,10');
%%
 % segm=imclose(segm,se);
img2=coherence(segm,20,2,0.25);
%%
segm=img2;
segm(img2 <= threshold) = 0;
segm(img2 > threshold) = 1;
segm(mask < 1) = 0;
figure, 
    subplot(1,1,1), 
        imshow(segm), 
        title('Imagen 3,10');
%%
