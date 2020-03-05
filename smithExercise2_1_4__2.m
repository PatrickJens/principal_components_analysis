function [ matricks ] = smithExercise2_1_4__2 ()
load('pCov')

covarianceMatrix = zeros(3) ;


n = 3 ; 
x = [ 1 -1 4]  ;
y = [ 2 1 3 ]  ;
z = [ 1 3 -1 ] ;

vectors  = [ x ; y ; z ] ;
vectors(1,:) ;% (r,c)

for i = 1:n
    for j = 1:n
        if i >= j 
            covarianceMatrix(i,j) = pCov( vectors(i,:), vectors(j,:) );
            covarianceMatrix(j,i) = covarianceMatrix(i,j) ;
        end
    end
end

covarianceMatrix

cov(x,x)
cov(x,y)
cov(x,z)
cov(y,z)
