function [img,rows,columns] = generateColorMap( path)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    data = csvread(path);
    dataSize=size(data(:,1));
    matriz=[];
    columnLabels=[];
    rowLabels=[];
    min = 1;

    minV = data(1,1)-1;
    for i=1:dataSize(1)
        rowLabels((data(i,1)-minV))=data(i,1);
        columnLabels(data(i,2))=data(i,2);
        matriz((data(i,1)-minV),data(i,2))= data(i,3)*10000;
        matriz((data(i,1)-minV+1),data(i,2))= data(i,3)*10000;
    end;
    img=matriz;
    rows=rowLabels;
    columns=columnLabels;
end

