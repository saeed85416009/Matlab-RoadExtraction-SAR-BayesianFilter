function [ gradient ] = GRADIENT (Cut_Gradient, SIZE_X, SIZE_Y)
%%%gradiant image with sobel mask%%%%%
global x
G1 = [ 1 0 -1 ; 2 0 -2 ; 1 0 -1 ] ;
G2 = [ -2 -1 0 ; -1 0 1 ; 0 1 2 ] ;
resX = conv2(x, G2);
resY = conv2(x, G1);
gradient = sqrt(resX.^2 + resY.^2);

for i=1:SIZE_X
    for j=1:SIZE_Y
        if gradient(i,j) >Cut_Gradient
            gradient(i,j)=255;
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%