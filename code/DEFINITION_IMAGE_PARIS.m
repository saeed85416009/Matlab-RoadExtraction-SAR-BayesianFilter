%%% definition image

function DEFINITION_IMAGE_PARIS()

global x
global edge_canny

a=imread  ( 'E:\internet\uni\proje\matlab\Paris.jpg');    %%---**---%%
b=rgb2gray(a);
x=double(b);
level = graythresh(b)
level = im2uint8(level)

% CUT_IMAGE_PARIS_3()                 %%---**---%%



mask = ( 1/115) * [ 2 4 5 4 2 ; 4 9 12 9 4 ; 5 12 15  12  5 ; 4 9 12 9 4 ; 2 4 5 4 2 ]
x= conv2(mask , x);       %% softening image

% CUT_IMAGE_PARIS_3_1()               %%---**---%%

y=x;
t=x;                  %% use for canny edge detector and find best distance between edge 
[M , N ] =size(t);

for i= 1:M                     %% i know that road in dark position isnt more than ... gray level therfor i assume gray level of image is max in non road  
    for j=1:N
        if x(i,j) > level             %%---**---%%
            t(i,j) = 255;
        end
    end
end

%%%%%%%%%%%%%%%%%%%  canny edge detector %%%%%%%%%%%%%%%%%%%%%%
edge_canny = EDGE_FND_CANNY ( t );
figure (1)
imshow(uint8(edge_canny))
 
 %%% regulator parameter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 
 
 