function sol = BS(funcion, a,b)
    tau = 10^(-4);
    r = 1;
    while abs(funcion(r)) >= tau
        % Calculo el valor de r en cada iteración:
        r = (a+b)/2;
        % Si la función en r tiene el mismo signo que a ajustamos intervalo a
        % la derecha:
        if funcion(r) >= 0 && funcion(a) >= 0 || funcion(r) < 0 && funcion(a) < 0
            a = r;
        % En caso contrario ajustamos hacia la izquierda.
        else
            b = r;
        end
    
    end
    sol = r; 
end