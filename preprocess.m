function [labels] = preprocess(image, method,args)
   
    switch(method)
        case 'anisodiff'
            labels = anisodiff2D(image,args.iterations,args.delta_t,args.kappa,1);
        case 'coherence'
            labels = CoherenceFilter(image,struct('T',args.T,'rho',args.rho,'Scheme','O'));
        case 'median'
            labels = medfilt2(image,[args.n args.n]);
        otherwise
            labels = image;
    end;
end

