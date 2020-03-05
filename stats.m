%A program that calculates the mean, standard deviation, and variance

function [ m , variance , stddev ] = stats()

v =[] ;
n = [] ;
sum = 0 ;
differenceSquared = 0 ;
stddev = 0 ;

disp('To work, at least 1 input must be entered');
numUser = input('Enter a integer: ');

% Acquire input
while ~isempty(numUser)
    v = [v, numUser] ;
    numUser = input('Enter a integer: ');
end

% Determine sample size
n = size(v,2);

% Determine mean
for i = 1:n
    sum = sum + v(1,i) ;
end
m = sum / n ;

% Determine variance
for i = 1:n
    differenceSquared = differenceSquared + ( v(1,i) - m ) ^ 2 ;
end
differenceSquared;
variance = differenceSquared/(n) ;

% Determine STD
stddev = sqrt(variance) ;

% Print

fprintf('The mean is %d\n', m);
fprintf('The variance is %d\n', variance);
fprintf('The standard deviation is %d\n', stddev);