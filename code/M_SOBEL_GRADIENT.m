function [grad ] = M_SOBEL_GRADIENT (mask)

global x
[M , N ] = size(x);

for i = 2:M-1
for j= 2 : N-1

s1 = x(i-1 , j-1 ) * mask(1,1);
s2 = x(i-1 , j ) * mask(1,2);
s3 = x(i-1 , j+1 ) * mask(1,3);
s4 = x(i , j-1 ) * mask(2,1);
s5 = x(i , j ) * mask(2,2);
s6 = x(i , j+1 ) * mask(2,3);
s7 = x(i+1 , j-1 ) * mask(3,1);
s8 = x(i+1 , j ) * mask(3,2);
s9 = x(i+1 , j+1 ) * mask(3,3);

s=s1+s2+s3+s4+s5+s6+s7+s8+s9;
grad(i,j) = s;

end
end


