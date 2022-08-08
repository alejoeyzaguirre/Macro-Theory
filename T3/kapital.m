function [k]= kapital(alfa,r,delta,L)
    k = ((alfa/(r+delta))^(1/(1-alfa)))*L ;
end