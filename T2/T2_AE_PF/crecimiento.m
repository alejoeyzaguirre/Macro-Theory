function m= crecimiento(g,t,T)
    F  = @(v) (1+g).^(T-v); % Creamos función anónima para simplificar.
    vec = F(1:T);
    m = F(t)/(sum(vec));
end