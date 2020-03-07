% 
%%%%%%  create image and smooth that %%%%%%%%%%%%
global x 
global edge_canny  
global match_wide
global M
global N 
global cluster 
global max_profile
%%% global firm value

 global dt                                      %% distance between point in first point
 global dtt
 global  r_optimum                        %% initialize row for priori estimate   (pixel)                    %%---**---%%
 global c_optimum                        %% initialize column for  priori estimate (pixel)                %%---**---%%
 global angle
 global angle_old
 global angle_optimum 
 global contrast_road                 %% firm value for road contrast in edge_canny state for moving in point ( gray level )
 global W
 global WMM                           %% Wide Margin for Matching  
 global unaceptive_point
%%%%%%
 global min_wide_break_point
 global th_angle_break_point
 global min_number_of_branch_in_intersection
 global th_merge_angle_break
global th_max_angle_one_branch
global gray_eliminate
%%%%%%%%%%%%%%%%%%%%%%%
global p_1




 global particle_new_row 
 global particle_new_column 
 global angle_first_point                                                                                              %%---**---%%
 global th_angle_particle_1 
 global th_angle_particle_2 
 global th_distance_clusterring
 global th_angle_new_point 
 global th_forward_dis
 global th_angle_merge_cluster 
 global th_angle_measurement 
 global th_angle_measurement_intersection 
 global th_angle_true_from_center 
 global th_eliminate_angle 
 global th_gray_eliminate
 global th_angle_find
 global th_dis_angle_find
 global th_angle_particle_first
 global th_angle_good_find
 global th_angle_particle_first_time
 global th_dis_particle_first_time
 global th_max_dis_particle_first_time
 %%% for add
 global th_angle_add 
 global th_gray_add 
 global min_sample_number 
 global min_dis_add 
 global max_dis_add 
 %%%%%
 global gray_class 
 global B
 %%%%%
global intersection
global detour 
global th_angle_measurement_final_point
%%%%%%%%%%%%%%%%%%%%%%%
global result_project
global memmory_point
% global unaceptive_point
%%%%%% initialize road %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






% global WMM_high
% 
% [X,b] = hist(a,[min(a) :1:max(a)]);
% 
% [index t] = max(b);
% 
% figure
% imshow(uint8(x))
%         
%         
%             a=IMAGE
%      figure,imshow(a)
%      a=im2double(a);
%      img=rgb2gray(a);
%     figure,imshow(img)
%     local_threshold(img)
%     e=0
%     r=0
%   [e , r ]   = MinimaxAT(x)   
% %         
%    bw = adaptivethresh(x , 15, 15,'gaussian') ;    
%    bw=double(bw);
%    [u,y]=size(bw);
%    for i=1:u
%        for j =1:y
%            if(bw(i,j)==1)
%                bw(i,j)=255;
%            end
%        end
%    end
   
%     e   
%     figure(1)
%     subplot(1,2,1)
%  imshow((r ))
%  subplot(1,2,2)
%  b=EDGE_FND_CANNY(r)
%  imshow((b ))
%  
%  
%  
%  figure(2)
%  subplot(1,2,1)
% imshow((e ))
% subplot(1,2,2)
% BW2 = bwareaopen(a, 100)
% % imshow((a ))
% % 
% % BW2 = bwmorph(a,'close')
% % 
% % a = edge(x,'canny');
% H=rgb2gray(IMAGE);
% y=0
% r=double(r);
%  figure(2)
%  subplot(1,2,1)
% imshow((a ))
% subplot(1,2,2)
% % BW2 = bwmorph(a,'remove',2)
% imshow((BW2 ))
% 
% 
%     figure(1)
%     subplot(1,2,1)
%  imshow((r ))
%  subplot(1,2,2)
%  b=EDGE_FND_SOBEL(e)
%  imshow((b ))
% 
% 
% figure(3)
%     subplot(1,2,1)
%  imshow((a ))
%  subplot(1,2,2)
% [ b , y]=bwlabel(a)
% BW3 = imfill(a,'holes')
%  imshow((BW3 ))
% % 
% %  BW2 = imfill(BW2,'holes')
% %  
% %  
%  
%  I = imread('http://i.stack.imgur.com/SUvif.png');
IMAGE=imread  ( 'E:\mat\image\11maq.png');    %%---**---%%

% INITIALIZE (IMAGE )

b=rgb2gray(IMAGE);
x=double(b);
x=255-x;
level = graythresh(b);
level = im2uint8(level);

% CUT_IMAGE_PARIS_3()                 %%---**---%%

  [e , r ]   = MinimaxAT(x)  ;

mask = ( 1/115) * [ 2 4 5 4 2 ; 4 9 12 9 4 ; 5 12 15  12  5 ; 4 9 12 9 4 ; 2 4 5 4 2 ];
x= conv2(mask , x);       %% softening image

% CUT_IMAGE_PARIS_3_1()               %%---**---%%

y=x;
t=x;                  %% use for canny edge detector and find best distance between edge 
[M , N ] =size(t);

for i= 1:M                     %% i know that road in dark position isnt more than ... gray level therfor i assume gray level of image is max in non road  
    for j=1:N
        if x(i,j) >= level             %%---**---%%
            t(i,j) = 1;
        else
            t(i,j) = 0;
        end
    end
end
% a=EDGE_FND_SOBEL(x);
a=t;
% a=IMAGE;
figure(1)
imshow(a)

BW2 = bwareaopen(a, 200);
    figure(4)
    imshow(BW2)
    I=a;
    %Fill all the holes 
    F = imfill(I,'holes');

    %Find all the small ones,and mark their edges in the image
    bw = bwlabel(I);
    rp = regionprops(bw,'FilledArea','PixelIdxList');
    indexesOfHoles = [rp.FilledArea]<0;   
    pixelsNotToFill = vertcat(rp(indexesOfHoles).PixelIdxList); 
    F(pixelsNotToFill) = 0;
    figure(8);imshow(F);

    %Remove the inner area
    bw1 = bwlabel(F,4);
    rp = regionprops(bw1,'FilledArea','PixelIdxList');
    indexesOfHoles1 = [rp.FilledArea]<0;
    pixelListToRemove = vertcat(rp(indexesOfHoles1).PixelIdxList);
    F(pixelListToRemove) = 0;

    figure(3);imshow(F);
    
    
    
    
    %# read binary image
bw = a;

%# find all boundaries
[B,L,N,A] = bwboundaries(bw, 8, 'holes');

%# exclude inner holes
[r,~] = find(A(:,N+1:end));        %# find inner boundaries that enclose stuff
[rr,~] = find(A(:,r));                      %# stuff they enclose
idx = setdiff(1:numel(B), [r(:);rr(:)]);    %# exclude both
bw2 = ismember(L,idx);                      %# filled image

%# compare results
subplot(2, 2, 1), imshow(bw), title('original')
subplot(2 ,2 ,2), imshow( imfill(bw,'holes') ), title('imfill')
subplot(2, 2 ,3), imshow(bw2), title('bwboundaries')
 
 figure(5)
  imshow(bw2), title('bwboundaries')

