%% Pasos Iniciales:
clear;
close all;
clc;
cd '/Users/alejoeyzaguirre/Dropbox/Mi Mac (MacBook Air de Alejo)/Desktop/Teoría Macro/MATLAB/A3'

%% Definimos la función EulerS

% Siguiendo lo hecho en ayudantía.
% Definimos los parámetros:
Beta = 0.96;
r = 0.03;
y_1 = 5;
y_2 = 7;

% Maximizamos con la función fsolve() que usa el algoritmo de optimización
% numérico Newton Raphson.

% Antes debemos descargar el "Optimization Toolbox".
Ss=fsolve(@(S) EulerS(Beta,y_1,y_2,r,S),0); % Función fsolve

% Dado que encontramos el nivel de ahorro, obtenemos los consumos ahora:
c1 = y_1 -Ss;
c2 = y_2+(1+r)*Ss;
% Notamos que llegamos a los mismos resultados que los analíticos.


