function [ covariance ] = smith2_1_4_covarianceExample()

product_differences = [] ;
sum_product_differences = [] ;
n = [] ;
% vectors

hours = [9,15, 25, 14, 10, 18, 0 , 16, 5, 19, 16, 20 ] ;
mark = [39, 56, 93, 61, 50, 75, 32, 85, 42, 70, 66, 80 ] ;

m_hours = mean(hours) ;
m_mark = mean(mark) ;

hours_diff = hours - m_hours ;
mark_diff = mark - m_mark ;
n = size(hours,2) ;

for i = 1:size(hours, 2) % should have used matrix multiplication
    product_differences =  [product_differences, hours_diff(1, i) * mark_diff(1, i) ]
end

covariance = sum(product_differences)/(n-1)