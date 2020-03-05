function [covariance ] = smithExercise2_1_4__1 ()

prod_diff = [] ;
sum_prod_diff = [] ;

x = [ 10 39 19 23 28 ] ;
y = [43 13 32 21 20 ] ;

mx = mean(x) ;
my = mean(y) ;

n = size(x, 2) ;

x_diff = x - mx ;
y_diff = y - my ;

for i = 1:n
    prod_diff =[ prod_diff, x_diff(1,i) * y_diff(1, i) ] ;
end

covariance = sum(prod_diff)/(n-1)

fprintf('X and Y have a negative correlation'); % ??????

    
