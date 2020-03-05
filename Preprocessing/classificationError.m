function [outputArg1] = classificationError(data_matrix,PrincipalComponents)
%CLASSIFICATIONERROR Summary of this function goes here
%   Detailed explanation goes here

%Compute the projection, aka dot product
Projections = zeros(1,11);
% DOES NOT WORK Projections = dot(data_matrix, PrincipalComponents');
for i=1:5
    Projections(1,i) = data_matrix(1,:) * PrincipalComponents(:,i);
end
Projections = data_matrix*PrincipalComponents;
%Compute the reconstructed vector
Reconstructed = zeros(81,201);
Reconstructed = Projections * PrincipalComponents';

Error = norm(data_matrix - Reconstructed);
ErrorPercentage = Error/norm(data_matrix)



outputArg1 = ErrorPercentage ;
end

