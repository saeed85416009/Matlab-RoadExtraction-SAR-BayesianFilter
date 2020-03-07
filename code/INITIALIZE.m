

function INITIALIZE (a , color)

%% global

global x 
global t
global edge_canny
global  unaceptive_point
global max_margin
global white
global black
global image
global M
global N

max_margin =10;

b=rgb2gray(a);
x=double(b);
level = graythresh(b);
level = im2uint8(level)
% pause

% CUT_IMAGE_PARIS_3()                 %%---**---%%



mask = ( 1/115) * [ 2 4 5 4 2 ; 4 9 12 9 4 ; 5 12 15  12  5 ; 4 9 12 9 4 ; 2 4 5 4 2 ];
x= conv2(mask , x);       %% softening image
[M , N ] =size(x);
image = x;

for i= 1:M                     %% i know that road in dark position isnt more than ... gray level therfor i assume gray level of image is max in non road  
    for j=1:N
        if x(i,j) > 255             %%---**---%%
            x(i,j) = 255;
        end
    end
end

if color == white
    x=255 - x;
end

% CUT_IMAGE_PARIS_3_1()               %%---**---%%

y=x;
t=x;                  %% use for canny edge detector and find best distance between edge 


for i= 1:M                     %% i know that road in dark position isnt more than ... gray level therfor i assume gray level of image is max in non road  
    for j=1:N
        if x(i,j) > level             %%---**---%%
            t(i,j) = 255;
        else
            t(i,j) =0;
        end
    end
end

% figure(3)
% imshow(uint8(t))
if color == black
    % [e , r ]   = MinimaxAT(t)  ;
    BW2 = bwareaopen(t, 10);
    F = imfill(BW2,'holes');
    BW2 = double(F);
else
    BW2 = t;
end
% 
% BW2 = x;
% 
[ S , T ] =size(BW2);

for i = 1 :S
    for j = 1 : T
        
        if BW2(i,j) > 0
            bw(i,j) = 255;
        else
            bw(i,j) = 0;
        end
        
    end
end
%  
% %%% use for find edge in process
edge_canny = bw; 
% %%% high light out of road
x = x + bw;
% edge_canny = t;
for i= 1:M                     %% i know that road in dark position isnt more than ... gray level therfor i assume gray level of image is max in non road  
    for j=1:N
        if x(i,j) > 255            %%---**---%%
            x(i,j) = 255;
        end
    end
end
 %%%%%%%%%%%%%%%%%%%  canny edge detector %%%%%%%%%%%%%%%%%%%%%%
% edge_canny = EDGE_FND_CANNY ( t );
% figure (4)
% imshow(uint8(edge_canny))
 
 %%% margin around of image that point of roud must be bigger than margin   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 p=0;
 for  i = 1:max_margin
     for j = 1 : N
         
         p=p+1;
         unaceptive_point(p,1)=i;
         unaceptive_point(p,2)=j;
         
     end
 end
 
  for  i = 1:M
     for j = 1 : max_margin
         
         p=p+1;
         unaceptive_point(p,1)=i;
         unaceptive_point(p,2)=j;
         
     end
  end
 
 
  for  i = M - max_margin : M
     for j = 1 : N
         
         p=p+1;
         unaceptive_point(p,1)=i;
         unaceptive_point(p,2)=j;
         
     end
 end
 
  for  i = 1:M
     for j = N - max_margin : N
         
         p=p+1;
         unaceptive_point(p,1)=i;
         unaceptive_point(p,2)=j;
         
     end
 end
 
 
 
 
 
 
 

