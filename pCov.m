function [ covariance ] = pCov( a, b )

prod_of_diff = [] ;
sum_prod_diff = [] ;

ma = mean(a) ;
mb = mean(b) ;

n = size(a, 2) ;

a_diff = a - ma ;
b_diff = b - mb ;

for i = 1:n
    prod_of_diff =[ prod_of_diff, a_diff(1,i) * b_diff(1, i) ] ;
end

covariance = sum(prod_of_diff)/(n-1) 
