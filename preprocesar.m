function [ preprocesada, mask ] = preprocesar( image )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    metodo.m='anisodiff';
    metodo.args.delta_t=1/20;
    metodo.args.kappa=70;
    im_d = im2double(image);
    mediana = medfilt2(image,[115 115]); 
    mask = getmask(im_d);
    sin_fondo = adapthisteq(im_d-im2double(mediana));
    normalizada = (sin_fondo-min(sin_fondo(:)))/(max(sin_fondo(:))-min(sin_fondo(:)));
    metodo.args.iterations=19;
    preprocesada = anisodiff2D(normalizada,metodo.args.iterations,metodo.args.delta_t,metodo.args.kappa,1);
    mask=logical(mask);
end

