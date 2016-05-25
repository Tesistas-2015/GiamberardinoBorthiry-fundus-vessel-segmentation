%%CSV Transformation
%% Transformacion de Anisodiff con Mediana
clc
clear all
close all

size=4130;
matriz=[];
columnLabels=[];
rowLabels=[];
min = 1;

data = csvread('allprocessAnisodiff_Masked.csv');

maxVentana = 0;
maxIteraciones = 0;

bestJump = 0;
bestJumpValue=0;

global fidcsv
fidcsv = fopen('Anisodiff_Mediana_Saltos.csv','at');
for i=1:size
    if ((rem(data(i,1)-1,10)==0)&&(data(i,2)==1))
      fprintf(fidcsv, '%i, 1, %f %f\n',data(i,1),data(i,3),data(i,4));   
      if (data(i,3)>bestJumpValue)
        bestJumpValue = data(i,3);
        bestJump = data(i,1);
      end;
    end;
end;
fclose(fidcsv);

bestWindow=0;
bestWinValue=0;

fidcsv = fopen('Anisodiff_Mediana_Ventana_Centrado.csv','at');
for i=1:size
    if ((data(i,1)>bestJump-20)&&(data(i,1)<bestJump+20)&&(data(i,2)==1))
      fprintf(fidcsv, '%i, 1, %f %f\n',data(i,1),data(i,3),data(i,4));   
      if (data(i,3)>bestWinValue)
        bestWinValue=data(i,3);
        bestWindow=data(i,1);
      end;
    end;
end;
fclose(fidcsv);

bestArea=0;
bestIteracion=0;

fidcsv = fopen('Anisodiff_Mediana_VxI_Centrado.csv','at');
for i=1:size
    if ((data(i,1)>bestWindow-5)&&(data(i,1)<bestWindow+5))
      fprintf(fidcsv, '%i, %i, %f %f\n',data(i,1),data(i,2),data(i,3),data(i,4));   
      if(data(i,3)>bestArea)
        bestArea=data(i,3);
        bestIteracion=data(i,2);
      end;
    end;
end;
fclose(fidcsv);

bestWindow
bestIteracion
bestArea

%% Transformacion de Anisodiff con Media
clc
clear all
close all

size=4130;
matriz=[];
columnLabels=[];
rowLabels=[];
min = 1;

data = csvread('allprocessAnisodiffWithAverage_Masked.csv');

maxVentana = 0;
maxIteraciones = 0;

bestJump = 0;
bestJumpValue=0;

fidcsv = fopen('Anisodiff_Media_Saltos.csv','at');
for i=1:size
    if ((rem(data(i,1)-1,10)==0)&&(data(i,2)==1))
      fprintf(fidcsv, '%i, 1, %f %f\n',data(i,1),data(i,3),data(i,4));   
      if (data(i,3)>bestJumpValue)
        bestJumpValue = data(i,3);
        bestJump = data(i,1);
      end;
    end;
end;
fclose(fidcsv);

bestWindow=0;
bestWinValue=0;

fidcsv = fopen('Anisodiff_Media_Ventana_Centrado.csv','at');
for i=1:size
    if ((data(i,1)>bestJump-20)&&(data(i,1)<bestJump+20)&&(data(i,2)==1))
      fprintf(fidcsv, '%i, 1, %f %f\n',data(i,1),data(i,3),data(i,4));   
      if (data(i,3)>bestWinValue)
        bestWinValue=data(i,3);
        bestWindow=data(i,1);
      end;
    end;
end;
fclose(fidcsv);

bestArea=0;
bestIteracion=0;

fidcsv = fopen('Anisodiff_Media_VxI_Centrado.csv','at');
for i=1:size
    if ((data(i,1)>bestWindow-5)&&(data(i,1)<bestWindow+5))
      fprintf(fidcsv, '%i, %i, %f %f\n',data(i,1),data(i,2),data(i,3),data(i,4));   
      if(data(i,3)>bestArea)
        bestArea=data(i,3);
        bestIteracion=data(i,2);
      end;
    end;
end;
fclose(fidcsv);

bestWindow
bestIteracion
bestArea
%% Transformacion de Coherencia con Media
clc
clear all
close all

size=8150;
matriz=[];
columnLabels=[];
rowLabels=[];
min = 1;

data = csvread('CoherenciaMediaJoined.csv');

maxVentana = 0;
maxIteraciones = 0;

bestJump = 0;
bestJumpValue=0;

fidcsv = fopen('Coherence_Media_Saltos.csv','at');
for i=1:size
    if ((rem(data(i,1)-1,10)==0)&&(data(i,2)==1))
      fprintf(fidcsv, '%i, 1, %f %f\n',data(i,1),data(i,3),data(i,4));   
      if (data(i,3)>bestJumpValue)
        bestJumpValue = data(i,3);
        bestJump = data(i,1);
      end;
    end;
end;
fclose(fidcsv);

bestWindow=0;
bestWinValue=0;

fidcsv = fopen('Coherence_Media_Ventana_Centrado.csv','at');
for i=1:size
    if ((data(i,1)>bestJump-20)&&(data(i,1)<bestJump+20)&&(data(i,2)==1))
      fprintf(fidcsv, '%i, 1, %f %f\n',data(i,1),data(i,3),data(i,4));   
      if (data(i,3)>bestWinValue)
        bestWinValue=data(i,3);
        bestWindow=data(i,1);
      end;
    end;
end;
fclose(fidcsv);

bestArea=0;
bestIteracion=0;

fidcsv = fopen('Coherence_Media_VxI_Centrado.csv','at');
for i=1:size
    if ((data(i,1)>bestWindow-5)&&(data(i,1)<bestWindow+5))
      fprintf(fidcsv, '%i, %i, %f %f\n',data(i,1),data(i,2),data(i,3),data(i,4));   
      if(data(i,3)>bestArea)
        bestArea=data(i,3);
        bestIteracion=data(i,2);
      end;
    end;
end;
fclose(fidcsv);

bestWindow
bestIteracion
bestArea
%% Transformacion de Coherencia con Mediana
clc
clear all
close all

size=6150;
matriz=[];
columnLabels=[];
rowLabels=[];
min = 1;

data = csvread('CoherenciaMedianaDatos.csv');

maxVentana = 0;
maxIteraciones = 0;

%fidcsv = fopen('Coherence_Media_Saltos.csv','at');
%for i=1:size
%    if ((rem(data(i,1)-1,10)==0)&&(data(i,2)==1))
%      fprintf(fidcsv, '%i, 1, %f %f\n',data(i,1),data(i,3),data(i,4));   
%      if (data(i,3)>bestJumpValue)
%        bestJumpValue = data(i,3);
%        bestJump = data(i,1);
%      end;
%    end;
%end;
%fclose(fidcsv);
bestJump=141;
bestWindow=0;
bestWinValue=0;

fidcsv = fopen('Coherence_Mediana_Ventana_Centrado.csv','at');
for i=1:size
    if ((data(i,1)>bestJump-20)&&(data(i,1)<bestJump+20)&&(data(i,2)==1))
      fprintf(fidcsv, '%i, 1, %f %f\n',data(i,1),data(i,3),data(i,4));   
      if (data(i,3)>bestWinValue)
        bestWinValue=data(i,3);
        bestWindow=data(i,1);
      end;
    end;
end;
fclose(fidcsv);

bestArea=0;
bestIteracion=0;

fidcsv = fopen('Coherence_Mediana_VxI_Centrado.csv','at');
for i=1:size
    if ((data(i,1)>bestWindow-5)&&(data(i,1)<bestWindow+5))
      fprintf(fidcsv, '%i, %i, %f %f\n',data(i,1),data(i,2),data(i,3),data(i,4));   
      if(data(i,3)>bestArea)
        bestArea=data(i,3);
        bestIteracion=data(i,2);
      end;
    end;
end;
fclose(fidcsv);

bestWindow
bestIteracion
bestArea