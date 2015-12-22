function [area,error,treshold] = area_roc(GT,segmented)
    
    normalizedGT = (GT-min(GT(:)))/(max(GT(:))-min(GT(:)));
    normalizedGT = normalizedGT - 0.5;
    [TPR,TNR,INFO]=vl_roc(normalizedGT,segmented);
    area=INFO.auc;
    error=INFO.eer;
    treshold=INFO.eerThreshold;
end

