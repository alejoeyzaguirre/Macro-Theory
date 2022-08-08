%% Pasos Iniciales:
clear;
close all;
clc;
cd '/Users/alejoeyzaguirre/Desktop/Teoría Macro/MATLAB/A6'

%% Ausencia de Gobierno - Con Incertidumbre
beta = 0.96;
sigma = 2; 
per_e = 0.97; %persistencia
var_u = 0.13; %varianza
n_e = 5; %numero de estados
r = 0.03; 
w = 1;
A = linspace(0,80,1001);
tol = 1e-2; 

%computa la matriz de transición tr y los niveles de productividad pro.
[pro,tr]= discAR(n_e, per_e,var_u);
% Note que filas matriz de transición tienen que sumar 1. 
% Primer elemento es la probabilidad de que mañana observemos pro(1) si hoy
% observamos pro(1) es 0.90.
% Segundo elemento de la fila 1 será la probabilidad de que observemos
% pro(2) mañana si hoy observamos que e_t fue pro(1). Diagonal matriz será
% la "persistencia".

%se utilizarán en equilibrio parcial con gobierno.
pro_tax = pro;
tr_tax = tr;

% Ahora analizar función value!
tic
[Cti,Ati,S,Vf] = value(beta,sigma,r,w,A,tol,pro,tr);
toc

%Computa: 
%Cti : política óptima de consumo
%Ati : política óptima de activos
%Vp : Función de valor

tx= {'Interpreter','Latex','FontSize', 15};

figure (1);
sgtitle('\textbf{Uncertainty: Matrix}',tx{:},'Fontsize',20)

subplot (2,2,1)
d = plot(A,Cti(:,:));
xlabel('Assets',tx{:})
title('\textbf{Consumption}',tx{:})
legend([d(1),d(length(pro))],'$\varepsilon_1 = 0.39$',...
    '$\varepsilon_5 = 1.93$',tx{:},'fontsize',10,'location','SE'); 
d(1).LineWidth = 2;
d(length(pro)).LineWidth = 2;

subplot(2,2,2)
p = plot(A,Ati(:,:));
xlabel('Assets',tx{:})
title('\textbf{Assets}',tx{:})
legend([p(1),p(length(pro))],'$\varepsilon_1$ = 0.39',...
    '$\varepsilon_5 = 1.93$','location','SE',tx{:},'fontsize',10); 
p(1).LineWidth = 2;
p(length(pro)).LineWidth = 2;

subplot(2,2,[3,4])
f = plot(A,Vf(:,:));
xlabel('Assets',tx{:})
title('\textbf{Value function}',tx{:});
legend([f(1),f(length(pro))],'$\varepsilon_1 = 0.39$',...
    '$\varepsilon_5 = 1.93$',tx{:},'fontsize',10,'location','SE'); 
f(1).LineWidth = 2;
f(length(pro)).LineWidth = 2;

%% LOOPS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic
[Cl,Al,~,Vl] = value_loop(beta,sigma,r,w,A,tol,pro,tr);
toc

figure (2);
sgtitle('\textbf{Uncertainty: Loop}',tx{:},'Fontsize',20)

subplot (2,2,1)
s = plot(A,Cl(:,:));
xlabel('Assets',tx{:})
title('\textbf{Consumption}',tx{:})
legend([s(1),s(length(pro))],'$\varepsilon_1 = 0.39$',...
    '$\varepsilon_5 = 1.93$',tx{:},'fontsize',10,'location','SE'); 
s(1).LineWidth = 2;
s(length(pro)).LineWidth = 2;

subplot(2,2,2)
p = plot(A,Al(:,:));
xlabel('Assets',tx{:})
title('\textbf{Assets}',tx{:})
legend([p(1),p(length(pro))],'$\varepsilon_1$ = 0.39',...
    '$\varepsilon_5 = 1.93$','location','SE',tx{:},'fontsize',10); 
p(1).LineWidth = 2;
p(length(pro)).LineWidth = 2;

subplot(2,2,[3,4])
f = plot(A,Vl(:,:));
xlabel('Assets',tx{:})
title('\textbf{Value function}',tx{:});
legend([f(1),f(length(pro))],'$\varepsilon_1 = 0.39$',...
    '$\varepsilon_5 = 1.93$',tx{:},'fontsize',10,'location','SE'); 
f(1).LineWidth = 2;
f(length(pro)).LineWidth = 2;



%% Ausencia de Gobierno - ítem (b) - Funciones de política para ε = 0.8668 

shock = 3;


figure (3);
sgtitle('\textbf{Policy function}: $\varepsilon_3$',tx{:},'fontsize',20)
subplot(2,2,1)
plot(A,Vf(shock,:),'LineWidth',2);
xlabel('Assets',tx{:})
title('\textbf{Value function}',tx{:});

subplot(2,2,2)
p = plot(A,Ati(shock,:),'LineWidth',2);
xlabel('Assets',tx{:})
title('\textbf{Assets}',tx{:})

subplot (2,2,[3,4])
d = plot(A,Cti(shock,:),'LineWidth',2);
xlabel('Assets',tx{:})
title('\textbf{Consumption}',tx{:})



%% Ausencia de Gobierno - ítem (d) - Simulaciones de Schocks
clc;
N = 800;
T = 300;

tic
[panel_S_aux,~,e_bar] = distest(N,T,tr,pro);
toc

%se utilizarán en los proximos items.
e_tax = e_bar;%shock medio de productividad
panel_S_tax = panel_S_aux;%simulación del panel de shock estacionario


figure(3)
sgtitle('\textbf{Simulation}','fontsize',20,tx{:})
plot ((1:T),panel_S_aux(1,:))
xlabel('T',tx{:})
set(gca,'ytick',0:5)
disp(e_bar); %media de los shocks en estado estacionario











%% %% MARKOV: vectores propios (VeP) y valores propios (VaP)
clear; close all; clc;

m_t = [0.87 0.13 ; 0.6 0.4]; %Matriz de transición
%d: matriz diagonal con valores propios.
%v: matriz cuyas columnas corresponde al VeP asociado a cada VaP.

[v,d] = eig(m_t'); %[V,D] = eig(A) returns diagonal matrix D of ...
%eigenvalues and matrix V whose columns are the corresponding ...
%right eigenvectors, so that A*V = V*D.
%Usamos el vector propio asociado al valor propio = 1.

v_1 = v(:,1);
sum(v_1); %La suma de sus elementos debe ser 1.
V = v_1/sum(v_1); %fórmula para hacer que sumen 1.
sum(V)
%Entonces V será la distribución estacionaria asociada al proceso
%markoviano descrito en la matriz de transición m_t.

%% Método iterativo 
clear; close all; clc

m_t = [0.87 0.13 ; 0.6 0.4];%Matriz de transición
tol = 10^-4; %Tolerancia que se usa para detener las iteraciones.
e = 10; %Guess para la distancia inicial.
n_iteraciones = 0; %contador de iteraciones.

des = 0.3; %probabilidad inicial de estar desempleado.
pi_t0 = [des;1-des]; %distribución inicial.

while e >= tol
    pi_t1 = m_t'* pi_t0;
    e = max(abs(pi_t1-pi_t0));
    pi_t0 = pi_t1;
    n_iteraciones = n_iteraciones + 1;
end

pi_t0;
n_iteraciones;

