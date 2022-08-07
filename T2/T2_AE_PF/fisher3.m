function [Vt,At,Ct,St,Ap,Am,Cm,L_barra,A_barra,Kt] = fisher3(T,alpha,beta,sigma,rho,r,A,Z,liq,g)
% Salario.
w = (1-alpha)*(alpha/(r+sigma))^(alpha/(1-alpha)); % Genero Vector de Salarios.
w(w<0) = 0;
% Acceso al crédito: Creamos vector de deuda máxima para cada periodo t.
b = zeros(1,T+1); % Prealocación. Note que el periodo T+1 (66) nos sirve 
% para forzar cumplimiento de condición de Transversalidad (muero con 0).
% Activos parten y terminan en 0.

for t = T:-1:1 % Parto de atrás hacia adelante.
    pr=productividad(t);
    b(t) = (b(t+1)-w*pr)/(1+r); % Usando recursión hacia atrás vamos llenando
    % nuestro vector de deuda máxima que puede adquirir en todo t.
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
% ahorros!!!
Ap = NaN(length(A),T);   %Asset matrix position --> Posiciones
Am = Ap;                 %Asset matrix value --> Valor.
Cm = Ap;                 %Consumption matrix


%Value function iteration
for t = T:-1:1 
        pr=productividad(t);
        b_pos = sum(A<b(t)) + 1; % Posición Grilla de Activos Factible, para
        % un agente de edad T. No puede tener menos deuda que el b_pos que
        % es la deuda máxima!
        c = w*pr + (1+r).*A(b_pos:end) - A(b_pos_p:end)'; % Calculamos policy!
        % NOTA: Explicado en iPad abajo.
        % Vector columna - Mismo vector transpuesto = matriz (1001x1001).  
        % Primera fila de matriz será la resta de primer componente por 
        % cada uno de los elementos del vector trapuesto.
        % Matriz consumo 1001 x 1001. Matriz posibilidades de consumo
        % (factibles).
        % Matriz ni vector son de 1001. Esto porque deuda no puede ser
        % negativa. Solo nos quedamos con grilla de consumo factible.
        c(c<=0)=NaN; % Me olvido de consumos negativos. Los hago NaN.

        Vaux = util(c,rho) + beta*Vt(b_pos_p:end,t+1)'; % Sumo vector (
        % 2º término) a cada fila de la matriz de utilidades.
        % util(c,sigma)--> Matriz de x=648 (Nº de values factibles de la 
        % grilla original para a_t+1) * y=626 (Nº de values factibles de la 
        % grilla original para a_t) en t = 65. 
        % Primer elem es matriz de x*y y 2º elem es un vector de 1*y.
        % También podríamos haber hecho una matriz que repita el vector de
        % 1*y x veces hacia abajo.
        
        [V,P] = max(Vaux,[],2); % Valor máximo matriz (value function) y la
        % posición para encontrar la policy function (consumo). Vaux será de
        % dimensiones (Nº de values factibles de a_t)*(Nº de values factibles de a_t+1)
        % max(...,2) arroja el valor máximo para cada fila, es decir el
        % valor máximo para cada value fn calculada para ese valor de a_t
      
        % Note que la posición permite inducir el valor de a_t+1 (variable de control)
        % que maximiza el consumo para cada valor posible de a_t (var. estado).

        % Note que P puros 1, es decir el primer valor de a_t+1 (el menor --> 0)
        % es el que hace máxima la value fn para cada var de control a_t.
        
        % Rellenamos matriz original V_t con Value Function encontrada para t!
        Vt(b_pos:end,t) = V; % Varios elems de V_t (354 de hecho) serán NaN
        % estos son todos los no factibles (requería tener deuda mayor a la
        % máxima).
        Ap(b_pos:end,t) = b_pos_p - 1 + P; % Posición a matriz original y 
        % no pedazo de matriz. Ap solo la posición. Note que para reescalar
        % a la matriz original de A's lo que hacemos es sumar a cada
        % posición P el valor 376.
        % Am rellena el value de a_t+1 crack,
        Am(b_pos:end,t) = A(b_pos_p - 1 + P); % Recordemos que A es vector (grilla).
        
        % Ahora podemos tener "policy function general". 
        % Note que A(b_pos_p - 1 + P) es la grilla óptima de activos para
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
        Cm(b_pos:end,t) = w*pr + (1+r).*A(b_pos:end) - A(b_pos_p - 1 + P);
        
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
    % en t = 0 por lo que partimos en 2. 
    Asset_life_pos(t) = Ap(Asset_life_pos(t-1),t-1); % Luego recursivamente
    % avanzamos hasta t = 66, yendo hacia Ap y vemos la posición en la
    % grilla original del valor óptimo (que maximiza value fn) de a_t+1 
    % (var. control) a elegir dado el valor de a_t (var estado) en t.
    % De eta manera elaboramos un vector fila que tiene la "trayectoria óptima
    % a través de la grilla de activos original A" de la variable a_t+1
    % (control).
end

% Encontramos el valor de Activos según la posición dada por la "trayectoria óptima
% a través de la grilla de activos original A".
At = A(Asset_life_pos)'; %Policy function assets

% Obtenemos productividades de cada grupo etario:
Pr=arrayfun(@productividad, 1:T+1);

% Y ahora obtenemos consumo óptimo según la policy function de a_t. Note
% que podemos despejar c_t ya que At contiene los valores óptimos de a_t y
% a_t+1 para todo t. Salario depende de productividad.
Ct = w.*Pr(1:T) + (1+r)*At(1:T) - At(2:T+1); %Policy function consumption.
% Segundo término sería a_t por R de t = 1 a 65. Y tercer término sería 
% a_t+1 de 1 a 65 también. 

% Ahorro Flujo:
St = At(2:T)-At(1:T-1);

% Buscamos oferta agregada de Trabajo y de Activos: AHORA mt ≠ 1/T! 
Mt = crecimiento(g,(1:T),T);
L_barra= sum(Mt.*Pr(2:T+1)); % Usamos productividad pregunta 2
A_barra = sum(Mt.*At(2:T+1)); % Calculamos A_barra

% Ahora encontramos oferta agregada de Capital:
Kt= (alpha/(r+sigma))^(1/(1-alpha))*L_barra;

end