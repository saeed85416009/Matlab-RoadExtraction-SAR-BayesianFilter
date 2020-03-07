function [ Iy ] = dely( image )
mask = [-1 -2 -1;0 0 0;1 2 1];
Iy =image_convolution(image,3,mask);
end