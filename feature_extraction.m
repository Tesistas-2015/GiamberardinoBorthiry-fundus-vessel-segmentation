clc;
clear all;
close all;

GER(1).img = im2double(imread('dataset/GER7/GER1.bmp'));
GER(1).int = imread('dataset/GER7/GER1.bmp');
GER(1).name = 'GER1';
GER(2).img = im2double(imread('dataset/GER7/GER2.bmp'));
GER(2).name = 'GER2';
GER(2).int = imread('dataset/GER7/GER2.bmp');
GER(3).img = im2double(imread('dataset/GER7/GER3.bmp'));
GER(3).name = 'GER3';
GER(3).int = imread('dataset/GER7/GER3.bmp');
GER(4).img = im2double(imread('dataset/GER7/GER4.bmp'));
GER(4).name = 'GER4';
GER(4).int = imread('dataset/GER7/GER4.bmp');

GERGT(1).img = imread('dataset/GER7-GT/GER1-GT.png');
GERGT(2).img = imread('dataset/GER7-GT/GER2-GT.png');
GERGT(3).img = imread('dataset/GER7-GT/GER3-GT.png');
GERGT(4).img = imread('dataset/GER7-GT/GER4-GT.png');


AMD(1).img = im2double(imread('dataset/AMD14/AMD1.png'));
AMD(1).int = imread('dataset/AMD14/AMD1.png');
AMD(1).name = 'AMD1';
AMD(2).img = im2double(imread('dataset/AMD14/AMD2.png'));
AMD(2).int = imread('dataset/AMD14/AMD2.png');
AMD(2).name = 'AMD2';
AMD(3).img = im2double(imread('dataset/AMD14/AMD3.png'));
AMD(3).int = imread('dataset/AMD14/AMD3.png');
AMD(3).name = 'AMD3';
AMD(4).img = im2double(imread('dataset/AMD14/AMD4.png'));
AMD(4).int = imread('dataset/AMD14/AMD4.png');
AMD(4).name = 'AMD4';

AMDGT(1).img = imread('dataset/AMD14-GT/AMD1-GT.png');
AMDGT(2).img = imread('dataset/AMD14-GT/AMD2-GT.png');
AMDGT(3).img = imread('dataset/AMD14-GT/AMD3-GT.png');
AMDGT(4).img = imread('dataset/AMD14-GT/AMD4-GT.png');

%% Generate preprocessed images fro GER7 and AMD14
% for i=1:4
%     [preprocesada,mask] = preprocesar(GER(i).int);
%     save(strcat('dataset/preprocesadas/GER/',GER(i).name,'.mat'),'preprocesada','mask');
% end
% 
% for i=1:4
%     [preprocesada, mask] = preprocesar(AMD(i).int);
%     save(strcat('dataset/preprocesadas/AMD/',AMD(i).name,'.mat'),'preprocesada','mask');
% end

%% Training each of the features algorithms using AMD
%% Azzopardi Training

values(1).options.symmetric.sigma=2.7;
values(1).options.symmetric.len=0:2:12;
values(1).options.asymmetric.sigma=2.4;
values(1).options.asymmetric.len=0:2:18;
values(2).options.symmetric.sigma=3.2;
values(2).options.symmetric.len=0:2:16;
values(2).options.asymmetric.sigma=2.8;
values(2).options.asymmetric.len=0:2:24;
values(3).options.symmetric.sigma=4.8;
values(3).options.symmetric.len=0:2:20;
values(3).options.asymmetric.sigma=4.5;
values(3).options.asymmetric.len=0:2:26;
values(4).options.symmetric.sigma=5.4;
values(4).options.symmetric.len=0:2:22;
values(4).options.asymmetric.sigma=5.2;
values(4).options.asymmetric.len=0:2:28;
values(5).options.symmetric.sigma=6.5;
values(5).options.symmetric.len=0:2:24;
values(5).options.asymmetric.sigma=5.9;
values(5).options.asymmetric.len=0:2:30;
values(6).options.symmetric.sigma=7.7;
values(6).options.symmetric.len=0:2:26;
values(6).options.asymmetric.sigma=7.4;
values(6).options.asymmetric.len=0:2:32;
values(7).options.symmetric.sigma=8.8;
values(7).options.symmetric.len=0:2:32;
values(7).options.asymmetric.sigma=8.2;
values(7).options.asymmetric.len=0:2:38;
values(8).options.symmetric.sigma=9.5;
values(8).options.symmetric.len=0:2:36;
values(8).options.asymmetric.sigma=9.1;
values(8).options.asymmetric.len=0:2:42;



figure(1);
i=1;
list_precision = cell(length(values),1);
list_recall = cell(length(values),1);
aucs = zeros(length(values),1);
for s=1:length(values)
    options.symmetric.sigma = values(s).options.symmetric.sigma;
    options.symmetric.len = values(s).options.symmetric.len;
    options.asymmetric.sigma = values(s).options.asymmetric.sigma;
    options.asymmetric.len = values(s).options.asymmetric.len;
    scores=[];
    labels=[];
    fprintf('\rIteration %d\n',s);
    for k=1:4
        fprintf('\rIteration k %d\n',k);
        load(strcat('dataset/preprocesadas/GER/',GER(k).name,'.mat'),'preprocesada','mask');
        [data, ~] = extractFeature('Azzopardi',preprocesada,mask,options);
        GT_aux = (GERGT(k).img+GERGT(k).img)-1;
        scores=vertcat(scores(:),data(mask));
        labels=vertcat(labels(:),GT_aux(mask));
    end
    [recall, precision, info] = vl_pr(labels,scores);
    list_precision{s} = precision;
    list_recall{s} = recall;
    aucs(s) = info.auc;
    legendInfo{i} = [strcat(num2str(s),' (',num2str(info.auc),')')];
    i=i+1;
end

[~, idx] = max(aucs);
figure(1);
hold on
box on
grid on
xlabel('Recall')
ylabel('Precision')
for s = 1 : length(values)
    if s==idx
        plot(list_recall{s},list_precision{s}, 'LineWidth', 2);
    else
        plot(list_recall{s},list_precision{s});
    end
end
legend(legendInfo,'Location','southwest');
hold off


%% Frangi Training

figure(1);
i=1;

for s=3:2:17
    options.FrangiScaleRange = [0 s];
    scores=[];
    labels=[];
    for k=1:4
        load(strcat('dataset/preprocesadas/GER/',GER(k).name,'.mat'),'preprocesada','mask');
        [data, ~] = extractFeature('Frangi',preprocesada,mask,options);
        GT_aux = (GERGT(k).img+GERGT(k).img)-1;
        scores=vertcat(scores(:),data(mask));
        labels=vertcat(labels(:),GT_aux(mask));
    end
    [recall, precision, info] = vl_pr(labels,scores);
    list_precision{i} = precision;
    list_recall{i} = recall;
    aucs(i) = info.auc;
    legendInfo{i} = ['\sigma = ',strcat(num2str(s),' (',num2str(info.auc),')')];
    i=i+1;
end
[~, idx] = max(aucs);
xlabel('Recall')
ylabel('Precision')
hold on
box on
grid on
for s = 1 : i-1
    if s==idx
        plot(list_recall{s},list_precision{s}, 'LineWidth', 2);
    else
        plot(list_recall{s},list_precision{s});
    end
end
legend(legendInfo,'Location','southwest');
hold off

%% MatchedFilter Training

figure(1);
i=1;
% values(1).sigmas = sqrt([1 2 4 6 8]);
% values(2).sigmas = sqrt([2 6 12 18 24]);
% values(3).sigmas = sqrt([3 11 17 23 29]);
% values(4).sigmas = sqrt([4 12 20 28 36]);
% values(5).sigmas = sqrt([5 15 25 35 45]);
% values(6).sigmas = sqrt([6 17 28 39 50]);
% values(7).sigmas = sqrt([7 19 31 43 55]);
% values(8).sigmas = sqrt([8 21 34 47 60]);
for s=8:fix((50-8)/8):50
    options.sigmas = sqrt([2:((s-2)/5):s]); % suponemos 5 calibres de vasos
    scores=[];
    labels=[];
    for k=1:4
        fprintf('\rIteration k %d\n',k);
        load(strcat('dataset/preprocesadas/GER/',GER(k).name,'.mat'),'preprocesada','mask');
        [data, ~] = extractFeature('MatchedFilter',preprocesada,mask,options);
        GT_aux = (GERGT(k).img+GERGT(k).img)-1;
        scores=vertcat(scores(:),data(mask));
        labels=vertcat(labels(:),GT_aux(mask));
    end
    fprintf('\rIteration %d\n',s);
    [recall, precision, info] = vl_pr(labels,scores);
    list_precision{i} = precision;
    list_recall{i} = recall;
    aucs(i) = info.auc;
    legendInfo{i} = [strcat('\sigma = ','[','2:',num2str((s-2)/5),':',num2str(s),']',' (',num2str(info.auc),')')];
    i=i+1;
end
fprintf('\rsalio %d\n',s);
[~, idx] = max(aucs);
xlabel('Recall')
ylabel('Precision')
hold on
box on
grid on
for s = 1 : i-2
    if s==idx
        plot(list_recall{s},list_precision{s}, 'LineWidth', 2);
    else
        plot(list_recall{s},list_precision{s});
    end
end
legend(legendInfo,'Location','southwest');
hold off


%% sumoftophat

figure(1);
i=1;

for s=10:5:45
    options.length = s;
    scores=[];
    labels=[];
    fprintf('\rIteration %d\n',s);
    for k=1:4
        fprintf('\rIteration k %d\n',k);
        load(strcat('dataset/preprocesadas/GER/',GER(k).name,'.mat'),'preprocesada','mask');
        [data, ~] = extractFeature('TopHat',preprocesada,mask,options);
        GT_aux = (GERGT(k).img+GERGT(k).img)-1;
        scores=vertcat(scores(:),data(mask));
        labels=vertcat(labels(:),GT_aux(mask));
    end
    [recall, precision, info] = vl_pr(labels,scores);
    list_precision{i} = precision;
    list_recall{i} = recall;
    aucs(i) = info.auc;
    legendInfo{i} = ['L = ',strcat(num2str(s),' (',num2str(info.auc),')')];
    i=i+1;
end
[~, idx] = max(aucs);
xlabel('Recall')
ylabel('Precision')
hold on
box on
grid on
for s = 1 : i-1
    if s==idx
        plot(list_recall{s},list_precision{s}, 'LineWidth', 2);
    else
        plot(list_recall{s},list_precision{s});
    end
end
legend(legendInfo,'Location','southwest');
hold off

%% Soares

figure(1);
i=1;

for s=1:5
    options.scales = [1/2:1/2:s];
    scores=[];
    labels=[];
    fprintf('\rIteration %d\n',s);
    for k=1:4
        fprintf('\rIteration k %d\n',k);
        load(strcat('dataset/preprocesadas/GER/',GER(k).name,'.mat'),'preprocesada','mask');
        [data, ~] = extractFeature('Soares',preprocesada,mask,options);
        GT_aux = (GERGT(k).img+GERGT(k).img)-1;
        scores=vertcat(scores(:),data(mask));
        labels=vertcat(labels(:),GT_aux(mask));
    end
    [recall, precision, info] = vl_pr(labels,scores);
    list_precision{i} = precision;
    list_recall{i} = recall;
    aucs(i) = info.auc;
    legendInfo{i} = [strcat('S =','[',num2str(1/2),':',num2str(1/2),':',num2str(s),']',' (',num2str(info.auc),')')];
    i=i+1;
end
[~, idx] = max(aucs);
xlabel('Recall')
ylabel('Precision')
hold on
box on                                        
grid on
for s = 1 : i-1
    if s==idx
        plot(list_recall{s},list_precision{s}, 'LineWidth', 2);
    else
        plot(list_recall{s},list_precision{s});
    end
end
legend(legendInfo,'Location','southwest');
hold off



%% NGuyen
values(1).options.w=5;
values(1).options.step=2;
values(1).options.first=1;
values(2).options.w=10;
values(2).options.step=2;
values(2).options.first=1;
values(3).options.w=15;
values(3).options.step=3;
values(3).options.first=3;
values(4).options.w=20;
values(4).options.step=3;
values(4).options.first=3;
values(5).options.w=25;
values(5).options.step=3;
values(5).options.first=5;
values(6).options.w=30;
values(6).options.step=5;
values(6).options.first=5;
values(7).options.w=35;
values(7).options.step=5;
values(7).options.first=7;
values(8).options.w=40;
values(8).options.step=7;
values(8).options.first=7;

figure(1);
i=1;
for s=1:8
    options.w = values(s).options.w;
    options.first = values(s).options.first;
    options.step = values(s).options.step;
    scores=[];
    labels=[];
    fprintf('\rIteration %d\n',s);
    for k=1:4
        fprintf('\rIteration k %d\n',k);
        load(strcat('dataset/preprocesadas/GER/',GER(k).name,'.mat'),'preprocesada','mask');
        [data, ~] = extractFeature('Nguyen',preprocesada,mask,options);
        GT_aux = (GERGT(k).img+GERGT(k).img)-1;
        scores=vertcat(scores(:),data(mask));
        labels=vertcat(labels(:),GT_aux(mask));
    end
    [recall, precision, info] = vl_pr(labels,scores);
    list_precision{i} = precision;
    list_recall{i} = recall;
    aucs(i) = info.auc;
    legendInfo{i} = [strcat(num2str(s),' (',num2str(info.auc),')')];
    i=i+1;
end
[~, idx] = max(aucs);
xlabel('Recall')
ylabel('Precision')
hold on
box on
grid on
for s = 1 : i-1
    if s==idx
        plot(list_recall{s},list_precision{s}, 'LineWidth', 2);
    else
        plot(list_recall{s},list_precision{s});
    end
end
legend(legendInfo,'Location','southwest');
hold off


%% Zana 

figure(1);
i=1;

for s=10:5:45
    options.l = s;
    scores=[];
    labels=[];
    fprintf('\rIteration %d\n',s);
    for k=1:4
        fprintf('\rIteration k %d\n',k);
        load(strcat('dataset/preprocesadas/GER/',GER(k).name,'.mat'),'preprocesada','mask');
        [data, ~] = extractFeature('Zana',preprocesada,mask,options);
        z2 = data;
        z2(z2>0) = 0;
        data=imcomplement(z2);
        GT_aux = (AMDGT(k).img+AMDGT(k).img)-1;
        scores=vertcat(scores(:),data(mask));
        labels=vertcat(labels(:),GT_aux(mask));
    end
    [recall, precision, info] = vl_pr(labels,scores);
   list_precision{i} = precision;
    list_recall{i} = recall;
    aucs(i) = info.auc;
    legendInfo{i} = ['L = ',strcat(num2str(s),' (',num2str(info.auc),')')];
    i=i+1;
end
[~, idx] = max(aucs);
xlabel('Recall')
ylabel('Precision')
hold on
box on
grid on
for s = 1 : i-1
    if s==idx
        plot(list_recall{s},list_precision{s}, 'LineWidth', 2);
    else
        plot(list_recall{s},list_precision{s});
    end
end
legend(legendInfo,'Location','southwest');
hold off



%% evaluation 

