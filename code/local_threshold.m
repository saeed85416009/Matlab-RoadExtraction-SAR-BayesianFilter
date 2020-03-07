function input=local_threshold(img_input)
%     a=imread('img (10).jpg');
%      figure,imshow(a)
%      a=im2double(a);
%      img_input=rgb2gray(a);
%     figure,imshow(img_input)
[nRows nCols]=size(img_input);
var_row=round(nRows/3);
var_col=round(nCols/2);
img_crop_1=imcrop(img_input,[1 1 var_col var_row]);
img_crop_2=imcrop(img_input,[var_col 1 var_col var_row]);
img_crop_3=imcrop(img_input,[1 var_row var_col var_row]);
img_crop_4=imcrop(img_input,[var_col var_row var_col var_row]);
img_crop_5=imcrop(img_input,[1 var_row+var_row var_col var_row]);
img_crop_6=imcrop(img_input,[var_col var_row+var_row var_col var_row]);
% figure,subplot(3,2,1),imshow(img_crop_1),subplot(3,2,2),imshow(img_crop_2),subplot(3,2,3),imshow(img_crop_3),subplot(3,2,4),imshow(img_crop_4),subplot(3,2,5),imshow(img_crop_5),subplot(3,2,6),imshow(img_crop_6)
%%%%%%%%%%%%%%%%%%%%%%Find threshold value%%%%%%%%%%%%%%%%
avg_level_1=AvgGlevel(img_crop_1);
avg_level_2=AvgGlevel(img_crop_2);
avg_level_3=AvgGlevel(img_crop_3);
avg_level_4=AvgGlevel(img_crop_4);
avg_level_5=AvgGlevel(img_crop_5);
avg_level_6=AvgGlevel(img_crop_6);
%%%%%%%%%%%%%%%%%%%%%%Changing to binary%%%%%%%%%%%%%%%%%%%%
for i=1:nRows
    for j=1:nCols
        if(i>=1 & i<=var_row & j>=1 & j<=var_col)
            if(img_input(i,j)>=avg_level_1)
                img_input(i,j)=1;
            else
                img_input(i,j)=0;
            end
        end
        if(i>=var_row & i<=(var_row+var_row) &j>=1 &j<=var_col)
            if(img_input(i,j)>=avg_level_2)
                img_input(i,j)=1;
            else
                img_input(i,j)=0;
            end
        end
        if(i>=(var_row+var_row) & i<=nRows & j>=1 & j<= var_col)
            if(img_input(i,j)>=avg_level_3)
                img_input(i,j)=1;
            else
                img_input(i,j)=0;
            end
        end
        if(i>=1 & i<= var_row & j>=var_col & j<=nCols)
            if(img_input(i,j)>=avg_level_4)
                img_input(i,j)=1;
            else
                img_input(i,j)=0;
            end
        end
        if(i>=var_row & i<=(var_row+var_row) & j>=var_col & j<=nCols)
            if(img_input(i,j)>=avg_level_5)
                img_input(i,j)=1;
            else
                img_input(i,j)=0;
            end
        end
        if(i>=(var_row+var_row) & i<=nRows & j>=var_col & j<=nCols)
            if(img_input(i,j)>=avg_level_6)
                img_input(i,j)=1;
            else
                img_input(i,j)=0;
            end
        end
    end
end
input=img_input;
