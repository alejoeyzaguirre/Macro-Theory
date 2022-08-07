%% Pasos Iniciales:
clear;
close all;
clc;
cd '/Users/alejoeyzaguirre/Dropbox/Mi Mac (MacBook Air de Alejo)/Desktop/Teoría Macro/MATLAB/T1'

% Establecemos semilla para que en ≠ aleatorizaciones obtengamos siempre
% los mismos resultados:
rng(1)

%% I. SIMULACIÓN DE MONTECARLO
%% I.A. Generar Muestra de 1000:
% Para esto, usaremos los comandos básicos probabilísticos de Matlab y lo
% realizado en ayudantía.
n = 1000;

% x1: Dado que en los siguientes acápites no cambiaremos los parámetros los
% dejamos así nomas (8 y 1).
x1 = (rand(n,1).*(8-1)) + 1;

% x2: Mismo procedimiento anterior pero usando randn. Aplicamos raíz
% cuadrada a la varianza para poder desestandarizar (requiero desviación
% estándar no varianza).
x2 = (randn(n,1).*sqrt(4)) + 3;

% x3: Para construir chi-squared con 100 grados de libertad. Seguimos lo
% realizado en ayudantía:
grados_libertad= 100;
contador = 1;
x3= randn(n,1).^2;

while contador < grados_libertad
    % Mientras no tenga 100 grados de libertad, súmame y súmame normales
    % estándar al cuadrado.
    iteracion = randn(n,1).^2;
    x3 = x3 + iteracion;
    % Contador nos permite acercarnos a la stopping rule y parar cuando
    % tengamos ya 100 grados de libertad.
    contador = contador + 1;
end

% x4: Para construir t-student de df grados de libertad con dos grados de 
% libertad debemos aplicar la fórmula convencional de t-student: normal 
% estándar partido en la raíz de una chi-cuadrado. 
t_grados = 2;
x4 = randn(n,1)./((randn(n,1).^2+randn(n,1).^2)./t_grados).^0.5;

% x5: Siguiendo los procedimientos de la ayudantía partimos por seleccionar
% un vector de ceros y unos aleatorio y luego multiplicamos aquel vector
% por x2 y x3.
random_vec = round(rand(n,1));
x5 = x2.*random_vec + x3.*(1-random_vec);
% Lamentablemente no es perfecto el algoritmo en el sentido que no
% selecciona necesariamente el 50% sino que tiene a estar al rededor de
% este porcentaje (aunque bastante cerca).

% x6: Generamos la variable promedio y le sumamos "ruido blanco".
wn = randn(n,1)*0.1;
x6 = ((x4+x5)./2)+wn;

% Generamos Histograma por cada distribución heredando códido ingenioso de 
% la Ayudantía 1.
tx = {'Interpreter','Latex','FontSize', 17};
dists = [x1 x2 x3 x4 x5 x6];

for i = 1 : size(dists,2)
    dist_names = {'Uniform','Normal','$\chi^{2}$','$t_{student}$',...
        'Mixtura','Promedio'};   
    figure(1)
    subplot (2,3,i)
    histogram(dists(:,i))
    title(dist_names(i),tx{:})
end

%% I.B. Generar 1000 MuestraS de 100.
m = 1000;
n2 = 100;
% Construiré matrices de 100 filas y 1000 columnas. Explicaciones de cada
% código en acápite anterior. Cada una de estas matrices tendrá un b al
% final así no pierdo los vectores construidos en el acápite anterior.

% x1:
x1b = (rand(n2,m).*(8-1)) + 1;

% x2: 
x2b = (randn(n2,m).*sqrt(4)) + 3;

% x3: Para construir chi-squared con 100 grados de libertad. Seguimos lo
% realizado en ayudantía y redefinimos algunas cosas del acápite anterior
% para facilitar la lectura del código.
grados_libertad= 100;
contador = 1;
x3b = randn(n2,m).^2;

while contador < grados_libertad
    % Mientras no tenga 100 grados de libertad, súmame y súmame normales
    % estándar al cuadrado.
    iteracion = randn(n2,m).^2;
    x3b = x3b + iteracion;
    % Contador nos permite acercarnos a la stopping rule y parar cuando
    % tengamos ya 100 grados de libertad.
    contador = contador + 1;
end

% x4: 
t_grados = 2;
x4b = randn(n2,m)./((randn(n2,m).^2+randn(n2,m).^2)./t_grados).^0.5;

% x5:
% Generamos matriz de 0 y 1 aleatoriamente.
random_mat = round(rand(n2,m));
x5b = x2b.*random_mat + x3b.*(1-random_mat);

% x6: Generamos la variable promedio y le sumamos "ruido blanco".
wnb = randn(n2,m)*0.1;
x6b = ((x4b+x5b)./2)+wnb;

%% I.C. Función Random:

% Generamos esta función en un archivo .m aparte llamado al igual que la
% función.

[matrix,figura] = random(n2,m);


% y: Usamos la función exponencial clásica tomada de ayudantía:
%y = -(1/0.6)*log(1-rand(n,1));

% Aprovechamos de generar una función random2 que no tiene como output un
% gráfico. Esto para hacer más eficiente los códigos de preguntas posteriores.


%% I.D. "Momentos"

% Suponiendo que n2 y m son las dimensiones escogidas...

% Generamos vectores de dimensión 6 para cada "momento" estos serán
% rellenados para cada distribución. Entonces el elemento 4 del vector
% mediana tendrá la mediana de la cuarta distribución (t-student).
medias = NaN(6,1);
medianas = NaN(6,1);
minimos = NaN(6,1);
maximos = NaN(6,1);
varianzas = NaN(6,1);
perc25 = NaN(6,1);
perc75 = NaN(6,1);

% Mediana:
for i = 1 : 6
    medias(i) = mean(mean(matrix(:,(i-1)*m+1:i*m)));
    medianas(i) = median(median(matrix(:,(i-1)*m+1:i*m)));
    minimos(i) = min(min(matrix(:,(i-1)*m+1:i*m)));
    maximos(i) = max(max(matrix(:,(i-1)*m+1:i*m)));
    varianzas(i) = var(var(matrix(:,(i-1)*m+1:i*m)));
    perc25(i) = prctile(prctile(matrix(:,(i-1)*m+1:i*m),25),25);
    perc75(i) = prctile(prctile(matrix(:,(i-1)*m+1:i*m),75),75);
end 


%% I.E. Vectores de Betas para una Muestra.

% Usando la función random generamos una matriz coherente con lo que se nos
% pide en el enunciado... aunque faltaría la primera columna de unos para
% que así podamos tener una constante. Usaremos un tamaño de muestra de
% 10000 (arbitrario).
n3 = 10000;
[muestra,figura2] = random(n3,1);

% Agregamos columnas de 1 al principio de la matriz (primera col).
unos = ones(n3,1);

% Armamos nuestra matriz X0...
X0 = [unos muestra];

% Creamos "y" siguiendo lo realizado en ayudantía:
y = -(1/0.6)*log(1-rand(n3,1));


% Computamos el vector de los Betas usando la clásica fórmula:
Betas_OLS0 = ((X0'*X0)^(-1))*(X0'*y);
% Note que la inversión de la matriz se computa usando aproximaciones
% numéricas sino tardaría mucho rato la ejecución.


%% I.F. Matrices de Betas para múltiples muestras.

% Usando un n de 100 (n2) creamos una matriz con la función random2 de 1000
% (m) muestras de 100 obs. para cada variable. Usaremos esta matriz para 
% calcular la matriz de betas OLS de 7 filas y 1000 columnas.

betas_ols = NaN(7,m);
unos2 = ones(n2,1);

for i = 1:m
    % Armamos matrix X para cada muestra aprovechando la matriz que creamos
    % con random.
    X = [unos2 matrix(:,i) matrix(:,m+i) matrix(:,2*m+i) matrix(:,3*m+i) ...
        matrix(:,4*m+i) matrix(:,5*m+i)];
    % Generamos vector de y para cada nueva muestra, así no lo repetimos a 
    % cada rato (1000 muestras para y también):
    y = -(1/0.6)*log(1-rand(n2,1));
    % Estimamos los ß OLS para cada muestra.
    betas_ols(:,i) = ((X'*X)^(-1))*(X'*y);
end


%% I.G. Algoritmo 

% Explotando la naturaleza genérica con que se resolvió el ejercicio
% anterior elaboramos la función montecarlo para resolver este ejercicio
% como se nos pide. 
m_vec = [10^2 10^3 10^4 10^5];

% Calculamos el gráfico para cada tamaño de muestra de m_vec. No hacemos el
% loop para m = 10^5 porque se tardaba mucho. Pero se calculó separado:
for i = 1:(size(m_vec,2)-1)
    figurita = montecarlo(m_vec(i),m);
end

%montecarlo(n,m_vec(4));


%% I.H. Estimando ß OLS con Vector de y estimado Antes.

% Ahora usaremos unos nuevos y que estimaremos usando el vector de ß
% presentado en el enunciado:
for i = 1:(size(m_vec,2)-1)
    figurita = montecarlo2(m_vec(i),m);
end

% Lo corremos para un tamaño de muestra de 5.
%montecarlo2(n,m_vec(4));

% Clave que Epsilon sea Ruido Blanco!


%% II. DETRENDING: HODRICK-PRESCOTT FILTERING (HP)

% Limpiamos lo realizado anteriormente:
clear;
close all;
clc;


%% II.A. Importación de Datos
% Pcerimero que nada importamos bases de datos pertinentes. Descargué las
% siguientes series del la web del Banco Central y las ajusté dentro de
% excel para achicar nombre de variables y eliminar el título de la base
% que estorba:

% 1. Precio del Cobre (USD x Libra, BLM).
pcu = readtable('pcu.xlsx');

% 2. Variación Mensual IPC General (Inflación).
ipc = readtable('ipc.xlsx');

% 3. Precio del Petróleo Brent (USD x Barril).
brent = readtable("brent.xlsx");


%% II.B. Función HP

[tend_brent, cic_brent] = HP(brent,6.25);


%% II.C. Gráficas de Ciclo + Tendencia con Filtro HP.

% Ahora graficamos para cada valor de lambda posible y para cada serie
% posible.
lambdas = [6.25 1600 129000];
strings = ["Precio Cobre" "Inflación" "Precio Petróleo"];

% Pese a el esfuerzo, no fue posible hacer un for loop doble en que primero
% apliquemos HP a cada una de las tablas y para cada uno de los 3 lambdas
% por lo que debí hacer 3 for loops distintos, uno para cada tabla.

% En los foros de Mathworks leí que no era posible hacer un for loop sobre
% elementos tipo "table"

tx = {'Interpreter','Latex','FontSize', 17};

% Primero para la serie pcu:
figure(1)
for j = 1: size(lambdas,2)
    param = lambdas(j);
    % Extraemos tendencia y ciclo con filtro HP
    [tendencia, ciclo] = HP(pcu, param);
    % Graficamos Ciclo:
    plot(pcu.period, ciclo);
    hold on;
    % Graficamos Tendencia:
    plot(pcu.period, tendencia); 
    title("Ciclo y Tendencia (HP) de Serie Precio Cobre" ,tx{:})
    hold on;
end
legend('Ciclo con Lambda = 6.25','Tendencia con Lambda = 6.25','Ciclo con Lambda = 1600', 'Tendencia con Lambda = 1600','Ciclo con Lambda = 129000', 'Tendencia con Lambda = 129000');
hold off;

% Ahora para serie del IPC (en diferencias!):
figure(2)
for j = 1: size(lambdas,2)
    param = lambdas(j);
    [tendencia, ciclo] = HP(ipc, param);
    plot(ipc.period, ciclo);
    hold on;
    plot(ipc.period, tendencia); 
    title("Ciclo y Tendencia (HP) de Serie Inflacion" ,tx{:})
    str = num2str(param);
    legend(['Lambda = ' str]);
    hold on;
end
legend('Ciclo con Lambda = 6.25','Tendencia con Lambda = 6.25','Ciclo con Lambda = 1600', 'Tendencia con Lambda = 1600','Ciclo con Lambda = 129000', 'Tendencia con Lambda = 129000');
hold off;

% Ahora para serie del Brent:
figure(3)
for j = 1: size(lambdas,2)
    param = lambdas(j);
    [tendencia, ciclo] = HP(brent, param);
    plot(brent.period, ciclo);
    hold on;
    plot(brent.period, tendencia); 
    title("Ciclo y Tendencia (HP) de Precio del Petroleo" ,tx{:})
    str = num2str(param);
    legend(['Lambda = ' str]);
    hold on;
end
legend('Ciclo con $\lambda$ = 6.25','Tendencia con $\lambda$ = 6.25','Ciclo con $\lambda$ = 1600', 'Tendencia con $\lambda$ = 1600','Ciclo con $\lambda$ = 129000', 'Tendencia con $\lambda$ = 129000');
hold off;

%% II.D. Regresión Lineal: OLS

% Para esta pregunta deberemos hacer una definición de la matriz X y del
% vector y para así poder estimar nuestros estimadores ß con la fórmula
% clásica de (X'X)^(-1)X'y

% Partamos encontrando las variables lag, serán todas las filas de las
% series salvo la última ya que no es posible que esta sea lag de otra.
ipc_l = [ipc(1:(size(ipc.ipc)-1),2)];
ipc_lag = table2array(ipc_l);

pcu_l = [pcu(1:(size(pcu.pcu)-1),2)];
pcu_lag = table2array(pcu_l);

brent_l = [brent(1:(size(brent.brent)-1),2)];
brent_lag = table2array(brent_l);

% Ahora definimos variables normales teniendo en cuenta que al correr una
% regresión contra los lags la primera observación no tendrá lag y por ende
% no la consideramos.
ipc_n = [ipc(2:size(ipc.ipc),2)];
ipc_norm = table2array(ipc_n);

pcu_n = [pcu(2:size(pcu.pcu),2)];
pcu_norm = table2array(pcu_n);

brent_n = [brent(2:size(brent.brent),2)];
brent_norm = table2array(brent_n);


% Ahora procedemos de lleno con el MODELO 1:
X_1 = [ones(size(ipc_norm,1),1) ipc_lag pcu_norm pcu_lag];
y_1 = ipc_norm;

% Estimamos los parámetros del Modelo 1:
betas_M1 = (X_1'*X_1)^(-1)*(X_1'*y_1);


% Ahora procedemos de lleno con el MODELO 2:
X_2 = [ones(size(ipc_norm,1),1) ipc_lag brent_norm brent_lag];
y_2 = ipc_norm;

% Estimamos los parámetros del Modelo 2:
betas_M2 = (X_2'*X_2)^(-1)*(X_2'*y_2);


%% III. RAÍCES DE UNA FUNCIÓN: 
%% III.1. Entendiendo las distintas metodologías
% Limpiamos lo realizado anteriormente:
clear;
close all;
clc;

%% III.1.A. Newton Raphson 

% Creamos funciones en archivos .m separados f1, f2 y f3. 
% Adicionalmente creamos derivadas de las funciones en otros archivos 
% separados: df1, df2 y df3.

F = {'f1','f2','f3'};
F = cellfun(@str2func,F,'uni',0); % convert

D = {'df1','df2','df3'};
D = cellfun(@str2func,D,'uni',0); % convert

% Definimos stopping rule:
ante = "Solución Función";
% Para cada función... calcúlame la solución según NR.
for k = 1:numel(F)
    % Para identificar los resultados de cada función:
    num = num2str(k);
    titulo = [ante num];
    disp(titulo)
    % Fijamos semilla inicial en 1. Partí con el 0 y no funcionaba porque
    % el logaritmo de la 3ª función se indeterminaba.
    actual = 1;
    % A medida que la imagen de la función en el valor actual (resultado de
    % una iteración previa) es mayor que 10^-4 entonces sigue iterando.
    while abs(F{k}(actual)) >= 10^(-4)
        % Actualizo valor según NR
        actual = actual - (F{k}(actual))/(D{k}(actual));
    end
    % Imprimimos la raíz alcanzada.
    disp(actual)
end


%% III.1.b. Bisección

% Siguiendo los pasos entregados en el enunciado partimos por definir la
% tolerancia: tau
tau = 10^(-4);

% Luego definimos el intervalo arbitrario en el cual yo espero que esté la
% solución (ya tenemos alguna noción por los resultados del Newton
% Raphson). No hacemos intervalo simétrico porque la función logarítmica
% evaluada en cero esta indeterminada.



ante = "Solución Función";
% Para cada función... calcúlame la solución según NR.
for k = 1:(numel(F)-1)
    
    % Imprimimos título:
    num = num2str(k);
    titulo = [ante num];
    disp(titulo)

    % Para identificar los resultados de cada función:
    a = -10;
    b = 5;
    r = 1;
    
    % Mientras el error de aproximación no sea menor que 10^-4 iteramos:
    while abs(F{k}(r)) >= tau
        
        % Calculo el valor de r en cada iteración:
        r = (a+b)/2;
        
        % Si la función en r tiene el mismo signo que a ajustamos intervalo a
        % la derecha:
        if F{k}(r) >= 0 && F{k}(a) >= 0 || F{k}(r) < 0 && F{k}(a) < 0
            a = r;
        
        % En caso contrario ajustamos hacia la izquierda.
        else
            b = r;
        end
    
    end
    disp(r)
end

% Para función logarítmica no nos funciona porque logaritmo no está
% definido para número negativos.

a = 0.1;
b = 10;
r = 1;

while abs(f3(r)) >= tau
    
    % Calculo el valor de r en cada iteración:
    r = (a+b)/2;
    
    % Si la función en r tiene el mismo signo que a ajustamos intervalo a
    % la derecha:
    if f3(r) >= 0 && f3(a) >= 0 || f3(r) < 0 && f3(a) < 0
        a = r;
    
    % En caso contrario ajustamos hacia la izquierda.
    else
        b = r;
    end

end

disp("Solución Función 3")
disp(r)

%% III.1.c. Eficiencia:

% Comentario al respecto en el informe: pero acá lo que hacemos es
% cronometrar cuanto tarda en encontrar las 3 raíces cada función o
% algoritmo.
tic
NR(@f1, @df1, 1);
NR(@f2, @df2, 1);
NR(@f3, @df3, 1);
toc

tic
BS(@f1,-10,10);
BS(@f2,-10,10);
BS(@f3,0.1,10);
toc

%% III.1.d. Funciones:

sol1nr = NR(@f1, @df1, 1);
sol2nr = NR(@f2, @df2, 1);
sol3nr = NR(@f3, @df3, 1);


sol1bs = BS(@f1,-10,10);
sol2bs = BS(@f2,-10,10);
sol3bs = BS(@f3,0.1,10);


%% III.2 APLICACIÓN RAÍCES DE UNA FUNCIÓN

% Limpiamos lo realizado anteriormente:
clear;
close all;
clc;

%% III.2.a. Solución Tiro Vertical con NR y BS

% Sabemos que la función h(t) indica la altura de la pelota para cada
% instante t. Note que esta función se hará cero cuando la pelota vuelva al
% piso. 

% Para encontrar altura máxima entonces, debemos encontrar la raíz de la
% derivada de la función h(t) ya que nos indicará en que momento t la
% función alcanza su máximo (suponiendo que la CSO en ese punto es < 0).

% Dicho en otras palabras, al encontrar la raíz de la función estamos
% encontrando en que momento la velocidad se hace 0, para luego pasar a ser
% "negativa".

% Dicho lo anterior creamos las funciones dh y d2h en archivos .m separados
% para encontrar la solución con los algoritmos NR y BS.

% Con Newton Raphson:
sol_tv_nr = NR(@dh, @d2h, 1);

% Con Bisección:
sol_tv_bs = BS(@dh, -10, 10);


%% III.2.b.

% Ahora creamos función h(t) en archivo .m separado: h.m

% Luego la evaluamos en la solución de cualquiera de los dos algoritmos
% (coinciden!)
max_height = h(sol_tv_nr);


%% III.2.c. Velocidad en t*:

% Velocidad en t*, será aproximadamente cero. 
vel_nr  = dh(sol_tv_nr);
vel_bs = dh(sol_tv_bs);

% Velocidad con solución NR en t* es más cercana a cero pese a tener igual
% umbral o stopping rule.

% Comentario al respecto en el informe.

%% III.2.d. Caída Libre:

% Comentario al respecto en el informe.


%% IV. INTRODUCCIÓN A FUNCIONES IMPULSO RESPUESTA (IRF)

% Limpiamos lo realizado anteriormente:
clear;
close all;
clc;

%% IV.A Simulación AR(1)

% Partimos de un valor de 1 y luego actualizamos según (16) del enunciado.
x0 = 1; % Elijo uno arbitrariamente.

% Fijo valor de theta y de periodos:
theta = 0.9;
T = 500;

% Genero vector de residuos:
resid = randn(T,1);

% Genero serie:
xt = NaN(T,1);

% Intenté no hacerlo vía loop pero no se me ocurrió una manera de hacerlo.
xt(1,1) = theta*x0+resid(1,1);
for i = 2:T
    xt(i) = theta*xt(i-1)+resid(i,1); 
end

% Agregamos "shock perturbador" en t=0 a la serie usando el mismo vector de
% residuos: resid. Nueva serie perturbada: xt_2
xt_2 = NaN(T,1);

% Agregamos "shock perturbador".
x0_2 = 1+1;

% Generamos proceso AR(2) con shock en t=1, theta y T se mantienen iguales.
xt_2(1,1) = theta*x0_2+resid(1,1);
for i = 2:T
    xt_2(i) = theta*xt_2(i-1)+resid(i,1); 
end

% Ploteamos ambas series de tiempo en conjunto:
% Graficamos proceso simulado AR(2)
plot(xt)
hold on;
plot(xt_2)
hold off;
% Notamos como las series luego de unos periodos son inconfundibles. Ya no
% podemos pillar la serie azul luego del periodo ~ 30.

% IRF será diferencia entre serie perturbada y no perturbada.
IRF = xt_2 - xt;

% La ploteamos:
tx = {'Interpreter','Latex','FontSize', 17};
figure(1);
plot(IRF);
title("Impulse Response Function: $\theta$ = 0.9",tx{:});
xlabel("T", tx{:});
xlim([0 50])

%% IV.B. IRF Para Distintos Coeficientes Autoregresivos.
theta_vec = [0.1 ; 0.2 ; 0.4 ; 0.6 ; 0.8 ; 0.95];

% Para hacer loop posterior y no redefinir a cada rato:
thetas = {'$\theta = 0.1$','$\theta = 0.2$','$\theta = 0.4$',...
        '$\theta = 0.6$','$\theta = 0.8$','$\theta = 0.95$'};

for i = 1 : size(theta_vec,1)
    
    % Primero generamos serie AR(1)
    xtb = NaN(T,1);
    xtb(1,1) = theta_vec(i)*x0+resid(1,1);
    for j = 2:T
        xtb(j) = theta_vec(i)*xtb(j-1)+resid(j,1); 
    end
    
    % Ahora generamos serie perturbada (usamos x0_2): 
    xt_2b = NaN(T,1);
    xt_2b(1,1) = theta_vec(i)*x0_2+resid(1,1);
    for k = 2:T
        xt_2b(k) = theta_vec(i)*xt_2b(k-1)+resid(k,1); 
    end
    
    % Computamos IRF:
    IRFb = xt_2b - xtb;

    % Ploteamos:
    figura = figure(1);
    subplot (2,3,i);
    plot(IRFb);
    title(thetas(i),tx{:});
    sgtitle("IRF para distintos Coeficientes Autoregresivos", tx{:});
    xlim([0 50]);
    xlabel("T", tx{:});

end


%% IV.C. Descarga + Importación Data

% Desde la página del Banco Mundial, busqué bastante rato para pillar la
% serie solicitada con el código: NY.GDP.PCAP.KN.

% Esta serie corresponde a la suma bruta del producto agregado por todos
% los residentes de la economía más cualquier impuesto al producto y menos
% cualquier subsidio no incluido en el valor de los productos. 

% El Banco Mundial calcula el PIB per cápita dividiendo el producto por la
% "midyear population". Esta serie se calcula con moneda local constante.

% 1. GDP per Cápita (Constant LCU).
gdp = readtable('gdp.xlsx');

% Ploteamos la serie de tiempo:
figure(2)
plot(gdp.period, gdp.gdp_pc)
title("PIB per Capita Chile" ,tx{:})

%% IV.D. Ciclo + Tendencia PIB per Cápita con Filtro HP

% Obtenemos tendencia y ciclo de la serie. Usamos parámetro de sensibilidad
% de 6.25 dado que la data es anual (recomendación de Prof. Javier Turén).
lambda4 = 6.25;
[tendencia4, ciclo4] = HP(gdp, lambda4);

% Ploteamos:
figure(3)
plot(gdp.period, ciclo4);
hold on;
plot(gdp.period, tendencia4); 
title("Ciclo y Tendencia (HP) del PIB per Capita con $\lambda = 6.25$" ,tx{:})
legend('Ciclo','Tendencia')
hold off;

%% IV.E. Estimando vía OLS el Coeficiente Autoregresivo:

% Como nos dices que debemos estimar un AR(1) debemos estimar vía OLS
% (haciendo vista gorda a la clara no estacionariedad. 

% Al igual que en el ítem II debemos armar la matriz de X e y.

gdp_l = [gdp(1:(size(gdp.gdp_pc)-1),2)];
gdp_lag = table2array(gdp_l);

gdp_n = [gdp(2:size(gdp.gdp_pc),2)];
gdp_norm = table2array(gdp_n);

% Ahora armamos matrices X e y (sin constante según ecuación 16):
X_g = gdp_lag;
y_g = gdp_norm;

% Estimamos los parámetros del Modelo 1:
theta_gdp = (X_g'*X_g)^(-1)*(X_g'*y_g);


%% IV.F. IRF con Serie.

% Primero que nada hacemos predicciones según el theta estimado.
y_hat = theta_gdp * X_g;

% De esta manera podemos despejar el residuo del proceso AR(1) estimado.
residuo = y_g - y_hat;

% Dado el theta estimado podemos ahora estimar el contrafactual; es decir,
% la serie de tiempo observada en caso de que hubiese habido un shock de
% epsilon = 1.

% Entonces sumo 1 a el primer residuo:
residuo(1,1) = residuo(1,1)+1;

% Número de Periodos en esta serie:
T2 = size(X_g,1);

% Y ahora estimamos la serie con shock:
X_g2 = NaN(T2,1);
X_g2(1,1) = X_g(1,1)+residuo(1,1);
for k = 2:T2
    X_g2(k) = theta_gdp*X_g2(k-1)+residuo(k,1); 
end

% Entonces la IRF será:
IRF_gdp = X_g2-X_g;

% La IRF se ve bien rara. En parte debe ser por el theta > 1.
tx = {'Interpreter','Latex','FontSize', 17};
figure(4);
plot(IRF_gdp);
title("Impulse Response Function GDP per Capita Shock=1 in t=1",tx{:});
xlabel("T", tx{:});
xlim([0 49])


% Ploteamos ambas Series (contrafáctica con la original):
figure(5);
plot(X_g2);
hold on;
plot(X_g);
title("Serie Con y Sin Shock",tx{:});
xlabel("T", tx{:});
legend('Con Shock','Sin Shock')
hold off;

%% IV.G. Variando Persistencia (theta)

% Aprovechando el vector de thetas creado antes hago un loop sobre esos
% thetas: theta_vec. Este vector tiene puros theta menores que 1.

figure(6);
for j = 1: size(theta_vec,1)
    X_g2 = NaN(T2,1);
    X_g2(1,1) = X_g(1,1)+residuo(1,1);
    for k = 2:T2
        X_g2(k) = theta_vec(j)*X_g2(k-1)+residuo(k,1); 
    end
    IRF_gdp = X_g2-X_g;

    % Ploteamos:
    plot(IRF_gdp); 
    title("IRF GDP per Capita (Shock = 1 en t = 1) para distintos Theta" ,tx{:})
    hold on;

end
legend('IRF con $\theta = 0.1$','IRF con $\theta = 0.2$', ...
    'IRF con $\theta = 0.4$', 'IRF con $\theta = 0.6$', ...
    'IRF con $\theta = 0.8$', 'IRF con $\theta = 0.95$', tx{:});
hold off;


% Veamos que pasa ahora para thetas mayores que como en el acápite
% anterior.
theta_vec2 = [1 1.01 1.02 1.03 1.04 1.05]';


figure(7);
for j = 1: size(theta_vec2,1)
    X_g2 = NaN(T2,1);
    X_g2(1,1) = X_g(1,1)+residuo(1,1);
    for k = 2:T2
        X_g2(k) = theta_vec2(j)*X_g2(k-1)+residuo(k,1); 
    end
    IRF_gdp = X_g2-X_g;

    % Ploteamos:
    plot(IRF_gdp); 
    title("IRF GDP per Capita (Shock = 1 en t = 1) para distintos Theta" ,tx{:})
    hold on;

end
legend('IRF con $\theta = 1$','IRF con $\theta = 1.01$',...
    'IRF con $\theta = 1.02$', 'IRF con $\theta = 1.03$', ...
    'IRF con $\theta = 1.04$', 'IRF con $\theta = 1.05$', tx{:});
hold off;


%% IV.H. Variando Shock Transitorio:

% Creamos un vector de distintas magnitudes de Shock:
epsilons = [1 10 100 1000 10000 100000];

% Usando el Theta estimado en IV.E hacemos variar magnitud shock hasta 10^5
for j = 1: 6
    X_g2 = NaN(T2,1);
    X_g2(1,1) = X_g(1,1)+residuo(1,1)+epsilons(j);
    for k = 2:T2
        X_g2(k) = theta_gdp*X_g2(k-1)+residuo(k,1); 
    end
    IRF_gdp = X_g2-X_g;

    % Ploteamos:
    plot(IRF_gdp); 
    title("IRF GDP per Capita para distintos Shocks en(t = 1)" ,tx{:})
    hold on;

end
legend('IRF con $\epsilon = 1$','IRF con $\epsilon = 10$', ...
    'IRF con $\epsilon = 100$', 'IRF con $\epsilon = 1000$', ...
    'IRF con $\epsilon = 10000$', 'IRF con $\epsilon = 100000$', tx{:});
hold off;

