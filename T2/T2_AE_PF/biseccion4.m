function r=biseccion4(a,b,liq)
T =65; 
alpha=1/3;
beta = 0.96; 
A = linspace(-15,25,1001)';
sigma=0.1;
theta=1.2;

    % Semilla inicial:
    p_r=5;
    % Grado de Tolerancia:
    conv=10^(-3);
    % A medida que la condición de equilibrio "A = K" no se cumpla repetimos:
    while abs(p_r)>conv
        % Computamos nuevo valor de r óptimo:
        r=(b+a)/2;
        % Evaluamos función en "r":
        [~,At,~,~,~,~,~,~, Kt,~,~,~]= fisher4(T,alpha,beta,sigma,theta,r,A,liq);
        p_r=((sum(At)/T)-Kt)/Kt;
        % Ahora evaluamos en "a":
        [~,At,~,~,~,~,~,~, Kt,~,~,~]= fisher4(T,alpha,beta,sigma,theta,a,A,liq);
        p_a=((sum(At)/T)-Kt)/Kt;
        % Ahora evaluamos en "b":
        [~,At,~,~,~,~,~,~, Kt,~,~,~]= fisher4(T,alpha,beta,sigma,theta,b,A,liq);
        p_b=((sum(At)/T)-Kt)/Kt;
        % Dependiendo de los signos de p_r, p_b y p_a, actualizamos a o b:
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