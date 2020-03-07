function IMSHOW_RESULT_PROJECT( IMAGE , M , N , F ,G )

global  max_margin 
global add_particle_to_kalman

size_a = size(add_particle_to_kalman);
remove=[];
size_r = size(IMAGE);
result = IMAGE;

add = size_r(1) ;
 
for i = 1:size_a(1)
    
    flag_bad_point = 1;
    
    
    for j = 1:4
        if add_particle_to_kalman(i,j)<max_margin
             flag_bad_point = 0;
        end
    end
    
    add = add + 1;
    if flag_bad_point ==1
       result(add , :) = add_particle_to_kalman(i,:);
    end
end

size_result = size(result);
add=0;
for i = 1:size_result(1)
    for j = 1:4
        if result(i,j) == 0
            add=add+1;
            remove(add)=i;
            break;
        end
    end
end

 if numel(remove) >0
result(remove,:) =[];
 end

IMSHOW_IMAGE_KALMAN(IMAGE , M , N , F)
IMSHOW_IMAGE_KALMAN(result , M , N , G)







