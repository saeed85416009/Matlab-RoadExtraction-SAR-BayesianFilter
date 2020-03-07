function [ grad ] = M_GRADIENT (Cut_Gradient, SIZE_X, SIZE_Y,MASK)
%%%gradiant image with sobel mask%%%%%
global x

g = conv2(x, MASK);
grad=abs(g);

for i=1:SIZE_X
    for j=1:SIZE_Y
        if grad(i,j) >Cut_Gradient
            grad(i,j)=255;
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%