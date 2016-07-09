%% Anisodiff Mediana
data = csvread('Anisodiff_Mediana_VxI_Centrado.csv');
%% Anisodiff Media
data = csvread('Anisodiff_Media_VxI_Centrado.csv');
%% Coherence Mediana
data = csvread('Coherence_Mediana_VxI_Centrado.csv');
%% Coherence Media
data = csvread('Coherence_Media_VxI_Centrado.csv');
%%
clc
clear all
close all
[medAnisodiff,mar,mac] = generateColorMap('Anisodiff_Mediana_VxI_Centrado.csv');
[avgAnisodiff,aar,aac] = generateColorMap('Anisodiff_Media_VxI_Centrado.csv');
[medCoherence,mcr,mcc] = generateColorMap('Coherence_Mediana_VxI_Centrado.csv');
[avgCoherence,acr,acc] = generateColorMap('Coherence_Media_VxI_Centrado.csv');
figure, contourf(medAnisodiff,500,'LineWidth',0),colormap(hot);%title('Anisodiff with Median');
figure, contourf(avgAnisodiff,500,'LineWidth',0),colormap(hot);%title('Anisodiff with Average');
figure, contourf(medCoherence,500,'LineWidth',0),colormap(hot);%title('Coherence with Median');
figure, contourf(avgCoherence,500,'LineWidth',0),colormap(hot);%title('Coherence with Average');

%% Con Saltos
clc
clear all
close all
[lblCM,valCM] = linearPlot('Coherence_Mediana_Saltos.csv');
[lblCA,valCA] = linearPlot('Coherence_Media_Saltos.csv');
[lblAM,valAM] = linearPlot('Anisodiff_Mediana_Saltos.csv');
[lblAA,valAA] = linearPlot('Anisodiff_Media_Saltos.csv');
figure,plot(lblCM,valCM), xlabel('Tamaño de ventana'), ylabel('Valor de area ROC (1 iteracion)');%title('Coherence with Median');
savefig('Definitivos/MedianCoherenceJumps.fig');
print('Definitivos/MedianCoherenceJumps.png','-dpng');
figure,plot(lblCA,valCA), xlabel('Tamaño de ventana'), ylabel('Valor de area ROC (1 iteracion)');%title('Coherence with Average');
savefig('Definitivos/AverageCoherenceJumps.fig');
print('Definitivos/AverageCoherenceJumps.png','-dpng');
figure,plot(lblAM,valAM), xlabel('Tamaño de ventana'), ylabel('Valor de area ROC (1 iteracion)');%title('Anisodiff with Median');
savefig('Definitivos/MedianAnisodiffJumps.fig');
print('Definitivos/MedianAnisodiffJumps.png','-dpng');
figure,plot(lblAA,valAA), xlabel('Tamaño de ventana'), ylabel('Valor de area ROC (1 iteracion)');%title('Anisodiff with Average');
savefig('Definitivos/AverageAnisodiffJumps.fig');
print('Definitivos/AverageAnisodiffJumps.png','-dpng');
%% Ventanas Centrado
clc
clear all
close all
[lblCM,valCM] = linearPlot('Coherence_Mediana_Ventana_Centrado.csv');
[lblCA,valCA] = linearPlot('Coherence_Media_Ventana_Centrado.csv');
[lblAM,valAM] = linearPlot('Anisodiff_Mediana_Ventana_Centrado.csv');
[lblAA,valAA] = linearPlot('Anisodiff_Media_Ventana_Centrado.csv');
figure,plot(lblCM,valCM), xlabel('Tamaño de ventana'), ylabel('Valor de area ROC (1 iteracion)');%title('Coherence with Median');
savefig('Definitivos/MedianCoherenceCentered.fig');
print('Definitivos/MedianCoherenceCentered.png','-dpng');
figure,plot(lblCA,valCA), xlabel('Tamaño de ventana'), ylabel('Valor de area ROC (1 iteracion)');%title('Coherence with Median');
savefig('Definitivos/AverageCoherenceCentered.fig');
print('Definitivos/AverageCoherenceCentered.png','-dpng');
figure,plot(lblAM,valAM), xlabel('Tamaño de ventana'), ylabel('Valor de area ROC (1 iteracion)');%title('Coherence with Median');
savefig('Definitivos/MedianAnisodiffCentered.fig');
print('Definitivos/MedianAnisodiffCentered.png','-dpng');
figure,plot(lblAA,valAA), xlabel('Tamaño de ventana'), ylabel('Valor de area ROC (1 iteracion)');%title('Coherence with Median');
savefig('Definitivos/AverageAnisodiffCentered.fig');
print('Definitivos/AverageAnisodiffCentered.png','-dpng');

