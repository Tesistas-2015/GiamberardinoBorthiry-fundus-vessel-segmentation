myDir = 'dataset/GER7/';
destDir = 'dataset/GER7/';
%myDir = 'DataSet/vesselSegmentation/GER7/';
ext_img = '*.bmp';
a = dir([myDir ext_img]);
nfile = max(size(a)) ;  % number of image files
for i=1:nfile
  my_img(i).img = imread([myDir a(i).name]);
  for j=121:171
    if (rem(j,2)==0)
        continue;
    end;
    %filtro = fspecial('average',j);
    %media = imfilter(my_img(i).img,filtro);
    mediana = medfilt2(my_img(i).img,[j j]);
    save(strcat(destDir,a(i).name,int2str(j),'x',int2str(j),'.mat'),'mediana');
    sprintf('Generada ventana %dx%d',j,j);
  end;
end;


%%
clc;
clear;
close all;

% m_cant=4;
% i_cant=1;
% I = [];
% %I(1).img = im2double(imread('dataset/GER7/GER1.bmp'));
% I(1).img = im2double(imread('dataset/GER7/GER2.bmp'));
% %I(3).img = im2double(imread('dataset/GER7/GER3.bmp'));
% %I(4).img = im2double(imread('dataset/GER7/GER4.bmp'));
% 
% 
% %GT(1).img = imread('dataset/GER7-GT/GER1-GT.png');
% GT(1).img = imread('dataset/GER7-GT/GER2-GT.png');
% %GT(3).img = imread('dataset/GER7-GT/GER3-GT.png');
% %GT(4).img = imread('dataset/GER7-GT/GER4-GT.png');
% 
% metodos(1).m='none';
% metodos(2).m='anisodiff';
% metodos(3).m='median';
% metodos(4).m='coherence';
% leyendas={'none','anisodiff','median','coherence'};



myDir = 'dataset/GER7/';
gtDir = 'dataset/GER7-GT/';
%myDir = 'DataSet/vesselSegmentation/GER7/';
ext_img = '*.bmp';
a = dir([myDir ext_img]);
nfile = max(size(a)) ;  % number of image files
for i=1:nfile
    imgorig = im2double(imread([myDir a(i).name]));
    name=strsplit(a(i).name,'.');
    nombre=strcat(gtDir,name(1),'-GT.png');
    GT = imread(cast(nombre,'char'));
    GT_aux = (GT+GT)-1;
    GT_comp(i).data=GT_aux;
    for j=81:81
        if(rem(j,2)==0)
            continue;
        end;
        load(strcat(myDir,a(i).name,int2str(j),'x',int2str(j),'.mat'),'mediana');
        imgorig2 = imgorig-im2double(mediana);
        imgorig2=adapthisteq(imgorig2);
%         figure(1),imshow(imgorig2),title(int2str(j));
        [TPR,TNR,info]=vl_roc(GT_aux,imgorig2);
        result(i).data = imgorig2;
        [myDir a(i).name]
        info.auc
    end;
end;
'termino'

%%
imgorig3=preprocess(result(3).data,'anisodiff');
[TPR,TNR,info]=vl_roc(GT_comp(3).data,imgorig3);
        [myDir a(i).name]
        info
%%
figure(1),imshow(imgorig3);        
%%
figure(1),imshow(result(1).data);
figure(2),imshow(result(2).data);
figure(3),imshow(result(3).data);
figure(4),imshow(result(4).data);
%%