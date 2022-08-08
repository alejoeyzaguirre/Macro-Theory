function [tr_assets, tr_cons]= panel(seed,A,Ap,tr_shocks,pro, N,T,w,r)

tr_assets_pos = NaN(N,T+1); % Trayectoria Posiciones.

% Todos los agentes parten (arbitrariamente) con "seed" de Activos.
tr_assets_pos(:,1) = sum(A<=seed); % Posición Grilla de activos "seed".

% Partimos algoritmo:
for i = 1:N % Para cada agente:
   
    actual_pos = sum(A<=seed);
    
    for t = 2:T+1 % Para cada periodo:
        state = tr_shocks(i,t-1); % Encuéntrame el estado de productividad en t-1.
        %tr_assets(i,t) = Ati(state,actual_pos); % Reemplázame con el valor de activos óptimo de t.
        new_pos = Ap(state, actual_pos); % Reemplázame con la posición del valor de activo óptimo de t.
        tr_assets_pos(i,t) = new_pos;
        actual_pos = new_pos; % Actualizo posición actual. 

    end

end

tr_assets = A(tr_assets_pos);
tr_cons = (1+r)*tr_assets(:,1:T) + w*pro(tr_shocks) - tr_assets(:,2:T+1);

end