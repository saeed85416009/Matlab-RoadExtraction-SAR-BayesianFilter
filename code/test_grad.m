clc;clear all;

global x
global gradient ; 
global match_wide;

a=imread  ( 'E:\internet\uni\proje\matlab\London.jpg');
b=rgb2gray(a);
x=double(b); 

 mask_1 = [ 1 2 1 ; 0 0 0 ; -1 -2 -1 ] ;
 mask_3 = [ 1 0 -1 ; 2 0 -2 ; 1 0 -1 ] ;
 mask_2 = [ -2 -1 0 ; -1 0 1 ; 0 1 2 ] ;
 mask_4 = [ 0 1 2 ; -1 0 1 ; -2 -1 0 ] ;

gradient1 = abs( M_SOBEL_GRADIENT (mask_1));
gradient2 = abs( M_SOBEL_GRADIENT (mask_2));
gradient3 = abs( M_SOBEL_GRADIENT (mask_3));
gradient4 = abs( M_SOBEL_GRADIENT (mask_4));

gradient5 = sqrt(gradient1.^2 + gradient3.^2 );
gradient6 = sqrt(gradient2.^2 + gradient4.^2 );



figure(1)
subplot(2,2,1)
imshow(uint8(gradient1))

subplot(2,2,2)
imshow(uint8(gradient2))

subplot(2,2,3)
imshow(uint8(gradient3))

subplot(2,2,4)
imshow(uint8(gradient4))


figure(2)

subplot(1,2,1)
imshow(uint8(gradient5))

subplot(1,2,2)
imshow(uint8(gradient6))

