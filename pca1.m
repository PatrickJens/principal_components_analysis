function [] = pca1()

% Get data
x = [ 2.5 0.5 2.2 1.9 3.1 2.3 2.0 1.0 1.5 1.1 ]' ; 
y = [ 2.4 0.7 2.9 2.2 3.0 2.7 1.6 1.1 1.6 0.9 ]' ;
xx = linspace(-2,2);

% Get mean
mx = mean(x) ;
my = mean(y) ;

% Mean adjusted data is the data vectors minus the mean of that vector
x_adjusted = x - mx ;
y_adjusted = y - my ;

% Get Covariance matrix
% Get Eigenvalues and Eigenvectors
A = cov(x,y);
[v, d ] = eig(A);
fprintf('Eigenvalues are %.4f and %.4f\n', d(1,1), d(2,2));
fprintf('Eigenvectors are\n');
v(:,1);
v(:,2);


% Identified PRINCIPLE COMPONENT and created 
e1 = v(:,2);
e2 = v(:,1);
e1y = e1(1,1)/e1(2,1) * xx ;
e2y = e2(1,1)/e2(2,1) * xx ;
dot(e1,e2); % Confirmed Eigenvectors orthogonal


% Plots data using Eigenvectors as orthonormal basis vectors.
% Principle Component on x-axis, other Eigenvector on y-axis
% transformedData = featureVector' * [ x y]'
featureVector = [ -e1 , e2 ] ; % -1 * P.C. to follow Smith, L.I.
xy = [x_adjusted   y_adjusted ]
% transformedData = featureVector' * xy' ;

% Covariance of the transformed data is is the Eigenvalue matrix (EXTRA)
% x_transpose = transformedData(1,:);
% y_transpose = transformedData(2,:);
% cov(x_transpose, y_transpose); 
% 
% 
% 
% 1D Transformation calculations using Principle Component
% transformedData1D = featureVector(:,1)' * xy' ;
% 
% Regenerate Original Data 
% transformedData = FV' * xy'; therefore, FV^(-1) * transformedData = xy'
% Just so happens inv(FV) is transpose bc unit eigenvectors
% regeneratedData1D = featureVector(:,1) * transformedData1D;
% 
% fprintf('Ask about 1D regenerated data and PC. Is what I did a valid way to draw PC\n');
% Regenerated 1D data
% figure;
% scatter( regeneratedData1D(1,:) , regeneratedData1D(2,:) , '*', 'k') ;
% title('Regenerated 1D Data');
% xlim([-2 2])
% ylim([-2 2])
% hold on
% scatter(xx, e1y, '.', 'b')
% legend('1D Transformed Data', 'Principle Component')
% 
% 1D Transformed Data
% figure;
% scatter( transformedData1D,zeros(1,10), '*', 'k') ;
% title('1D Transformed Data using Principle Component');
% xlim([-2 2])
% ylim([-2 2])
% hold on
% scatter([0:0.02:1.28], zeros(1,65), '.', 'b')
% legend('1D Transformed Data', 'Principle Component')
% 
% 2D Transformed data plotted with Eigenvectors
% figure;
% scatter( transformedData(1,:),transformedData(2,:), '*', 'k') ;
% title('2D Transformed Data with Eigenvectors. Transform is a Rotation.');
% xlim([-2 2])
% ylim([-2 2])
% hold on
% scatter([0:0.02:1.28], zeros(1,65), '.', 'b')
% scatter(zeros(1,492),[0:0.0001:0.0491], '.', 'g')
% legend('transformed data', 'e1', 'e2')
% hold off 
% 
% Adjusted Data Plot
% figure;
% scatter( x_adjusted,y_adjusted, '*', 'k') ;
% title('Mean Adjused Data fitted with Eigenvectors');
% xlim([-2 2])
% ylim([-2 2])
% hold on
% scatter(xx, e1y, '.', 'b')
% scatter(xx, e2y, '.', 'g')
% legend('mean adjusted', 'e1', 'e2')
% hold off 
% 
% Original Data Plot
% figure;
% scatter( x,y, '*', 'k') ;
% title('Original Data');
% xlim([0 4]);
% ylim([0 4]);