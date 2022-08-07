%% TAREA 2 Teoría Macroeconómica I: LA VIDA DE UN PESCADOR
% Alejo Eyzaguirre y Pedro Fernández

%% PREGUNTA 2: EQUILIBRIO GENERAL
clear;
close all;
clc;
cd '/Users/alejoeyzaguirre/Desktop/Teoría Macro/MATLAB/T2/T2_AE_PF'

%% 2.H Oferta Agregada de Activos y Capital.
% Generamos nuevamente valores iniciales:
T =65; 
alpha=1/3;
beta = 0.96; 
rho = 2;
r = (1-beta)/beta;
liq = 1000; 
A = linspace(-15,25,1001)';
Z  = @(t) -10^(-3)*t.^2 + 5 * 10^(-2) * t + 1; 
sigma=0.1;

% Generamos grilla de tasas de interés:
a = 0.05;
b = 0.14;
r_p = linspace(a,b,10);

% Generamos prealocaciones:
At= NaN(10,T+1);
Ct= NaN(10,T);
L_barra= NaN(10,1);
Kt= NaN(10,1);

tic
for i=1:10 % Para cada posible valor de la grilla de "r":
[~,At(i,:),Ct(i,:),~,~,~,~,L_barra(i,:), Kt(i,:),~] = fisher(T,alpha,beta,sigma,rho,r_p(1,i),A,Z,liq);
end
toc

% Suma de todos los activos: Oferta Agregada de Activos.
S=(sum(At,2)/T)'; % Da lo mismo sumar del 2 al T+1 o del 1 al T dado que el 
% valor de At de t = 1 y de T+1 es cero.

%Plot 
tx= {'Interpreter','Latex','FontSize', 15};

figure(6)
sgtitle('General Equilibrium I',tx{:},'FontSize', 25)

subplot(2,2,1)
plot(r_p,S)
xlabel('r',tx{:})
title('Assets (A) supply',tx{:},'FontSize', 15)

subplot(2,2,2)
plot(r_p,Kt)
hold on
xlabel('r',tx{:})
title('Capital (K) demand',tx{:},'FontSize', 15)


subplot(2,2,3)
plot(At');
xlabel('T',tx{:})
title('Assets (Stock) Evolution',tx{:},'FontSize', 15)
legend('r= 0.05','r= 0.06','r= 0.07','r= 0.08','r= 0.09','r= 0.1','r= 0.11','r= 0.12','r= 0.13','r= 0.14',tx{:});

subplot(2,2,4)
plot(Ct');
xlabel('T',tx{:})
title('Consumption Evolution',tx{:},'FontSize', 15)


plot(r_p,S)
hold on
plot(r_p,Kt)
xlabel('r',tx{:})
title('Assets (A) supply and Capital (K) demand',tx{:},'FontSize', 15)


%% 2.I Tasa Interés Equilibrio 101

% Semilla inicial:
p_r=5;
% Grado de Tolerancia:
conv=10^(-3);
% Cota por derecha e izquierda de Bisección:
a=0.05;
b=0.15;
tic
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

% Encontramos trayectoria óptima de Activos y Consumo con r de equilibrio:
[~,At,Ct,~,~,~,~,~, ~,~]= fisher(T,alpha,beta,sigma,rho,r,A,Z,liq);

%Plot 
tx= {'Interpreter','Latex','FontSize', 15};

figure(7)
sgtitle('General Equilibrium II',tx{:},'FontSize', 25)
subplot(1,3,1)
plot(At');
xlabel('T',tx{:})
title('Assets (Stock) Evolution',tx{:},'FontSize', 15)

subplot(1,3,2)
plot(Ct');
xlabel('T',tx{:})
title('Consumption Evolution',tx{:},'FontSize', 15)

subplot(1,3,3)
plot(income');
xlabel('T',tx{:})
title('Income Evolution',tx{:},'FontSize', 15)
%0.092868989706039
%% 2.J Tasa Interés Equilibrio para Distintas Restricciones de Liquidez.

% Creamos prealocaciones:
h=linspace(0,10,11);
At= NaN(length(h),T+1);
Ct= NaN(length(h),T);
Income= NaN(length(h),T);
L_barra= NaN(length(h),1);
Kt= NaN(length(h),1);
tasas=NaN(1,length(h));
Corr=NaN(1,length(h));


tic
for i=1:length(h) % Para cada uno de los valores de restricción de liquidez:
r=biseccion(0,0.20,h(i));
tasas(i) = r;
[~,At(i,:),Ct(i,:),~,~,~,~,L_barra(i,:), Kt(i,:),Income(i,:)] = fisher(T,alpha,beta,sigma,rho,r,A,Z,h(i));
Corraux=corrcoef(Ct(i,:),Income(i,:));
Corr(i)=Corraux(2,1);
end
toc
i=2;

%Plot 
tx= {'Interpreter','Latex','FontSize', 15};

figure(8)
sgtitle('General Equilibrium III',tx{:},'FontSize', 25)
subplot(2,2,1)
plot(At');
xlabel('T',tx{:})
title('Assets (Stock) Evolution',tx{:},'FontSize', 15)
legend('liq= 0','liq= 1','liq= 2','liq= 3','liq= 4','liq= 5','liq= 6','liq= 7','liq= 8','liq= 9','liq= 10',tx{:});

subplot(2,2,2)
plot(Ct');
xlabel('T',tx{:})
title('Consumption Evolution',tx{:},'FontSize', 15)

subplot(2,2,3)
plot(h,tasas);
xlabel('Credit Constraint',tx{:})
title('Equilibrium interest rate',tx{:},'FontSize', 15)

subplot(2,2,4)
plot(h, Corr);
xlabel('Credit Constraint',tx{:})
title('Correlation Consumption-Income',tx{:},'FontSize', 15)

%% 2.K
%Latex