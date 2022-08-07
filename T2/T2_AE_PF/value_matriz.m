function [Vt,At,Ct,St,Ap,Am,Cm] = value_matriz(T,beta,rho,r,A,Z,liq)

% Salario.
w = Z(1:T); % Genero Vector de Salarios.
% Hago cero los salarios negativos:
w(w<0) = 0;

% Acceso al crédito: Creamos vector de deuda máxima para cada periodo t.
b = zeros(1,T+1); % Prealocación. Note que el periodo T+1 (66) nos sirve 
% para forzar cumplimiento de condición de Transversalidad (muero con 0).
% Activos parten y terminan en 0.

for t = T:-1:1 % Parto de atrás hacia adelante.
    b(t) = (b(t+1)-w(t))/(1+r); % Usando recursión hacia atrás vamos llenando
    % nuestro vector de deuda máxima que puede adquirir en todo t. iPad.
        if b(t) >= -liq % No activa, se endeuda lo que quiere.
            b(t) = b(t);
        else 
            b(t) = -liq; % Activa, se endeuda el máximo que puede.
        end  
end
b_pos_p = sum(A<b(end)) + 1; % b(end) es un escalar. Compara cada columna de A
% con último elemento de b, los sumo y encuentro posición en que Activos
% pasa a ser cero (justo valor en que está cero). Lo usaremos en Value Function.


% Prealocación:
Vt = NaN(length(A),T+1); %Value matrix: de 1001 x 66. (así podemos usar recursión
% hacia atrás).
Vt(b_pos_p:end,end) = 0; % Semilla inicial. Sabemos que agentes no pueden 
% morir con deuda. Ergo en periodo 66 value function será cero para todas las
% posibilidades de A de t = 66 que implican NO deuda (sí se puede morir con
% "ahorros")!!!
Ap = NaN(length(A),T);   %Asset matrix position --> Posiciones
Am = Ap;                 %Asset matrix value --> Valor.
Cm = Ap;                 %Consumption matrix


%Value function iteration
for t = T:-1:1   
        b_pos = sum(A<b(t)) + 1; % Posición Grilla de Activos Factible, para
        % un agente de edad "t". No puede tener menos deuda que el b_pos que
        % es la deuda máxima!
        % Sirve para acotar espacio de variables de estado factibles en ese
        % periodo "t".

        % A es vector columna.

        c = w(t) + (1+r).*A(b_pos:end) - A(b_pos_p:end)'; % NO Calculamos policy!
        
        % Todos los consumos posibles para cada valor factible de la variable de
        % estado (fila) y para todos los factibles escenarios de A' determinados
        % por la grilla de activos "A" (columna).

        % Vector columna - Mismo vector transpuesto = matriz (1001x1001).  
        % Primera fila de matriz será la resta de primer componente por 
        % cada uno de los elementos del vector trapuesto.
        % Matriz consumo 1001 x 1001. Matriz posibilidades de consumo
        % (factibles). Solo me quedo con valores de la variable de estado
        % factibles.
        % Matriz ni vector son de 1001. Esto porque deuda no puede ser
        % negativa. Solo nos quedamos con grilla de consumo factible.
        c(c<=0)=NaN; % Me olvido de consumos negativos. Los hago NaN.

        Vaux = util(c,rho) + beta*Vt(b_pos_p:end,t+1)'; % Sumo vector (
        % 2º término) a cada fila de la matriz de utilidades calculadas
        % para todos los valores de consumo factibles determinados por los 
        % A y A' factibles de cada t.

        % Segundo término corresponde a la value function obtenida para el
        % periodo siguiente en la iteración anterior. Recursión hacia
        % atrás!

        % util(c,sigma)--> Matriz de x=648 (Nº de values factibles de la 
        % grilla original para a_t) * y=626 (Nº de values factibles de la 
        % grilla original para a_t+1) en t = 65. 
        % Primer elem es matriz de x*y y 2º elem es un vector de 1*y.
        % También podríamos haber hecho una matriz que repita el vector de
        % 1*y x veces hacia abajo.
        
        [V,P] = max(Vaux,[],2); % Valor máximo matriz (value function) y la
        % posición para encontrar la policy function (consumo). 
        
        % Vaux será de dimensiones:
        % (Nº de values factibles de a_t)*(Nº de values factibles de a_t+1)
        % max(...,2) arroja el valor máximo para cada fila, es decir el
        % valor máximo para cada value fn calculada para ese valor de a_t
        % que es la variable de estado! Maximizamos value function para
        % cada valor (factible) de la variable de estado.
      
        % Note que la posición permite inducir el valor de a_t+1 (variable de control)
        % que maximiza el consumo para cada valor posible de a_t (var. estado).

        % Note que P puros 1, es decir el primer valor de a_t+1 (el menor --> 0)
        % es el que hace máxima la value fn para cada var de estado a_t.
        
        % Rellenamos matriz original V_t con Value Function encontrada para t!
        Vt(b_pos:end,t) = V; % Varios elems de V_t (354 de hecho) serán NaN
        % estos son todos los no factibles (requería tener deuda mayor a la
        % máxima en ese "t").

        Ap(b_pos:end,t) = b_pos_p - 1 + P; % Posición a matriz original y 
        % no pedazo de matriz. Ap solo la posición. Note que para REESCALAR
        % a la matriz original de A's lo que hacemos es sumar a cada
        % posición P el valor 376.
        
        % Am rellena el value (no la posición) de a_t+1.
        % OJO: Relleno para cada valor factible de la state var. Reescalo
        % con b_pos_p. Todos los demás valores "sobre" es decir más
        % negativos que el que está en b_pos_p se mantienen NaN's.
        
        % OJO CON P!! POSICIONES ÓPTIMAS : ).

        Am(b_pos:end,t) = A(b_pos_p - 1 + P); % Recordemos que A es vector (grilla).
        % Relleno Am con vector en la columna (t) y desde la fila (factible)
        % correspondiente. Fila factible serían aquellos valores de stock
        % de activos menores al nivel máximo de deuda posible de sostener. 

        % Obtenido usando restricción No-Ponzi + Consumo 0 en RP para todo
        % t.


        % Ahora podemos tener "policy function general". 
        % Note que A(b_pos_p - 1 + ¡P!) es la grilla óptima de activos para
        % el siguiente periodo dada cada una de las variables de estado
        % (a_t) posible en el periodo t.

        % Cm entonces arroja para cada variable de estado A (del -15 al
        % 25) el valor de consumo óptimo. Por ejemplo en t=65, si el agente tiene
        % -0.88 de deuda (stock de activos dado que resulta ser también el 
        % valor máximo de deuda que puede tener en t=65)
        % el consumo que maximiza la función de valor es 0.0098 
        % (prácticamente no consumir mañana).
        % Por otro lado, si una persona tiene a_t (stock de activos) de 25
        % en t = 65, el consumo que maximiza su función de valor es 26.9250
        % Ahora consume mucho porque tiene mucho ahorro (25) en t y además
        % tiene un sueldo en t=65 por lo que consumirá mucho!
        Cm(b_pos:end,t) = w(t) + (1+r).*A(b_pos:end) - A(b_pos_p - 1 + P);
        % Podría haber usado Am(b_pos:end,t) en vez de tercer término.
        
        % Actualizamos b_pos_p!!!! Tenía dudas de eso : ), ya no.
        % Vamos achicando el espacio en que trabajamos. Ahora el espacio
        % factible se va achicando. Nuevo Nº x (Nº de values factibles de la 
        % grilla original para a_t+1 en t.
        b_pos_p = b_pos;
end


%Policies functions: Aplicando que nace y muere con A = 0: a_0 = a_66 = 0.
Asset_life_pos = NaN(1,T); % Prealocación.
Asset_life_pos(1) = sum(A<0)+1; % Encontramos posición de A = 0.

for t = 2:T+1 % Ya tenemos la posición de grilla original de A que "elegirá"
    % en t = 0 por lo que partimos en 2. a_1 = 0.
    Asset_life_pos(t) = Ap(Asset_life_pos(t-1),t-1); % Luego recursivamente
    % avanzamos hasta t = 66, yendo hacia Ap y vemos la posición en la
    % grilla original del valor óptimo (que maximiza value fn) de a_t+1 
    % (var. control) a elegir dado el valor de a_t (var estado) en t.
    % De esta manera elaboramos un vector fila que tiene la "trayectoria óptima
    % a través de la grilla de activos original A" de la variable a_t+1
    % (control).

    % Ojo que AP tiene la posición óptima de activos para cada valor de la
    % variable de estado en cada t pero hasta t = 65 es decir en realidad
    % tiene el valor de activos óptimo no para cada t sino que para cada
    % t+1! Por eso le ponemos puros t-1 : ).
end

% Encontramos el valor de Activos según la posición dada por la "trayectoria óptima
% a través de la grilla de activos original A".
At = A(Asset_life_pos)'; %Policy function assets

% Y ahora obtenemos consumo óptimo según la policy function de a_t. Note
% que podemos despejar c_t ya que At contiene los valores óptimos de a_t y
% a_t+1 para todo t. 
Ct = w(1:T) + (1+r)*At(1:T) - At(2:T+1); %Policy function consumption.
% Segundo término sería a_t por R de t = 1 a 65. Y tercer término sería 
% a_t+1 de 1 a 65 también. 

% Ahorro Flujo:
St = At(2:T)-At(1:T-1);

end