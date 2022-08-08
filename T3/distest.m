function [panel_S_aux,dist_f,e_bar] = distest(N,T,tr,pro)

random = rand(N,T);% Matriz con valores extraídos de una distribución 
% Uniforme que va de 0 a 1. Cada agente tiene en cada uno de sus 2000
% periodos un valor random asociado.
tr_acum = cumsum(tr,2); % Matriz con distribución acumulada. Note que 
% tr_acum tiene en su última col. puros 1. Es decir es la CDF condicional
% en que estado inicial es una fila en específico.

% Prealocación para Shocks en cada momento del tiempo para cada agente:
panel_S_aux = zeros(N,T); % Será rellanado con los estados que "le toca a 
% cada agente en cada t. 

% Semilla Inicial, suponemos que todos parten en el peor estado de
% productividad.
dis_t1 = ones(N,1);
panel_S_aux(:,1) = dis_t1;

for i = 1 : N % Para cada uno de los 10.000 agentes:
    for j = 1 : T-1 % Y en cada uno de los 2000 periodos que vive...
        
        current = panel_S_aux(i,j); % ¿Cuál es mi estado de prod. actual?
        future = 1; % Partimos con el Guess de 1 para el estado Futuro: Este
        % dependerá del valor random que "le toca" al agente en ese momento
        % del tiempo y de las probabilidades de transición de la matriz tr.
        
        while random(i,j) > tr_acum(current,future)
            future = future +1; 
            % Si el valor del shock (random) del agente i en el periodo j
            % es mayor que la densidad acumulada de la probabilidad de
            % transitar a el estado "future" iteramos (+1) y probamos con 
            % el siguiente valor hasta que el valor random sea inferior al 
            % valor acumulado asociado. 

            % Como random(i,j) in [0,1] y además tr_acum tiene en cada fila
            % (current) una CDF siempre se va a cumplir el while, por lo que
            % solo será posible actualizar "future" 4 veces. 

            % De esta manera tenemos un algoritmo que permite que los
            % agentes transiten (siempre) aleatoriamente de un periodo a 
            % otro, cambiando o no de estado, pero teniendo en cuenta la
            % matriz de transición.
        end 
        
        panel_S_aux(i,j+1) = future; % Guardamos el siguiente estado elegido
        % según el algoritmo especificado arriba. Este "future" pasará a
        % ser en la siguiente iteración "current" hasta que pasemos a otro
        % agente "i".
        
    end
end

dist_f = panel_S_aux(:,end); % Extraemos productividad de cada agente en el
% último periodo (2000) como se nos pide en preguntas futuras.
e_bar = mean(pro(dist_f)); % Con pro(dist_f) somos capaces de encontrar el 
% valor para cada estado asociado (1 al 5). Luego calculamos la media del
% vector y así obtenemos la productividad promedio que es relevante para
% preguntas futuras (2).

end