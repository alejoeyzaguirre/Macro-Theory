function [xg,Tr]= discAR(n, rho,sde)
%-------------------------------------------------------------------------%
% process: log(x')= c + rho*log(x) + e, e~N(0,sigma).
%   - define y= log(x).
%-------------------------------------------------------------------------%
muX= 1;
if (n<=5), m= 1.5;  elseif (n<=7), m= 2;  else, m= 3;  end
    
% moments
sdY=   sde/sqrt(1-rho^2);
muY=   log(muX) - sdY^2/2;
c=     muY*(1-rho);

% grids
if (n>1)
    ymin=  muY - m*sdY; 
    ymax=  muY + m*sdY;
    ystep= (ymax-ymin)/(n-1);
    yg= zeros(1,n);
    for y= 1:n
       yg(y)= ymin + (y-1)*ystep;
    end
else
    yg=    muY;
end
xg=  exp(yg)';


% Transition Matrix
if (n>1)   
    Tr= zeros(n,n);                             % pi{k,j}= Pr(y'=yj|y=yk)  
    
    % from y{k}
    for k= 1:n        
        
        % to y'{j}
        for j= 1:n
            Tr(k,j)=  normcdf( (yg(j) + ystep/2 - c-rho*yg(k) )/sde ) ...
                    - normcdf( (yg(j) - ystep/2 - c-rho*yg(k) )/sde );
        end           
        Tr(k,:) = Tr(k,:)/sum(Tr(k,:));
    end
    
else
    Tr= 1;
end
