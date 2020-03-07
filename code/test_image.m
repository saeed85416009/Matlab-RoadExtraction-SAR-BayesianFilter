%%
%%%%%%  create image and smooth that %%%%%%%%%%%%
clc;clear all;

a=imread  ( 'E:\internet\uni\proje\matlab\kish.jpg');
b=rgb2gray(a);
x=double(b);


global x ;
global gradient ; 
global y ;
global match_wide;




figure(2)
imshow(uint8(x))

y = x;  


 

 %% 
 %%%%%%%% algorithm %%%%%%%%%%%
 
 %%%gradiant image with sobel mask%%%%%
G1 = [ 1 0 -1 ; 2 0 -2 ; 1 0 -1 ] ;
G2 = [ -2 -1 0 ; -1 0 1 ; 0 1 2 ] ;
resX = conv2(x, G2);
resY = conv2(x, G1);
gradient = sqrt(resX.^2 + resY.^2);



figure (1)
imshow(uint8(gradient))
%%%%%%%%%%%%%%%%%%%%%%%
 