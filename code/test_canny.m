

%%
%%%%%%  create image and smooth that %%%%%%%%%%%%
clc;clear all;
global x ;
global gradient ; 
global match_wide;

a=imread  ( 'E:\internet\uni\proje\matlab\bahman\image\azadi-tower_tehran_24-jun-2009.jpg');
b=rgb2gray(a);
x=double(b);
t=x;

[M , N ] =size(t);
for i= 1:M
    for j=1:N
        if x(i,j) > 100
            t(i,j) = 255;
        end
    end
end

CUT_IMAGE_PARIS_3()



figure(2)
imshow(uint8(x))

mask = ( 1/115) * [ 2 4 5 4 2 ; 4 9 12 9 4 ; 5 12 15  12  5 ; 4 9 12 9 4 ; 2 4 5 4 2 ]

x= conv2(mask , x);

y=x;

%%% sobel gradient %%%%%%%%%%%%%%%%
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
%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%canny%%%%%%%%%%%%%%%%%%%%
figure(3)
imshow(uint8(gradient5))

[BW thresh ]=edge(t,'canny'  );
figure(4)
imshow(BW)