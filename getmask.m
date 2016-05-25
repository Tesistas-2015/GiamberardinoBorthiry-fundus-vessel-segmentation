function mask = getmask( image )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    Inorm = normalize(image);
    I2=Inorm + Inorm;
    mask=I2;
    mask(I2 > (30/255))=1;
    mask(I2 <= (30/255))=0;
end

