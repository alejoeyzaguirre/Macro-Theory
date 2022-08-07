%% TAREA 2 Teoría Macroeconómica I: LA VIDA DE UN PESCADOR
% Alejo Eyzaguirre y Pedro Fernández

%% PREGUNTA 3: CRECIMIENTO POBLACIONAL
clear;
close all;
clc;
cd '/Users/alejoeyzaguirre/Desktop/Teoría Macro/MATLAB/T2/T2_AE_PF'

%% 3.K Alterando Tamaños Poblacionales.
% Generamos nuevamente valores iniciales:
T =65; 
alpha=1/3;
beta = 0.96; 
rho = 2;
r = (1-beta)/beta;
A = linspace(-15,25,1001)';
Z  = @(t) -10^(-3)*t.^2 + 5 * 10^(-2) * t + 1; 
sigma=0.1;

% Generamos grilla de posibles valores de g:
g = linspace(0,0.01,11);

% En archivo .m aparte generamos función de Crecimiento poblacional:
% crecimiento.m
% Para Plotear Tamaños Poblacionales luego:
Mt = NaN(length(g),T);
for i=1:length(g) % Para cada uno de los valores de "g":
    Mt(i,:) = crecimiento(g(i),(1:T),T);
end
% Sería el tamaño poblacional (de cada t) para cada valor posible de "g". 


% Procederemos a encontrar la tasa de interés de equilibrio para distintos
% valores de "g" usando el algoritmo de bisección programado en la P2.

% Para lograr lo anterior modificaremos levemente la función fisher:
% fisher3 para poder modificar el tamaño poblacional de cada grupo etario.

% Podemos asumir h --> infty. Por lo que:
liq = 1000;

% Al usar la función Fisher heredamos la trayectoria de la productividad
% laboral, la condición de equilibrio, salarios, demanda por K y oferta
% laboral agregada de la Pregunta 2. Usamos salario original P1.c

% Para encontrar la tasa de interés de equilibrio usaremos función fisher3
% junto a biseccion3 que encontrará la tasa de interés de equilibrio para
% el respectivo input de "g".

% Generamos prealocaciones:
At= NaN(length(g),T+1);
tasas=NaN(1,length(g));
L_barra= NaN(length(g),1);
Kt = NaN(length(g),1);

tic
for i=1:length(g) % Para cada uno de los valores de "g":
    r=biseccion3(0,0.1,g(i));
    tasas(i) = r;
    [~,At(i,:),~,~,~,~,~,L_barra(i,:), Kt(i,:),~] = fisher3(T,alpha,beta,sigma,rho,r,A,Z,liq,g(i));
end
toc

%Plot 
tx= {'Interpreter','Latex','FontSize', 15};

figure(9)
sgtitle('General Equilibrium IV',tx{:},'FontSize', 25)
subplot(2,2,1)
plot(g,tasas);
xlabel('Tasa Crecimiento $g$',tx{:})
title('Equilibrium Interest Rate',tx{:},'FontSize', 15)

subplot(2,2,2)
p = plot(1:T,Mt');
title('Population Size per Group Age',tx{:},'FontSize', 15)
xlabel('Grupo Etario',tx{:})
legend([p(1),p(length(g))],'g= 0\%','g= 1\%',tx{:});

subplot(2,2,[3,4])
plot(At');
xlabel('T',tx{:})
title('Assets (Stock) Evolution',tx{:},'FontSize', 20)
legend('g= 0\%','g= 0.1\%','g= 0.2\%','g= 0.3\%','g= 0.4\%','g= 0.5\%','g= 0.6\%','g= 0.7\%','g= 0.8\%','g= 0.9\%','g= 1\%',tx{:});

