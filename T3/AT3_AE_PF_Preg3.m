%% TAREA 3 Teoría Macroeconómica I: InCeRtIdUmBrE
% Alejo Eyzaguirre y Pedro Fernández
%% Pasos Iniciales:
clear;
close;
clc;
cd '/Users/alejoeyzaguirre/Desktop/Teoría Macro/MATLAB/T3'
rng(1);
%% PREGUNTA 3: Impuestos y Gobierno
%% 3.K. Resolución Problema Agente 

% Fijamos parámetros necesarios:
beta = 0.96;
sigma = 2; 
per_e = 0.96; % Persistencia
sigma_mu = 0.12; % Volatilidad
n_e = 5; % Número de Estados --> Matriz de Transición: Markov Chains.
r = 0.03; % Tasa Interés exógena (por ahora)
w = 1; % Salario Exógeno (por ahora)
A = linspace(0,30,1001); % Grilla de Activos (sin posibilidad endeudamiento)
tol = 1e-2; % Tolerancia o Stopping Rule Algoritmo Iteración Función de Valor.
% Usando función de Ayudantía computamos la matriz de transición y los
% posibles estados (n_e = 5).
[pro,tr]= discAR(n_e, per_e,sigma_mu);
% Note que filas matriz de transición tienen que sumar 1. 
% Primer elemento es la probabilidad de que mañana observemos pro(1) si hoy
% observamos pro(1) es 0.90.
% Segundo elemento de la fila 1 será la probabilidad de que observemos
% pro(2) mañana si hoy observamos que e_t fue pro(1). Diagonal matriz será
% la "persistencia" de cada estado.

% Establecemos N y T1:
N = 10000;
T = 2000;

% Usamos Función distest:
tic
[tr_shocks,~,e_bar] = distest(N,T,tr,pro);
toc

imp=0.12;
L=e_bar;

% Usando Función "value" de la Ayudantía:
tic
[Cti,Ati,S,Vf,Ap] = value3(beta,sigma,r,w,A,tol,pro,tr,imp,L);
toc

tx= {'Interpreter','Latex','FontSize', 15};
d = plot(A,Cti(:,:));
xlabel('Assets',tx{:})
title('\textbf{Policy: Consumption}',tx{:})
legend([d(1),d(length(pro))],'$\varepsilon_1 = 0.48$ (imp=0.12)',...
    '$\varepsilon_5 = 1.74$ (imp=0.12)',tx{:},'fontsize',10,'location','SE'); 
d(1).LineWidth = 2; % Hacemos + Gruesas línea con menor y mayor productividad.
d(length(pro)).LineWidth = 2; 

%% 3.L. Efectos en bienestar de tasas impositivas.

% Note que la variable de estado con la cual representaremos el consumo y
% los activos' son los activos.
% Ergo, tendremos en el eje X la variable de estado activos con valores
% entre 0 y 30.
% Tendremos una línea o trayectoria para cada valor o estado.

imp=0.04;
tic
[Cti2,Ati2,S2,Vf2,Ap2] = value3(beta,sigma,r,w,A,tol,pro,tr,imp,L);
toc

% Efecto Bienestar:
delta_welfare = (Vf./Vf2).^(1/(1-sigma))-1; % Interpretación?
% A medida que aumenta stock de activos más incertidumbre menos negativo. 

plot(A,delta_welfare(:,:))
title('\textbf{Welfare effect: low tax vs high tax}',tx{:})


tx= {'Interpreter','Latex','FontSize', 15};

figure (1);

d = plot(A,Cti(:,:));
hold on
d2 = plot(A,Cti2(:,:));
hold off
xlabel('Assets',tx{:})
title('\textbf{Policy: Consumption}',tx{:})
legend([d(1),d(length(pro)),d2(1),d2(length(pro))],'$\varepsilon_1 = 0.48$ (imp=0.12)',...
    '$\varepsilon_5 = 1.74$ (imp=0.12)','$\varepsilon_1 = 0.48$ (imp=0.04)',...
    '$\varepsilon_5 = 1.74$ (imp=0.04)',tx{:},'fontsize',10,'location','SE'); 
d(1).LineWidth = 2; % Hacemos + Gruesas línea con menor y mayor productividad.
d2(1).LineWidth = 2;
d(length(pro)).LineWidth = 2; 
d2(length(pro)).LineWidth = 2; 


%% 3.M. Tasa de interés de equilibrio

% Fijamos parámetros necesarios:
beta = 0.96;
sigma = 2; 
per_e = 0.96; % Persistencia
sigma_mu = 0.12; % Volatilidad
n_e = 5; % Número de Estados --> Matriz de Transición: Markov Chains.
N = 10000;
T = 2000;
alfa = 0.33; % Por Participación K en el Ingreso Promedio en Países --> 1/3
delta = 0.05; % Tasa depreciación.
seed = 3; % Semilla Inicial para Construir Panel de Activos.
imp=0.075;
% r y w son endógenos ahora!
a = 0; % Los cambiamos después para tener convergencia + veloz.
b = 0.2;
% Semilla inicial Error:
p_r=5;
% Grado de Tolerancia:
conv=10^(-3);

tic
% A medida que la condición de equilibrio "A = K" no se cumpla repetimos:
while abs(p_r)>conv
    
    % Computamos nuevo valor de r óptimo:
    r=(b+a)/2;
  
    % 1. Evaluamos función en "r": Lo mismo que 2.A. pero con r = "r".
    K = kapital(alfa,r,delta,L); % Obtengo Demanda Capital con "r".
    w = wage(alfa,K,L);
    [~,~,~,~,Ap] = value3(beta,sigma,r,w,A,tol,pro,tr,imp,L); 
    [tr_assets, ~]= panel2(seed,A,Ap,tr_shocks,N,T,w,r,imp,L); 
    A_barra= mean(tr_assets(:,end)); % Obtengo Oferta Activos con "r".
    % Computamos Error para "r":
    p_r=(A_barra-K)/K;
    
    % 2. Ahora evaluamos en "a":
    K = kapital(alfa,a,delta,L); % Obtengo Demanda Capital con "a".
    w = wage(alfa,K,L);
    [~,~,~,~,Ap] = value3(beta,sigma,a,w,A,tol,pro,tr,imp,L); 
    [tr_assets, ~]= panel2(seed,A,Ap,tr_shocks,N,T,w,a,imp,L); 
    A_barra= mean(tr_assets(:,end)); % Obtengo Oferta Activos con "a".
    % Computamos Error para "a":
    p_a=(A_barra-K)/K;

    % 3. Ahora evaluamos en "b":
    K = kapital(alfa,b,delta,L); % Obtengo Demanda Capital con "b".
    w = wage(alfa,K,L);
    [~,~,~,~,Ap] = value3(beta,sigma,b,w,A,tol,pro,tr,imp,L); 
    [tr_assets, ~]= panel2(seed,A,Ap,tr_shocks,N,T,w,b,imp,L); 
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

%r=0.030688476562500

%r=0.032702636718750


%% 3.N. Panel de Consumo y de Activos:

[~, tr_cons]= panel2(seed,A,Ap,tr_shocks,N,T,w,b,imp,L); 
C_barra= mean(tr_cons(:,end));

imp=0;
% r y w son endógenos ahora!
a = 0; % Los cambiamos después para tener convergencia + veloz.
b = 0.05;
% Semilla inicial Error:
p_r=5;
% Grado de Tolerancia:
conv=10^(-3);

tic
% A medida que la condición de equilibrio "A = K" no se cumpla repetimos:
while abs(p_r)>conv
    
    % Computamos nuevo valor de r óptimo:
    r=(b+a)/2;
  
    % 1. Evaluamos función en "r": Lo mismo que 2.A. pero con r = "r".
    K2 = kapital(alfa,r,delta,L); % Obtengo Demanda Capital con "r".
    w = wage(alfa,K2,L);
    [~,~,~,~,Ap] = value3(beta,sigma,r,w,A,tol,pro,tr,imp,L); 
    [tr_assets2, ~]= panel2(seed,A,Ap,tr_shocks,N,T,w,r,imp,L); 
    A_barra2= mean(tr_assets2(:,end)); % Obtengo Oferta Activos con "r".
    % Computamos Error para "r":
    p_r=(A_barra2-K2)/K2;
    
    % 2. Ahora evaluamos en "a":
    K2 = kapital(alfa,a,delta,L); % Obtengo Demanda Capital con "a".
    w = wage(alfa,K2,L);
    [~,~,~,~,Ap] = value3(beta,sigma,a,w,A,tol,pro,tr,imp,L); 
    [tr_assets2, ~]= panel2(seed,A,Ap,tr_shocks,N,T,w,a,imp,L); 
    A_barra2= mean(tr_assets2(:,end)); % Obtengo Oferta Activos con "a".
    % Computamos Error para "a":
    p_a=(A_barra2-K2)/K2;

    % 3. Ahora evaluamos en "b":
    K2 = kapital(alfa,b,delta,L); % Obtengo Demanda Capital con "b".
    w = wage(alfa,K2,L);
    [~,~,~,~,Ap] = value3(beta,sigma,b,w,A,tol,pro,tr,imp,L); 
    [tr_assets2, ~]= panel2(seed,A,Ap,tr_shocks,N,T,w,b,imp,L); 
    A_barra2= mean(tr_assets2(:,end)); % Obtengo Oferta Activos con "b".
    % Computamos Error para "a":
    p_b=(A_barra2-K2)/K2;

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
    % Paremos si a y b muy parecidos!tr
    if abs(a-b)<10^(-8)
        p_r=0.1*conv;
    end
end
toc

[~, tr_cons2]= panel2(seed,A,Ap,tr_shocks,N,T,w,b,imp,L); 
C_barra2= mean(tr_cons2(:,end));

Y=K^(alfa)*L^(1-alfa);
Y2=K2^(alfa)*L^(1-alfa);

%r=0.030688476562500

%A_barra=8.063915999999997
%A_barra2=8.256188999999994

%K=8.053269065108376
%K2=8.223461638861691

%Y=1.969704924926632
%Y2=1.983345536124609

%C_barra=3.9163
%C_barra2=4.1576

