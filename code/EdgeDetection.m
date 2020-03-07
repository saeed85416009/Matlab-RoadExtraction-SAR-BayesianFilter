function result=EdgeDetection(RGB)
% using matlab toolbox, edge, imfill, imclose(morphorogy), rgb2gray,
% rgb2BW,
% R,G,B processing seperate
% Read in the image
A=RGB;
% Convert the image into gray scale, R, G, and B. Perform the "edge"
% function to get the edge in different format.
% E_W: whole edge information without segregating the image.
% E_R: edge information of the Red.
% E_G: edge information of the Green.
% E_B: edge information of the Blue.
B=rgb2gray(A);
E_W=edge(B,'sobel',0.1);
E_R=edge((A(:,:,1)));
E_G=edge((A(:,:,2)));
E_B=edge((A(:,:,3)));
% E: the combination of the edge information of R, G, and B.
E=E_R+E_G+E_B;
LPF=ones(5,5);
[row col]=size(E);
result=zeros(row, col);
for i=3:row-2
for j=3:col-2
result(i,j)=sum(sum(LPF.*E(i-2:i+2,j-2:j+2)));
if (result(i,j)>0)
result(i,j)=1;
end
end
end
