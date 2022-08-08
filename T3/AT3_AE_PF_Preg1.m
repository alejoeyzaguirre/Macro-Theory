%% TAREA 3 Teoría Macroeconómica I: InCeRtIdUmBrE
% Alejo Eyzaguirre y Pedro Fernández
%% Pasos Iniciales:
clear;
close all;
clc;
cd '/Users/alejoeyzaguirre/Desktop/Teoría Macro/MATLAB/T3'
rng(1);
%% PREGUNTA 1: Ausencia de Gobierno
%% 1.A. Resolución Problema Agente (Representativo) 

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

% Usando Función "value" de la Ayudantía:
tic
[Cti,Ati,S,Vf,Ap] = value(beta,sigma,r,w,A,tol,pro,tr);
toc


%% 1.B. Gráficas de Policy Functions Consumption & Assets:

% Note que la variable de estado con la cual representaremos el consumo y
% los activos' son los activos.
% Ergo, tendremos en el eje X la variable de estado activos con valores
% entre 0 y 30.
% Tendremos una línea o trayectoria para cada valor o estado.
tx= {'Interpreter','Latex','FontSize', 15};

figure (1);
sgtitle('\textbf{Policy and Value Functions}',tx{:},'Fontsize',20)

subplot (2,2,1)
d = plot(A,Cti(:,:));
xlabel('Assets',tx{:})
title('\textbf{Policy: Consumption}',tx{:})
legend([d(1),d(length(pro))],'$\varepsilon_1 = 0.48$',...
    '$\varepsilon_5 = 1.74$',tx{:},'fontsize',10,'location','SE'); 
d(1).LineWidth = 2; % Hacemos + Gruesas línea con menor y mayor productividad.
d(length(pro)).LineWidth = 2; 

subplot(2,2,2)
p = plot(A,Ati(:,:));
xlabel('Assets',tx{:})
title('\textbf{Policy: Assets}',tx{:})
legend([p(1),p(length(pro))],'$\varepsilon_1$ = 0.48',...
    '$\varepsilon_5 = 1.74$','location','SE',tx{:},'fontsize',10); 
p(1).LineWidth = 2;
p(length(pro)).LineWidth = 2;

subplot(2,2,[3,4])
f = plot(A,Vf(:,:));
xlabel('Assets',tx{:})
title('\textbf{Value Function}',tx{:});
legend([f(1),f(length(pro))],'$\varepsilon_1 = 0.48$',...
    '$\varepsilon_5 = 1.74$',tx{:},'fontsize',10,'location','SE'); 
f(1).LineWidth = 2;
f(length(pro)).LineWidth = 2;
% Note que valores son negativos en Policy Function. Eso es porque
% dividimos por 1- sigma y sigma es 2!
% Al ser la utilidad algo "abstracto" no nos debiera preocupar. Es
% meramente ordinal.


%% 1.C. Trayectorias de Shocks de Productividad:

close all;

% Establecemos N y T1:
N = 10000;
T = 2000;

% Usamos Función distest:
tic
[tr_shocks,~,e_bar] = distest(N,T,tr,pro);
toc

figure(2)
sgtitle('\textbf{Simulation $\varepsilon_{n,t}$}','fontsize',20,tx{:})
plot ((1:T),pro(tr_shocks(10000,:)))
xlabel('T',tx{:})
set(gca,'ytick',0:5)


%% 1.D. Panel de Consumo y de Activos:

% En la 1.B obtuvimos la trayectoria óptima de activos para cada agente en
% cada estado de productividad.

% En la 1.C tenemos distintas (10000) trayectorias de shocks para 2000 
% periodos.

% Debemos construir las trayectorias de cada consumidor de manera tal que
% se actualice la trayectoria de activos según el activo del periodo
% anterior (policy function de A') y adicionalmente el estado de
% productividad de ese momento:

% Generamos prealocaciones de trayectorias de activos:
%tr_assets = NaN(N,T+1); % Una fila para cada agente y 2000 cols (periodos).
tr_assets_pos = NaN(N,T+1); % Trayectoria Posiciones.

% Todos los agentes parten (arbitrariamente) con "seed" de Activos.
seed = 3; % Semilla inicial común para todos.
%tr_assets(:,1) = seed; % Activos iniciales para todos = "seed".
tr_assets_pos(:,1) = sum(A<=seed); % Posición Grilla de activos "seed".

% Partimos algoritmo:
tic
for i = 1:N % Para cada agente:
   
    actual_pos = sum(A<=seed);
    
    for t = 2:T+1 % Para cada periodo:
        state = tr_shocks(i,t-1); % Encuéntrame el estado de productividad en t-1.
        %tr_assets(i,t) = Ati(state,actual_pos); % Reemplázame con el valor de activos óptimo de t.
        new_pos = Ap(state, actual_pos); % Reemplázame con la posición del valor de activo óptimo de t.
        tr_assets_pos(i,t) = new_pos;
        actual_pos = new_pos; % Actualizo posición actual. 

    end

end
toc

% Creo función panel que hace lo mismo for loops anteriores: "panel".

% Tenemos trayectoria de activos óptima: 
tic
tr_assets = A(tr_assets_pos);
toc

% Teniendo Trayectoria de Activos de cada Agente Computo Consumo de c/agente.
tic
tr_cons = (1+r)*tr_assets(:,1:T) + w*pro(tr_shocks) - tr_assets(:,2:T+1);
toc

% Momentos para cada Agente en sus últimos 1000 periodos.
assets_gr = tr_assets(:,1001:T); % Selecciono últimos 1000 periodos assets.
cons_gr = tr_cons(:,1001:T); % Selecciono últimos 1000 periodos consumo.

% Computo estadísticos (as y cons) para cada agente en sus últimos 1000 periodos:
medias_cons = mean(cons_gr,2);
medias_as = mean(assets_gr,2);
medians_cons = median(cons_gr,2);
medians_as = median(assets_gr,2);
percs10_cons = prctile(cons_gr,10,2);
percs10_as = prctile(assets_gr,10,2);
percs90_cons = prctile(cons_gr,90,2);
percs90_as = prctile(assets_gr,90,2);
percs99_cons = prctile(cons_gr,99,2);
percs99_as = prctile(assets_gr,99,2);

% Cómputo Estadísticas Puntuales para ambas Matrices (de 10.000 x 1000):
media_cons = mean(cons_gr(:));
media_as = mean(assets_gr(:));
median_cons = median(cons_gr(:));
median_as = median(assets_gr(:));
perc10_cons = prctile(cons_gr(:),10);
perc10_as = prctile(assets_gr(:),10);
perc90_cons = prctile(cons_gr(:),90);
perc90_as = prctile(assets_gr(:),90);
perc99_cons = prctile(cons_gr(:),99);
perc99_as = prctile(assets_gr(:),99);

% Creo función que computa estadísticos de una matriz "estadisticos".


%Gráficas:
figure (3);
sgtitle('\textbf{Estadisticos Relevantes}',tx{:},'Fontsize',20)

subplot (5,2,1)
histogram(medias_as, 'Normalization', 'pdf', 'FaceColor','red');
xlabel('Assets',tx{:})
title('\textbf{Densidad Medias de Activos por Agente}',tx{:})

subplot(5,2,2)
histogram(medias_cons, 'Normalization', 'pdf', 'FaceColor','green');
xlabel('Consumption',tx{:})
title('\textbf{Densidad Medias de Consumo por Agente}',tx{:})

subplot(5,2,3)
histogram(medians_as, 'Normalization', 'pdf', 'FaceColor','red');
xlabel('Assets',tx{:})
title('\textbf{Densidad Medianas de Activos por Agente}',tx{:})

subplot(5,2,4)
histogram(medians_cons, 'Normalization', 'pdf', 'FaceColor','green');
xlabel('Consumption',tx{:})
title('\textbf{Densidad Medianas de Consumo por Agente}',tx{:})

subplot(5,2,5)
histogram(percs10_as, 'Normalization', 'pdf', 'FaceColor','red');
xlabel('Assets',tx{:})
title('\textbf{Densidad Percentil 10 de Activos por Agente}',tx{:})

subplot(5,2,6)
histogram(percs10_cons, 'Normalization', 'pdf', 'FaceColor','green');
xlabel('Consumption',tx{:})
title('\textbf{Densidad Percentil 10 de Consumo por Agente}',tx{:})

subplot(5,2,7)
histogram(percs90_as, 'Normalization', 'pdf', 'FaceColor','red');
xlabel('Assets',tx{:})
title('\textbf{Densidad Percentil 90 de Activos por Agente}',tx{:})

subplot(5,2,8)
histogram(percs90_cons, 'Normalization', 'pdf', 'FaceColor','green');
xlabel('Consumption',tx{:})
title('\textbf{Densidad Percentil 90 de Consumo por Agente}',tx{:})

subplot(5,2,9)
histogram(percs99_as, 'Normalization', 'pdf', 'FaceColor','red');
xlabel('Assets',tx{:})
title('\textbf{Densidad Percentil 99 de Activos por Agente}',tx{:})

subplot(5,2,10)
histogram(percs99_cons, 'Normalization', 'pdf', 'FaceColor','green');
xlabel('Consumption',tx{:})
title('\textbf{Densidad Percentil 99 de Consumo por Agente}',tx{:})


%% 1.E. Variando Volatilidades:

close;
% Genero Vector de Volatilidades:
std_vec = linspace(0.1,0.19,10);

% Prealocaciones Momentos: Matriz de 5 x 10.
moments_assets_std = NaN(5,length(std_vec));
moments_cons_std = NaN(5,length(std_vec));


tic
for s = 1:length(std_vec) % Para cada valor de volatilidad
    % 1. Calcúlame matriz transición y estados.
    [pro,tr]= discAR(n_e, per_e,std_vec(s));
    % 2. Trayectorias Óptimas (Posiciones de Activos):
    [~,~,~,~,Ap] = value(beta,sigma,r,w,A,tol,pro,tr); 
    % 3. Trayectoria Shocks Productividades:
    [tr_shocks,~,~] = distest(N,T,tr,pro);
    % 4. Panel de Consumo y Activos (para cada agente):
    [tr_assets, tr_cons]= panel(seed,A,Ap,tr_shocks,pro,N,T,w,r);
    % 5. Computo y guardo estadísticos assets.
    moments_assets_std(:,s) = estadisticos(tr_assets(:,1001:end));
    %. 6. Computo y guardo estadísticos consumption.
    moments_cons_std(:,s) = estadisticos(tr_cons(:,1001:end));

end
toc

% En general aumenta el ahorro y consumo con mayor volatilidad!
% Se mueve toda la distribución!


%% 1.F. Variando Persistencias:

% Genero Vector de Persistencias:
per_vec = linspace(0.9,0.98,9);

% Prealocaciones Momentos: Matriz de 5 x 10.
moments_assets_per = NaN(5,length(per_vec));
moments_cons_per = NaN(5,length(per_vec));


tic
for p = 1:length(per_vec) % Para cada valor de volatilidad
    % 1. Calcúlame matriz transición y estados.
    [pro,tr]= discAR(n_e, per_vec(p),sigma_mu); 
    % 2. Trayectorias Óptimas (Posiciones de Activos):
    [~,~,~,~,Ap] = value(beta,sigma,r,w,A,tol,pro,tr); 
    % 3. Trayectoria Shocks Productividades:
    [tr_shocks,~,~] = distest(N,T,tr,pro); 
    % 4. Panel de Consumo y Activos:
    [tr_assets, tr_cons]= panel(seed,A,Ap,tr_shocks,pro,N,T,w,r); 
    % 5. Computo y guardo estadísticos assets.
    moments_assets_per(:,p) = estadisticos(tr_assets(:,1001:end)); 
    % 6. Computo y guardo estadísticos consumption.
    moments_cons_per(:,p) = estadisticos(tr_cons(:,1001:end)); 

end
toc

% En general aumenta el ahorro (para los de la parte superior de la dist)
% Consumo aumenta para los de la parte superior de la dist. y cae? para los
% de la parte inferior. Cambia densidad colas. Desigualdad!

%% 1.G. Efecto en Bienestar:

% Obtengo value functions para volatilidades 0.1 y 0.15:

% Para 0.1:
[pro,tr]= discAR(n_e, per_e,0.1); % Encontramos Estados y Matriz Transición
% con volatilidad menor.
[~,~,~,V0,~] = value(beta,sigma,r,w,A,tol,pro,tr); % Estimamos Value Function.


% Para 0.15:
[pro,tr]= discAR(n_e, per_e,0.15); % Encontramos Estados y Matriz Transición
% con volatilidad mayor.
[~,~,~,V1,~] = value(beta,sigma,r,w,A,tol,pro,tr); % Estimamos Value Function.

% Efecto Bienestar:
delta_welfare = (V1./V0).^(1/(1-sigma))-1; 

% Graficamos:
figure(4)
d = plot(A,delta_welfare(:,:));
xlabel('Assets',tx{:})
title('\textbf{Welfare Effect}',tx{:})
legend([d(1),d(length(pro))],'$\varepsilon_1 = 0.48$',...
    '$\varepsilon_5 = 1.74$',tx{:},'fontsize',15,'location','SE'); 
d(1).LineWidth = 2; % Hacemos + Gruesas línea con menor y mayor productividad.
d(length(pro)).LineWidth = 2; 
