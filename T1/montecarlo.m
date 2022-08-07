function figura = montecarlo(n,m)
    % Generamos matriz de X sin contar el intercepto.
    matrix = random2(n,m);

    % Generamos una matriz de 7 filas y m columnas para cada uno de los
    % betas que estimaremos.
    betas_ols = NaN(7,m);

    % Generamos un vector de unos para así agregar a la matrix y tener
    % nuestro X.
    unos2 = ones(n,1);

    for i = 1:m
        % Formamos nuestra matriz X para la emeava muestra de n
        % observaciones.
        X = [unos2 matrix(:,i) matrix(:,m+i) matrix(:,2*m+i) matrix(:,3*m+i) ...
            matrix(:,4*m+i) matrix(:,5*m+i)];

        % Generamos vector de y para cada nueva muestra, así no lo repetimos a 
        % cada rato (1000 muestras para y también):
        y = -(1/0.6)*log(1-rand(n,1));

        % Calculamos los betas de OLS con la clásica fórmula:
        % ((X'X)^1)(X'y)
        betas_ols(:,i) = ((X'*X)^(-1))*(X'*y);
        
    end
    
    tx = {'Interpreter','Latex','FontSize', 17};
    param_names = {'$\beta_0$','$\beta_1$','$\beta_2$','$\beta_3$',...
            '$\beta_4$','$\beta_5$','$\beta_6$'};   

    for i = 1 : 7
        figura = figure(1);
        subplot (2,4,i);
        histogram(betas_ols(i,:));
        title(param_names(i),tx{:});
        tamano = num2str(n);
        ante = 'Muestra de ';
        sgtitle([ante tamano], tx{:});
    end
    
end