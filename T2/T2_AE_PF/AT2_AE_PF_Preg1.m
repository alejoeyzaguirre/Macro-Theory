%% TAREA 2 Teoría Macroeconómica I: LA VIDA DE UN PESCADOR
% Alejo Eyzaguirre y Pedro Fernández
%% Pasos Iniciales:
clear;
close all;
clc;
cd '/Users/alejoeyzaguirre/Desktop/Teoría Macro/MATLAB/T2/T2_AE_PF'

%% PREGUNTA 1: EQUILIBRIO PARCIAL
%% 1.C Resolución Numérica 1

% Heredando notación y código de la Ayudantía 5...
% Primero que nada fijamos los valores de los parámetros:
T =65; 
beta = 0.96; 
rho = 2; 
r = (1-beta)/beta; % r dada por enunciado.
liq = 10; % liq = b. En este caso fijamos valor grande dado que b -> inf.
A = linspace(-15,25,5001)'; % Creamos grilla de activos posibles. Van de -15
% a 25 tendremos 1001 posibles valores. 

% 1.- Quiero graficar salario!
%Salario es función del enunciado (variable de estado).
Z  = @(t) -(10)^(-3)*t.^2 + 5*10^(-2)*t + 1; % Creamos una función anónima para
% calcular el salario de cada periodo.
w = Z(1:T); % Evalúa función de 1 hasta T. Encontramos salarios de cada t.
w_mean = mean(w)*ones(1,T); % Así tenemos un vector de la media.
% Ploteamos:
tx= {'Interpreter','Latex','FontSize', 20};
figure(1);
plot(1:T, w, 1:T,w_mean);
xlabel('T', tx{:});
title('Trayectoria Salario',tx{:})


% Usamos función value_matriz para resolver el problema con recursión hacia
% atrás dado que el horizonte es finito. Cronometramos el tiempo de
% ejecución para ver la eficiencia del algoritmo.
tic
[Vt,At,Ct,St,Ap,Am,Cm] = value_matriz(T,beta,rho,r,A,Z,liq);
toc

% Vector de Ceros para plotear:
ceros = zeros(1,66);


%Plot 
tx= {'Interpreter','Latex','FontSize', 15};

figure(2)
sgtitle('Partial Equilibrium',tx{:},'FontSize', 25)
subplot(2,3,1)
plot(1:T,w,1:T,w_mean);
xlabel('T',tx{:})
title('Income Evolution',tx{:},'FontSize', 15)
legend('Wage', 'Mean',tx{:});

subplot(2,3,2)
plot(1:T+1,At(1:end), 1:T+1, ceros)
xlabel('T',tx{:})
title('Assets (Stock) Evolution',tx{:},'FontSize', 15)
legend('Assets', 'Zero',tx{:}, 'Location', 'northwest');

subplot(2,3,3)
plot(1:T-1,St(1:end),1:T-1,ceros(1:T-1))
xlabel('T',tx{:})
title('Savings (Flow) Evolution',tx{:},'FontSize', 15)
legend('Savings', 'Zero',tx{:}, 'Location', 'southwest');

% b)
subplot(2,3,[4,5,6])
plot(1:T,Ct)
xlabel('T',tx{:})
title('Consumption',tx{:},'FontSize', 15)
% En ayudantía probamos con ßR = 1 y trayectoria fue más plana. Luego
% probamos con ßR > 1 y trayectoria consumo fue creciente. 
% Si aumentamos sigma, agente más averso al riesgo. Trayectoria consumo
% será menos creciente o decreciente. Trayectoria más plana de consumo.
% Analizar eje Y al cambiar sigma e.g. a 10.
% Choro ver como cambia el incentivo al ahorro!


%% 1.D Cambiando Trayectoria Salarios:

% 1.- Quiero graficar salario!
%Salario es función del enunciado (variable de estado). Redefinimos función
%Z: Z2
Z2  = @(t) -(10)^(-3)*t.^2 + 9*10^(-2)*t + 1; % Creamos una función anónima para
% calcular el salario de cada periodo.
w2 = Z2(1:T); % Evalúa función de 1 hasta T. Encontramos salarios de cada t.
w_mean2 = mean(w2)*ones(1,T); % Así tenemos un vector de la media.

% Usamos función value_matriz para resolver el problema con recursión hacia
% atrás dado que el horizonte es finito. Cronometramos el tiempo de
% ejecución para ver la eficiencia del algoritmo.
tic
[Vt2,At2,Ct2,St2,Ap2,Am2,Cm2] = value_matriz(T,beta,rho,r,A,Z2,liq);
toc

%Plot 
tx= {'Interpreter','Latex','FontSize', 15};

figure(3)
sgtitle('Partial Equilibrium II',tx{:},'FontSize', 25)
subplot(2,3,1)
plot(1:T,w2,1:T,w_mean2);
xlabel('T',tx{:})
title('Income Evolution',tx{:},'FontSize', 15)
legend('Wage', 'Mean',tx{:}, 'Location', 'southeast');

subplot(2,3,2)
plot(1:T+1,At2(1:end), 1:T+1, ceros)
xlabel('T',tx{:})
title('Assets (Stock) Evolution',tx{:},'FontSize', 15)
legend('Assets', 'Zero',tx{:}, 'Location', 'southeast');

subplot(2,3,3)
plot(1:T-1,St2(1:end),1:T-1,ceros(1:T-1))
xlabel('T',tx{:})
title('Savings (Flow) Evolution',tx{:},'FontSize', 15)
legend('Savings', 'Zero',tx{:}, 'Location', 'southeast');

% b)
% Note que trayectoria consumo es decreciente! ßR<1 soy más
% impaciente que retorno que me ofrece futuro!
subplot(2,3,[4,5,6])
plot(1:T,Ct2)
xlabel('T',tx{:})
title('Consumption',tx{:},'FontSize', 15)
% En ayudantía probamos con ßR = 1 y trayectoria fue más plana. Luego
% probamos con ßR > 1 y trayectoria consumo fue creciente. 
% Si aumentamos sigma, agente más averso al riesgo. Trayectoria consumo
% será menos creciente o decreciente. Trayectoria más plana de consumo.
% Analizar eje Y al cambiar sigma e.g. a 10.
% Choro ver como cambia el incentivo al ahorro!


%% 1.E Cambiando Trayectoria Salarios:


%--------------------------------------------------------------------------
% CON r = 5% CETERIS PARIBUS:

% Actualizamos "r":
r2 = 0.05; % r dada por enunciado.

% 1.- Quiero graficar salario!
%Salario es función del enunciado (variable de estado). Redefinimos función
%Z: Z2
Z3  = @(t) -(10)^(-3)*t.^2 + 7*10^(-2)*t + 1; % Creamos una función anónima para
% calcular el salario de cada periodo.
w3 = Z3(1:T); % Evalúa función de 1 hasta T. Encontramos salarios de cada t.
w_mean3 = mean(w3)*ones(1,T); % Así tenemos un vector de la media.

% Usamos función value_matriz para resolver el problema con recursión hacia
% atrás dado que el horizonte es finito. Cronometramos el tiempo de
% ejecución para ver la eficiencia del algoritmo.
tic
[Vt3,At3,Ct3,St3,Ap3,Am3,Cm3] = value_matriz(T,beta,rho,r2,A,Z3,liq);
toc


%Plot 
tx= {'Interpreter','Latex','FontSize', 15};

figure(4)
sgtitle('Partial Equilibrium III',tx{:},'FontSize', 25)
subplot(2,3,1)
plot(1:T,w3,1:T,w_mean3);
xlabel('T',tx{:})
title('Income Evolution',tx{:},'FontSize', 15)
legend('Wage', 'Mean',tx{:});

subplot(2,3,2)
plot(1:T+1,At3(1:end), 1:T+1, ceros)
xlabel('T',tx{:})
title('Assets (Stock) Evolution',tx{:},'FontSize', 15)
legend('Assets', 'Zero',tx{:}, 'Location', 'northwest');

subplot(2,3,3)
plot(1:T-1,St3(1:end),1:T-1,ceros(1:T-1))
xlabel('T',tx{:})
title('Savings (Flow) Evolution',tx{:},'FontSize', 15)
legend('Savings', 'Zero',tx{:}, 'Location', 'southeast');

subplot(2,3,[4,5,6])
plot(1:T,Ct3)
xlabel('T',tx{:})
title('Consumption',tx{:},'FontSize', 15)


%--------------------------------------------------------------------------
% CON rho = 8 CETERIS PARIBUS:

% Volvemos a r original:
r = (1-beta)/beta; % r dada por enunciado.

% Cambiamos rho:
rho2 = 8;

% Usamos función value_matriz para resolver el problema con recursión hacia
% atrás dado que el horizonte es finito. Cronometramos el tiempo de
% ejecución para ver la eficiencia del algoritmo.
tic
[Vt4,At4,Ct4,St4,Ap4,Am4,Cm4] = value_matriz(T,beta,rho2,r,A,Z3,liq);
toc


%Plot 
tx= {'Interpreter','Latex','FontSize', 15};

figure(5)
sgtitle('Partial Equilibrium IV',tx{:},'FontSize', 25)
subplot(2,3,1)
plot(1:T,w3,1:T,w_mean3);
xlabel('T',tx{:})
title('Income Evolution',tx{:},'FontSize', 15)
legend('Wage', 'Mean',tx{:});

subplot(2,3,2)
plot(1:T+1,At4(1:end), 1:T+1, ceros)
xlabel('T',tx{:})
title('Assets (Stock) Evolution',tx{:},'FontSize', 15)
legend('Assets', 'Zero',tx{:}, 'Location', 'northwest');

subplot(2,3,3)
plot(1:T-1,St4(1:end),1:T-1,ceros(1:T-1))
xlabel('T',tx{:})
title('Savings (Flow) Evolution',tx{:},'FontSize', 15)
legend('Savings', 'Zero',tx{:}, 'Location', 'southeast');

subplot(2,3,[4,5,6])
plot(1:T,Ct4)
xlabel('T',tx{:})
title('Consumption',tx{:},'FontSize', 15)

