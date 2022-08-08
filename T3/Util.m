function [U]= Util(C,sigma)

if sigma>0
    if sigma==1
        U= log(C);
    else
        U= (C.^(1-sigma))/(1-sigma);
    end
end