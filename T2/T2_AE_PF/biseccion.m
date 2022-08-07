function r=biseccion(a,b,liq)
    T =65; 
    alpha=1/3;
    beta = 0.96; 
    rho = 2; 
    A = linspace(-15,25,1001)';
    Z  = @(t) -10^(-3)*t.^2 + 5 * 10^(-2) * t + 1; 
    sigma=0.1;

    % Semilla inicial:
    p_r=5;
    % Grado de Tolerancia:
    conv=10^(-3);
    % A medida que la condición de equilibrio "A = K" no se cumpla repetimos:
    while abs(p_r)>conv
        % Computamos nuevo valor de r óptimo:
        r=(b+a)/2;
        % Evaluamos función en "r":
        [~,At,~,~,~,~,~,~, Kt,~]= fisher(T,alpha,beta,sigma,rho,r,A,Z,liq);
        p_r=((sum(At)/T)-Kt)/Kt;
        % Ahora evaluamos en "a":
        [~,At,~,~,~,~,~,~, Kt,~]= fisher(T,alpha,beta,sigma,rho,a,A,Z,liq);
        p_a=((sum(At)/T)-Kt)/Kt;
        % Ahora evaluamos en "b":
        [~,At,~,~,~,~,~,~, Kt,~]= fisher(T,alpha,beta,sigma,rho,b,A,Z,liq);
        p_b=((sum(At)/T)-Kt)/Kt;
        % Dependiendo de los signos de p_r, p_b y p_a, actualizamos a o b:
        if p_r>0 && p_a>0 || p_r<0 && p_a<0 % Tiene mismo signo que p_a
            a=r;
        elseif p_r<0 && p_a>0 || p_r>0 && p_a<0 % Tiene distinto signo que p_a;
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

end