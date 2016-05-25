function normalized = normalize( image )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    dim = im2double(image);
    normalized = (dim-min(dim(:)))/(max(dim(:))-min(dim(:)));
end

