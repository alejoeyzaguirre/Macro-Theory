function u= util(c, rho)
    %Función CRRA explicitada en el enunciado.
            if rho==1
                u= log( c );
            else
                u= ( c.^(1-rho) -1)/(1-rho);
            end
            
end