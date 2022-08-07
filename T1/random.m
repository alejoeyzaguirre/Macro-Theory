function [matrix,figura] = random(n,m)
    % x1:
    x1 = (rand(n,m).*(8-1)) + 1;

    % x2: 
    x2 = (randn(n,m).*sqrt(4)) + 3;

    % x3: Para construir chi-squared con 100 grados de libertad. Seguimos lo
    % realizado en ayudantía:
    grados_libertad= 100;
    contador = 1;
    x3 = randn(n,m).^2;

    while contador < grados_libertad
        % Mientras no tenga 100 grados de libertad, súmame y súmame normales
        % estándar al cuadrado.
        iteracion = randn(n,m).^2;
        x3 = x3 + iteracion;
        % Contador nos permite acercarnos a la stopping rule y parar cuando
        % tengamos ya 100 grados de libertad.
        contador = contador + 1;
    end

    % x4: 
    t_grados = 2;
    x4 = randn(n,m)./((randn(n,m).^2+randn(n,m).^2)./t_grados).^0.5;

    % x5: 
    random_vec = round(rand(n,m));
    x5 = x2.*random_vec + x3.*(1-random_vec);

    % x6: Generamos la variable promedio y le sumamos "ruido blanco".
    wn = randn(n,m)*0.1;
    x6 = ((x4+x5)./2)+wn;
    
    matrix = [x1 x2 x3 x4 x5 x6];
    
    tx = {'Interpreter','Latex','FontSize', 17};
    dists = [x1 x2 x3 x4 x5 x6];

    for i = 1 : 6
        dist_names = {'Uniform','Normal','$\chi^{2}$','$t_{student}$',...
            'Mixtura','Promedio'};   
        figura = figure(1);
        subplot (2,3,i);
        histogram(dists(:,(i-1)*m+1:i*m));
        title(dist_names(i),tx{:});
    end
    
end