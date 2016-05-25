function [labels,data] = linearPlot(path)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    data = csvread(path);
    
    fileSize = size(data);
    matriz=[];
    ventanas=[];
    for i=1:fileSize(1)
        ventanas(i)=data(i,1);
        matriz(i)=data(i,3);
    end;
    data=matriz;
    labels=ventanas;
end

