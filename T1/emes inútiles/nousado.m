% Indicamos a Matlab que x es un "input".
syms x;

% Creamos las 3 funciones.
f1 = x^3-x+2;
f2 = x^5+x^4+x^3+x^2+x+1;
f3 = log(x)+log(3*(x^3));

% Creamos las 3 derivadas.
df1 = diff(f1);
df2 = diff(f2);
df3 = diff(f3);


figura = figure(1);
subplot (2,3,i);
plot(IRFb);
title(thetas(i),tx{:});
sgtitle("IRF para distintos Coeficientes Autoregresivos", tx{:});
xlim([0 50]);
xlabel("T", tx{:});