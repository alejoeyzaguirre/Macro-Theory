function figura = montecarlo2(n,m)
    % Primero generamos matriz con los X según las distribuciones: matrix
    % se llama.
    matrix = random2(n,m);

    % Creamos vector de unos necesarios para agregar a matrix
    unos2 = ones(n,1);
    
    % Ahora definimos el vector de los betas entregado por enunciado:
    betas_dados = [1 2 3 4 5 6 7];
    epsilons = randn(n,1);

    % Generamos matriz de betas_ols vacía:
    betas_ols = NaN(7,m);
    
    % Dado lo anterior podemos generar los "y" con el criterio dado:
    for i = 1:m
        X = [unos2 matrix(:,i) matrix(:,m+i) matrix(:,2*m+i) matrix(:,3*m+i) ...
            matrix(:,4*m+i) matrix(:,5*m+i)];
        % Teniendo la matriz de X relevante, estimo el vector de y
        % atingente, que vendría dado por el vector de ß dado y los
        % epsilons.
        y = (betas_dados*X')' + epsilons;

        % Ahora teniendo el y vuelvo a encontrar los ß OLS pero usando el
        % nuevo y.
        betas_ols(:,i) = ((X'*X)^(-1))*(X'*y);
    end
    
    tx = {'Interpreter','Latex','FontSize', 17};
    
    for i = 1 : 7
        param_names = {'$\beta_0$','$\beta_1$','$\beta_2$','$\beta_3$',...
            '$\beta_4$','$\beta_5$','$\beta_6$'};   
        figura = figure(1);
        subplot (2,4,i);
        histogram(betas_ols(i,:));
        title(param_names(i),tx{:});
        tamano = num2str(n);
        ante = 'Muestra de ';
        sgtitle([ante tamano], tx{:});
    end
    
end