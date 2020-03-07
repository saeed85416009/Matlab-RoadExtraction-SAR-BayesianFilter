
clc
clear all




I = imread('cameraman.tif');
subplot(2,2,1); 
imshow(I); title('Original Image');

H1 = fspecial('motion',3,45);
MotionBlur = imfilter(I,H1,'replicate');
subplot(2,2,2); 
imshow(MotionBlur);title('Motion Blurred Image');

H2 = fspecial('disk',10);
blurred = imfilter(I,H2,'replicate');
subplot(2,2,3); 
imshow(blurred); title('Blurred Image');

H3 = fspecial('unsharp');
sharpened = imfilter(I,H3,'replicate');
subplot(2,2,4); 
imshow(sharpened); title('Sharpened Image');


H1=double(H1);
MotionBlur=double(MotionBlur);
 J1 = deconvlucy(MotionBlur, H1);
 
 figure(2)
 imshow(uint8(J1))

