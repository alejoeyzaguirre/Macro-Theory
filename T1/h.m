function imagen = h(t)
    % Como altura inicial esta en cms, y la velocidad esta en metros así 
    % como también la aceleración, ajustamos altura inicial: v0 = 0.5 (mts)
    imagen = 0.5 + 4.5*t - (1/2)*9.81*(t^2);
end