function preprocessed = sacar_fondo( image,metodo )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    switch(metodo)
        case 'average'
            filtro = fspecial('average',30);
            fondo = filter2(filtro,image);
            sin_fondo=image-fondo;
            preprocessed = adapthisteq(sin_fondo);
        case 'median'
            fondo = medfilt2(image, [35 35]);
            sin_fondo=image-fondo;
            preprocessed = adapthisteq(sin_fondo);
        otherwise
            preprocessed = adapthisteq(image);
    end;

end

