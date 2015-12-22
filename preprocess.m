function [labels] = preprocess(image, method)
   
    switch(method)
        case 'anisodiff'
            labels = anisodiff2D(image,15,1/20,70,1);
        case 'coherence'
            labels = CoherenceFilter(image,struct('T',15,'rho',1,'Scheme','O'));
        case 'median'
            labels = medfilt2(image,[3 3]);
        otherwise
            labels = image;
    end;
end

