function I = coherence(image,iterations,rho,sigma) 
    %Calculo el fondo
    fondo = medfilt2(image,[20,20]);
 
    %Resto el fondo
    SF = image - fondo;
    SF = (SF-min(SF(:)))/(max(SF(:))-min(SF(:)));
    %Aplico el filtro de coherencia
    JO = CoherenceFilter(SF,struct('T',iterations,'rho',rho,'sigma',sigma,'Scheme','O','eigenmode',0));
    I=JO;
end