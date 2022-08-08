function [w]= wage(alfa,K,L)
    w = (1-alfa) * K^alfa * L^(-alfa);
end