function [processed, extra] = extractFeature( feature, image, mask, options)

    if ((nargin > 4) || (nargin < 3))
       error('extractFeature: require at least 3 and at most 4 parameters')
    end

    %Azzopardi
        %options.symmetric.sigma=19.2;
        %options.symmetric.len=0:2:72;
        %options.symmetric.sigma0=3;
        %options.symmetric.alpha=0.01;
        %options.asymmetric.sigma=16;
        %options.asymmetric.len=0:2:48;
        %options.asymmetric.sigma0=2;
        %options.asymmetric.alpha=0.1;
        %Azzopardi2015(imcomplement(preprocesada), mask, 0, options);
    %Frangi
        %Frangi1998(preprocesada,mask,unary);
    %Matched Filter
        %options = struct('sigmas', sqrt([10 18 26 34 42]));
        %MatchedFilterResponses(imcomplement(preprocesada), mask, 0, options);/
    %Nguyen
        %options.w=50;
        %options.step=5;
        %Nguyen2013(imcomplement(preprocesada),logical(mask), 0,options);
    %Soares
        %Soares2006(preprocesada,mask,unary, struct('scales',[0.75  1.25 1.75 2.25]));
    %Zana
        %Zana2001(imcomplement(preprocesada),mask,unary, struct('l',90));
    %TopHat
        %options.length=45;
        %options.angles= 0:22.5:180;
        %SumOfTopHat(imcomplement(preprocesada), mask, options);

    if ( strcmp(feature,'Azzopardi') )
        %Symmetric Options
        if ~isfield(options.symmetric,'sigma')
            options.symmetric.sigma=19.2;
        end
        if ~isfield(options.symmetric,'len')
            options.symmetric.len=0:2:72;
        end
        if ~isfield(options.symmetric,'sigma0')
            options.symmetric.sigma0=3;
        end
        if ~isfield(options.symmetric,'alpha')
            options.symmetric.alpha=0.01;
        end
        
        %Asymmetric Options
        if ~isfield(options.asymmetric,'sigma')
            options.asymmetric.sigma=16;
        end
        if ~isfield(options.asymmetric,'len')
            options.asymmetric.len=0:2:48;
        end
        if ~isfield(options.asymmetric,'sigma0')
            options.asymmetric.sigma0=2;
        end
        if ~isfield(options.asymmetric,'alpha')
            options.asymmetric.alpha=0.1;
        end
        processed = Azzopardi2015(imcomplement(image), mask, 0, options);
    elseif ( strcmp(feature,'Frangi'))
        if ~isfield(options,'FrangiScaleRange')
            fprintf('Uso valor por defecto');
            options.FrangiScaleRange = [0 15];
        end
        if ~isfield(options,'FrangiScaleRatio')
            options.FrangiScaleRatio = 1;
        end
        if ~isfield(options,'BlackWhite')
            options.BlackWhite = false;
        end
        if ~isfield(options,'unary')
            options.unary = 0;
        end
        [processed, ~, ~] = FrangiFilter2D(double(image), options);
    elseif ( strcmp(feature,'MatchedFilter'))    
        if ~isfield(options,'sigmas')
            options = struct('sigmas', sqrt([10 18 26 34 42]));
        end
        processed = MatchedFilterResponses(imcomplement(image), mask, 0, options);
    elseif ( strcmp(feature,'Nguyen'))
        if ~isfield(options,'w')
            options.w=50;
        end
        if ~isfield(options,'step')
            options.step=5;
        end
        processed = Nguyen2013(imcomplement(image),mask, 0,options);
    elseif ( strcmp(feature,'Soares'))
        if ~isfield(options,'scales')
            options = struct('scales',[0.75  1.25 1.75 2.25]);
        end
        processed = Soares2006(imcomplement(image),mask,0, options);
    elseif ( strcmp(feature,'Zana'))
        if ~isfield(options,'l')
            options = struct('l',90);
        end
        processed = Zana2001(imcomplement(image),mask,0, options);
    elseif ( strcmp(feature,'TopHat'))
        if ~isfield(options,'length')
            options.length=45;
        end
        if ~isfield(options,'angles')
            options.angles= 0:22.5:180;
        end
        processed = SumOfTopHat(imcomplement(image), mask, options);
    end
    extra = '';
end
