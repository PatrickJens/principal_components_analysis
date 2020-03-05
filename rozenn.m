function [] = rozenn(A)
A= [ 1 -3 3 ; 3 -5 3 ; 6 -6 4 ];
% det(A - lambda*I) = 0 
[v,d] = eig(A)
v
d

A*v

