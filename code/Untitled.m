
global x
a=imread  ( 'C:\Users\saeed\Desktop\Untitled.png');
b=rgb2gray(a);
x=double(b);
 mask_1 = [ 1 2 1 ; 0 0 0 ; -1 -2 -1 ] ;
 mask_3 = [ 1 0 -1 ; 2 0 -2 ; 1 0 -1 ] ;
 mask_2 = [ -2 -1 0 ; -1 0 1 ; 0 1 2 ] ;
 mask_4 = [ 0 1 2 ; -1 0 1 ; -2 -1 0 ] ;

[M , N ]= size(x);
cut = 200
gradient= abs(M_SOBEL_GRADIENT (mask_1));
imshow(uint8(gradient))