function [Cti,Ati,S,Vf,Ap] = value3(beta,sigma,r,w,A,tol,pro,tr,imp,L)

e = 1;
iter = 0;
T=L*imp; % Presupuesto Equilibrado de Gobierno!
Vf = zeros(length(A),length(tr)); %Guess de semilla inicial: Partimos con ceros!

% Exigimos nivel de tolerancia de 0,01.
while e > tol % Pararemos hasta que error sea menor que tolerancia. En otras
              % palabras no paramos si error es mayor a tolerancia.
    
    %Prealocation
    Vp = NaN(length(A),length(tr));%Value function: 5x1001.
    Ap = NaN(length(A),length(tr));%Optimal asset: 1x1001. Grilla de activos.
    % Una columna para cada estado.
    
    for i = 1 : length(pro) % Para cada valor de productividad. (Matriz cúbica?)
        
            Caux = (1+r).*A' + w*pro(i)*(1-imp) - A + T; %Consumption
            % Calculamos consumo factible de cada periodo (se obtiene 
            % despejando c_t de RP para todo t. 
            % Ojo! Hacemos resta element wise! Para cada elemento de A'
            % (vector columna) restaremos cada elemento del vector fila A
            % a ese mismo elemento de A'. Obtenemos una matriz de
            % 1001x1001. Note la introducción de los impuestos y Transf.
      
            Caux(Caux<=0) = NaN; % Si consumo factible negativo no factible!
            % Note que como A' se achica para arriba y A crece para la
            % derecha entonces es de esperar que la parte Noreste son NaN.
            % : ).
            Vaux= Util(Caux,sigma) + beta*tr(i,:)*Vf';% Calculamos Bellman!
            % Note la función de Vf la value fn futura!. Iteramos sobre la
            % función de valor y la actualizamos : ).
            % Notemos como mete la matriz de transición. Ponderamos según
            % vector de 1x5 (fila de matriz de transición). Es decir para
            % cada nivel de productividad ponderamos la función de valor
            % para cada nivel de productividad según las respectivas
            % probabilidades condicional que hoy estamos con un nivel de
            % productividad "i".
            % Note que tr(i,:) es de 1x5 y Vf' de 5x1001 entonces lado
            % derecho (como beta escalar) será de 1x1001.
            % Util(Caux,sigma) es de 1001x1001. 
            
            [Vp(:,i),Ap(:,i)]= max(Vaux,[],2);%Policy
            % Rellenamos iésima columna de Vp con el valor máximo de Vaux
            % para cada fila. Es decir el valor máximo para cada posible
            % valor de la variable de estado (A) para estado prod. "i". 
            % Rescatamos además la posición en cada fila en que se
            % maximiza, es decir así podemos rescatar el valor de a_t+1 o
            % a' que maximiza la función de valor!
            % Obtenemos el máximo para cada valor de productividad.
   
    end  
    
     
    e = max(max(abs(Vf-Vp)));%Error
    % Se calcula intentando que Vf sea ~ Vp. La métrica para calcular
    % distancia es comparar los máximos de los máximos de diferencia de Vf
    % vs Vp. Vf es la antigua Vp la actual.
                              
    iter = iter + 1 ; % Para cachar cuánto se demora en converger.
    Vf = Vp; % Vf será la antigua! Actualizamos para siguiente iteración de
    % while.
    
    if iter == 200 % Si se pasan de la raya el número de iteraciones... 
        % paramos. 
         break
    end
% No paro hasta converger! o 200 iteraciones!  
end


fprintf('____________________________________________________________\n');
fprintf(...
'Convergencia de la función de Valor en %d iteraciones para tolerancia de %0.0e \n',...
[iter,tol]);
fprintf('Error de aproximación: %0.2f \n',e);
fprintf('_____________________________________________________________\n');


Cti = (1+r)*A + w*pro*(1-imp) - A(Ap') + T; %Optimal consumption a partir de los assets 
% óptimos rescatados con la posición óptima Ap.
Ati = A(Ap'); %Optimal assets
S = w*pro - Cti; % Ahorro! Ingreso que no gasto en consumo. 
% Solo ingreso laboral por ahora.
Ap = Ap'; 
Vf = Vf'; % Value function

end