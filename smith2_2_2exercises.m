%int main()
function smith2_2_2exercises()

isEigenvector = [ 0 0 0 0 0 ] ;
T = [ 3 0 1 ; -4 1 2 ; -6 0 -2 ] ;

outVector = [] ;

e1 = [ 2 2 -1 ]' ;

e2 = [ -1 0 2 ]' ;

e3 = [ -1 1 3 ]' ;

e4 = [ 0 1 0 ]' ;

e5 = [ 3 2 1 ]' ;

eMatrix = [e1, e2, e3, e4, e5 ]

% for i = 1:5
%     outVector = T * eMatrix(:,i);
% end

outputM = T * eMatrix
fakeEigenM = zeros(3,5);
% determine if scalar multiple
for i = 1:5
    for j = 1:3
        fprintf('%d / %d is %d\n',outputM(j,i),eMatrix(j,i),outputM(j,i)/eMatrix(j,i) )
        fakeEigenM(j,i) = outputM(j,i)/eMatrix(j,i) ;
    end
end
fakeEigenM



