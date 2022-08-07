function g= productividad(t)
    g = (40./(0.4.*t.*(2.*pi).^(0.5)))*exp(-0.5.*((log(t)-log(32.5))./(0.4)).^2) + 0.4;
end