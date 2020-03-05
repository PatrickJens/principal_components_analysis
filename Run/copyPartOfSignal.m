function [data] = copyPartOfSignal(vector,start, stop)
%COPYPARTOFSIGNAL Summary of this function goes here
    size = stop - start ;
    data = zeros(size,1);
     for i=start:stop
         data(i-start+1) = vector(i);
     end
end

