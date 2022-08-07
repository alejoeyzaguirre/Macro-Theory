function [trend, cycle] = HP(series,lambda)
    % Lo más complejo de esta función fue el tema de las dimensiones de la
    % fórmula y compatibilizarlo con la muestra. Este proceso se hizo en un
    % papel a mano separado que no presento.
    table_col = (series(1:size(series,1),2));
    serie = table2array(table_col);

    % GENERAMOS MATRIZ K
    n = size(serie,1);
    m = n-2;
    
    % Usando comando sparse creamos las "3 diagonales" que requerimos para
    % armar la matriz K. De izquierda a derecha tenemos que: D sería la 
    % primera diagonal, luego E la segunda (con los-2) y F la última 
    % diagonal de unos.
    D = sparse(1:m,1:n-2,ones(1,m),m,n);
    E = sparse(1:m,2:n-1,-2*ones(1,m),m,n);
    F = sparse(1:m,3:n,ones(1,m),m,n);

    K = full(D+E+F);

    % Teniendo K generamos la matriz A:
    I = eye(n,n);
    A = I + lambda*(K'*K);
    invA = A^-1;

    %Estamos listos para el ciclo:
    cycle = (I-invA)*serie;

    % Como nos dicen que la estacionalidad es cero, trend es el remanente.
    % Le restamos la media de la serie para ajustar con el ciclo.
    media = mean(serie);
    trend = serie - cycle-media;

end