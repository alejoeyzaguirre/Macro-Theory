function [vec]= estadisticos(matriz)
    media = mean(matriz(:));
    mediana = median(matriz(:));
    perc10 = prctile(matriz(:),10);
    perc90 = prctile(matriz(:),90);
    perc99 = prctile(matriz(:),99);
    vec = [media;mediana;perc10;perc90;perc99];
end