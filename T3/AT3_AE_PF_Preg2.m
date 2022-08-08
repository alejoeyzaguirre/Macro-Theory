%% TAREA 3 Teoría Macroeconómica I: InCeRtIdUmBrE
% Alejo Eyzaguirre y Pedro Fernández
%% Pasos Iniciales:
clear;
close all;
clc;
cd '/Users/alejoeyzaguirre/Desktop/Teoría Macro/MATLAB/T3'
rng(1);

%% PREGUNTA 2: Ausencia de Gobierno en Equilibrio General
%% 2.H. Oferta Agregada de Activos y Demanda Agregada Capital:

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


% r y w son endógenos ahora!

A = linspace(0,30,1001); % Grilla de Activos (sin posibilidad endeudamiento)
tol = 1e-2; % Tolerancia o Stopping Rule Algoritmo Iteración Función de Valor.

% Oferta Agregada de Activos será la (suma para todos los agentes) del
% Estado Estacionario (t=2000).

% Oferta Agregada será distinta para cada "r" (cambia Policy Function). 

% Oferta Agregadad de K se obtiene de despejar "K" de (6).

% PASOS:

% 1. Generamos grilla de tasas de interés:
inf = 0.01;
sup = 0.07;
r_grid = linspace(inf,sup,10);

% 2. Prealocación para Oferta Agregada de Activos (SS) y K:
assets_SS = NaN(N,length(r_grid)); % Una fila para cada agente y una columna
% para cada valor posible de "r". 
K_ss = NaN(1,length(r_grid)); % Una fila nomas, un solo valor para todos agentes.

% 3. Como no depende de "r": Calculamos matriz transición y estados.
[pro,tr]= discAR(n_e,per_e,sigma_mu); 

% 4. Estimamos Panel de Shocks y "L" con tr y pro nuevos:
[tr_shocks,~,L] = distest(N,T,tr,pro);

% 5. Por enunciado L será Nivel Productividad Promedio en último periodo:
% L = ebar!

% Función para calcular K "kapital" y w "wage" en archivo .m separado:

tic
for r = 1:length(r_grid) % Para cada valor de "r":
    
    % 6. Calculo Demanda K (SS):
    K = kapital(alfa,r_grid(r),delta,L);
    K_ss(1,r) = K;
    
    % 7. Calculamos "w" Salario:
    w = wage(alfa,K,L);

    % 8. Trayectorias Óptimas (Posiciones de Activos):
    [~,~,~,~,Ap] = value(beta,sigma,r_grid(r),w,A,tol,pro,tr); 

    % 9. Panel de Consumo y Activos:
    [tr_assets, ~]= panel(seed,A,Ap,tr_shocks,pro,N,T,w,r_grid(r)); 
    
    % 10. Obtengo última columna --> Oferta A Periodo 2000 (Steady State):
    assets_SS(:,r) = tr_assets(:,end);
        
end
toc

% 11. Obtengo promedio de activos en t = 2000 para obtener oferta agregada
% activos:
asset_supply = mean(assets_SS);

% Gráfica:
figure(5)
tx= {'Interpreter','Latex','FontSize', 15};
plot(r_grid,asset_supply, 'Color', 'red', 'LineWidth',2)
hold on
plot(r_grid,K_ss, 'Color','green','LineWidth',2)
xlabel('r',tx{:})
legend('Asset Supply', 'Capital Demand', tx{:})
title('\textbf{Assets (A) Supply and Capital (K) demand}',tx{:},'FontSize', 15)
hold off


%% 2.I. Tasa Interés Equilibrio:

% Por gráfica anterior sabemos que tasa interés equilibrio estará entre
% 2 y 4%. Usamos esos intervalos para el algoritmo de bisección:
a = 0.03; % Los cambiamos después para tener convergencia + veloz.
b = 0.033;

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
    % Computamos Error para "b":
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

% r Equilibrio = 0.0313.

% Creamos Función "biseczion" que replica mismo proceso (variando sigma_mu). 

%% 2.J. Consumo y Producción Agregada para cada Volatilidad:
sigma_mu_grid = linspace(0.1,0.19,10);

% Para cada valor de sigma calcúlame r_equilibrio y dame trayectoria de
% Demanda de Activos agregada. 

% Generamos prealocaciones para r_equilibrio, A_barra's, K's y w's.
r_eq_vec = NaN(1,length(sigma_mu_grid));
A_eq_mat = NaN(N,length(sigma_mu_grid)); % Guardamos los consumo en t = T para c/agente.
K_eq_vec = NaN(1,length(sigma_mu_grid));
w_eq_vec = NaN(1,length(sigma_mu_grid));

tic
for s = 1:length(sigma_mu_grid)
    [pro,tr]= discAR(n_e,per_e,sigma_mu_grid(s)); % Nueva Matriz de 
    % transición y valores de prod. según cada valor de sigma. 
    
    % Nuevo panel de shocks según nueva matriz de transición y estados.
    [tr_shocks,~,e_bar] = distest(N,T,tr,pro);

    % L es e_bar la productividad promedio.

    % A partir de r_equil para cada sigma calculamos A_eq, K_eq y w_eq:
    [r_eq_vec(s),As_eq,K_eq_vec(s),w_eq_vec(s)] = ...
                          biseczion(pro,tr,tr_shocks,e_bar,0.02,0.035);
    % Límites Biseczion son tales por que previamente calculamos r_eq para
    % mayor y menor valor de sigma_mu_grid.

    A_eq_mat(:,s) = As_eq(:,end);
end
toc

%%
% Consumo Agregado (en Estado Estacionario):
cons_eq_vec = NaN(1,length(sigma_mu_grid));
for i = 1:length(sigma_mu_grid)
    
    % Para cada valor de sigma_mu calcúlame consumo agregado promedio en
    % SS.
    cons_eq_vec(i) = mean((1+r_eq_vec(i))*A_eq_mat(:,i) + w_eq_vec(i)*L ...
                            - A_eq_mat(:,i)); 
    % Sacamos consumos en SS para cada agente y promediamos aquellos.

end

% Producto Agregado:
prod_eq_vec = K_eq_vec.^alfa .* L^(1-alfa); 

%%
% Gráficos!
figure (6);
tx= {'Interpreter','Latex','FontSize', 15};
sgtitle('\textbf{Aggregate Consumption and Production SS}',tx{:},'Fontsize',20)

subplot(3,1,1)
plot(sigma_mu_grid,r_eq_vec, 'Color','blue','LineWidth',2)
xlabel('$\sigma_\mu$',tx{:})
title('\textbf{Interest Rate of Equilibrium}',tx{:},'FontSize', 15)

subplot (3,1,2)
plot(sigma_mu_grid,cons_eq_vec, 'Color', 'red', 'LineWidth',2)
xlabel('$\sigma_\mu$',tx{:})
title('\textbf{Aggregate Consumption}',tx{:},'FontSize', 15)

subplot(3,1,3)
plot(sigma_mu_grid,prod_eq_vec, 'Color','green','LineWidth',2)
xlabel('$\sigma_\mu$',tx{:})
title('\textbf{Aggregate Production}',tx{:},'FontSize', 15)

%% Complemento 2.c. TESTEO

% Analizando Cambios en "L".
Lbar = NaN(1,length(sigma_mu_grid));
tic
for s = 1:length(sigma_mu_grid)
    [pro,tr]= discAR(n_e,per_e,sigma_mu_grid(s)); % Nueva Matriz de 
    % transición y valores de prod. según cada valor de sigma. 
    
    % Nuevo panel de shocks según nueva matriz de transición y estados.
    [tr_shocks,~,Lbar(s)] = distest(N,T,tr,pro);
end
toc
% L cae!

% Testeando si Oferta Agregada Activos aumenta (?)
Abar = mean(A_eq_mat);
% A aumenta!

