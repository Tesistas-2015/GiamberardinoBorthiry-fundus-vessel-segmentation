function preprocessed = sacar_fondo( image,metodo,opts )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    switch(metodo)
        case 'average'
            filtro = fspecial('average',opts.n);
            fondo = filter2(filtro,image);
            sin_fondo=image-fondo;
            preprocessed = adapthisteq(sin_fondo);
        case 'median'
            fondo = medfilt2(image, [opts.n opts.n]);
            sin_fondo=image-fondo;
            preprocessed = adapthisteq(sin_fondo);
        otherwise
            preprocessed = adapthisteq(image);
    end;
end

