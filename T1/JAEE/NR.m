function sol = NR(funcion, derivada, inicial)
    actual = inicial;
    % A medida que la imagen de la función en el valor actual (resultado de
    % una iteración previa) es mayor que 10^-4 entonces sigue iterando.
    while abs(funcion(actual)) >= 10^(-4)
        % Actualizo valor según NR
        actual = actual - (funcion(actual))/(derivada(actual));
    end
    sol = actual;
end