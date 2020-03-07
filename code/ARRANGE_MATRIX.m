function [X]=ARRANGE_MATRIX(MATRIX)

A=MATRIX;
[M , N ] = size(A);

for i = 1:M
    for j=1:N
[ a b ] = min(A);
A(b) = 255;
X(i,j) = a;
    end
end





