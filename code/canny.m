%% Read in
a=imread  ( 'E:\internet\uni\proje\matlab\image\sanaa.jpg');
figure(1),imshow(I)
I = double(I);
%% Determine Mask Size
sigma = 2;
w = mask_size(sigma);
%% Gaussian Smoothing Filter
[ G,sum ] = gauss_mask(w,sigma);
%% Convolve
I1 = (1/sum) * image_convolution(I,w,G);
figure(2),imshow(I1);
%% Ix(derivative in x-direction)
Ix= delx(I1);
figure(3),imshow(Ix);
%% Iy(derivative in y-direction)
Iy= dely(I1);
figure(4),imshow(Iy);
%% Gradient Magnitude
If = grad_mag(Ix,Iy);
figure(5),imshow(If);
%% Non-maxmimum suppression
It = suppression(If,abs(Ix),abs(Iy));
figure(6),imshow(It);



function [ G,sum ] = gauss_mask( w,sigma )
min = 1;
m = floor(w/2);
sum = 0;
for x = 1: w
    for y = 1:w
        g = x-m-1;
        h = y-m-1;
        k = -(g^2 +h^2)/(2*sigma^2);
        G(x,y) = exp(k);
        sum = sum + G(x,y);
        if min > G(x,y)
            min = G(x,y);
        end
    end
end
B=1/min;
G= B * G;
G = round(G);
end


function [ I2 ] = image_convolution(I,w,G)
m= (w-1)/2;
N= size(I,1);
M=size(I,2);
for i=1:N
    for j=1:M
        if (i > N-m-1 || j > M-m-1 || i<m+1 || j <m+1)
            I2(i,j) = 0;
            continue;
        end
        sum1 = 0;
        for u=1:w
            for v=1:w
                sum1 = sum1+I(i+u-m-1,j+v-m-1)*G(u,v);
            end
        end
        I2(i,j)=sum1;
    end
end
end


function [ Ix ] = delx( image )
mask = [-1 0 1; -2 0 2; -1 0 1];
Ix =image_convolution(image,3,mask);
end

function [ Iy ] = dely( image )
mask = [-1 -2 -1;0 0 0;1 2 1];
Iy =image_convolution(image,3,mask);
end

function [ Imag ] = grad_mag(Ix,Iy)
m=size(Ix,1);
n=size(Ix,2);
for i=1:m
   for j=1:n
            Imag(i,j) =sqrt(Ix(i,j)^2 + Iy(i,j)^2);
   end
end
end

function [ It ] = suppression( If,Ix,Iy )
m=size(Ix,1);
n=size(Ix,2);
for i = 1:m
   for j=1:n
           if (j == 1 || j == n || i == 1 || j == n)
                It(i,j) = 0;
           else if (Ix(i,j)*Iy(i,j)> 0)
               f1 =If(i-1,j-1);
               f2 =If(i,j);
               f3 =If(i+1,j+1);
               It(i,j) = thinning(f1,f2,f3);
                else if(Ix(i,j)*Iy(i,j)< 0)
                    f1 =If(i+1,j-1);
                    f2 =If(i,j);
                    f3 =If(i-1,j+1);
                    It(i,j) = thinning(f1,f2,f3);  
                    else if(abs(Ix(i,j))-abs(Iy(i,j))>5)
                            f1 =If(i-1,j);
                            f2 =If(i,j);
                            f3 =If(i+1,j);
                            It(i,j) = thinning(f1,f2,f3);  
                            else if(abs(Iy(i,j))-abs(Ix(i,j)) > 5)
                                f1 =If(i,j-1);
                                f2 =If(i,j);
                                f3 =If(i,j+1);
                                It(i,j) = thinning(f1,f2,f3);
                                end
                        end
                    end
               end
           end
   end
end

end

function [ w ] = thinning( f1,f2,f3 )
if( f2>f1 && f2>f3)
    w =1;
else 
    w= 0;
end
end