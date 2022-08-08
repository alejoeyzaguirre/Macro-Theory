function [r,tr_assets,K,w]=biseczion(pro,tr,tr_shocks,L,a,b)
    
    % Fijamos parámetros necesarios:
    beta = 0.96;
    sigma = 2;
    N = 10000;
    T = 2000;
    alfa = 0.33; % Por Participación K en el Ingreso Promedio en Países --> 1/3
    delta = 0.05; % Tasa depreciación.
    seed = 3; % Semilla Inicial para Construir Panel de Activos.
    % Semilla inicial Error:
    p_r=5;
    % Grado de Tolerancia:
    conv=10^(-3);
    A = linspace(0,30,1001); % Grilla de Activos (sin posibilidad endeudamiento)
    tol = 1e-2; % Tolerancia o Stopping Rule Algoritmo Iteración Función de Valor.

    % A medida que la condición de equilibrio "A = K" no se cumpla repetimos:
    tic
    % A medida que la condición de equilibrio "A = K" no se cumpla repetimos:
    while abs(p_r)>conv
        
        % Computamos nuevo valor de r óptimo:
        r=(b+a)/2;
      
        % 1. Evaluamos función en "r": Lo mismo que 2.A. pero con r = "r".
        K = kapital(alfa,r,delta,L); % Obtengo Demanda Capital con "r".
        w = wage(alfa,K,L);
        [~,~,~,~,Ap] = value(beta,sigma,r,w,A,tol,pro,tr); 
        [tr_assets, ~]= panel(seed,A,Ap,tr_shocks,pro,N,T,w,r); 
        A_barra= mean(tr_assets(:,end)); % Obtengo Oferta Activos con "r".
        % Computamos Error para "r":
        p_r=(A_barra-K)/K;
        
        % 2. Ahora evaluamos en "a":
        K = kapital(alfa,a,delta,L); % Obtengo Demanda Capital con "a".
        w = wage(alfa,K,L);
        [~,~,~,~,Ap] = value(beta,sigma,a,w,A,tol,pro,tr); 
        [tr_assets, ~]= panel(seed,A,Ap,tr_shocks,pro,N,T,w,a); 
        A_barra= mean(tr_assets(:,end)); % Obtengo Oferta Activos con "a".
        % Computamos Error para "a":
        p_a=(A_barra-K)/K;
    
        % 3. Ahora evaluamos en "b":
        K = kapital(alfa,b,delta,L); % Obtengo Demanda Capital con "b".
        w = wage(alfa,K,L);
        [~,~,~,~,Ap] = value(beta,sigma,b,w,A,tol,pro,tr); 
        [tr_assets, ~]= panel(seed,A,Ap,tr_shocks,pro,N,T,w,b); 
        A_barra= mean(tr_assets(:,end)); % Obtengo Oferta Activos con "b".
        % Computamos Error para "a":
        p_b=(A_barra-K)/K;
    
        % 4. Dependiendo de los signos de p_r, p_b y p_a, actualizamos a o b:
        if p_r>0 && p_a>0 || p_r<0 && p_a<0
            a=r;
        elseif p_r<0 && p_a>0 || p_r>0 && p_a<0
            b=r;
        % Si función converge en "a" o "b", paramos ahí:
        elseif abs(p_a)<conv
            r=a;
        elseif abs(p_b)<conv
            r=b;
        end
        % Paremos si a y b muy parecidos!
        if abs(a-b)<10^(-8)
            p_r=0.1*conv;
        end
    end
    toc

end