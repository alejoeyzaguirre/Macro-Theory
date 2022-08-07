%% TAREA 2 Teoría Macroeconómica I: LA VIDA DE UN PESCADOR
% Alejo Eyzaguirre y Pedro Fernández

%% PREGUNTA 4: OFERTA LABORAL
clear;
close all;
clc;
cd '/Users/alejoeyzaguirre/Desktop/Teoría Macro/MATLAB/T2/T2_AE_PF'

%% 4: Endogeneizando Todo:

% Fijamos parámetros iniciales base.
T =65; 
alpha=1/3;
beta = 0.96; 
r = (1-beta)/beta;
A = linspace(-15,25,1001)';
Z  = @(t) -10^(-3)*t.^2 + 5 * 10^(-2) * t + 1; 
sigma=0.1;
theta=1.2;

% Generamos prealocaciones:
tic
k=10;
h=linspace(0,9,k);
At= NaN(k,T+1);
Ct= NaN(k,T);
Income= NaN(k,T);
L_barra= NaN(k,1);
Kt= NaN(k,1);
Nt= NaN(k,T);
Lt= NaN(k,T);
tasas=NaN(k,1);
Corr=NaN(k,1);

for i=1:k %Para cada valor posible de restricción de liquidez:
r=biseccion4(0,0.15,h(1,i)); % Encuéntrame el r de equilibrio.
tasas(i,1)= r;
% Encuentra las trayectorias óptimas para ese r de equilibrio.
[~,At(i,:),Ct(i,:),~,~,~,~,L_barra(i,:), Kt(i,:),Income(i,:),Nt(i,:),Lt(i,:)] = fisher4(T,alpha,beta,theta,sigma,r,A,h(1,i));
Corraux=corrcoef(Ct(i,:),Income(i,:)); % Y estudiemos la correlación entre consumo e ingreso!
Corr(i,1)= Corraux(2,1);

end
toc


%Plot 
tx= {'Interpreter','Latex','FontSize', 15};

figure(8)
sgtitle('General Equilibrium with Labor Supply',tx{:},'FontSize', 25)


subplot(2,3,1)
plot(At');
xlabel('T',tx{:})
title('Assets (Stock) Evolution',tx{:},'FontSize', 15)
legend('liq= 0','liq= 1','liq= 2','liq= 3','liq= 4','liq= 5','liq= 6','liq= 7','liq= 8','liq= 9','liq= 10',tx{:});

subplot(2,3,2)
plot(Ct');
xlabel('T',tx{:})
title('Consumption Evolution',tx{:},'FontSize', 15)

subplot(2,3,3)
plot(Lt');
xlabel('T',tx{:})
title('Labor Supply Evolution',tx{:},'FontSize', 15)

subplot(2,3,4)
plot(h,tasas);
xlabel('Credit Constraint',tx{:})
title('Equilibrium interest rate',tx{:},'FontSize', 15)

subplot(2,3,5)
plot(h, Corr);
xlabel('Credit Constraint',tx{:})
title('Correlation Consumption-Income',tx{:},'FontSize', 15)

subplot(2,3,6)
plot(h, L_barra);
xlabel('Credit Constraint',tx{:})
title('Labor Supply',tx{:},'FontSize', 15)