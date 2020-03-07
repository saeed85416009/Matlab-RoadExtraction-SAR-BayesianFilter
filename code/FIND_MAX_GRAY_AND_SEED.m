function  [LEVEL , SEED ] = FIND_MAX_GRAY_AND_SEED( ROW , COLOUMN , ANGLE ,WIDE , OLD_LEVEL )

global x
global max_gray_total
global max_margin

[M , N] = size(x);
max_w = 2*WIDE;
fi = ANGLE;

seed =[];
add = 0;
for dis = 0 : 2*max_w
    
    r_4 = ROW - dis*sind(fi);
    c_4 = COLOUMN + dis*cosd(fi);
    
    
        for dis_ar = -max_w : max_w
            
            r_3 = r_4 + dis_ar * sind(90 - fi);
            c_3 = c_4 + dis_ar * cosd(90 - fi);
            
            flag_duplicate_seed = 1;
            size_seed = size(seed);
            if (numel(seed) ~= 0)
                for i = 1: size_seed(1)

                    if ( round(r_3) == round(seed(i,2)) ) && ( round(c_3) == round(seed(i,3)) )

                        flag_duplicate_seed =0;

                    end
                end
            end
            
            if (floor(r_3) > max_margin) && ( floor(c_3) > max_margin) && (ceil(r_3) < M - max_margin) && ( ceil(c_3) < N - max_margin)
%                                           note ='      nliug;ougpigoi'
% pause
                if flag_duplicate_seed == 1

                        ceil_ceil_seed = x(ceil(r_3),ceil(c_3));
                        floor_floor_seed = x(floor(r_3),floor(c_3));
                        floor_ceil_seed = x(floor(r_3),ceil(c_3));
                        ceil_floor_seed = x(ceil(r_3),floor(c_3));
%                         pause

                    if ( x(ceil(r_3),ceil(c_3)) ) < max_gray_total

                        add = add+1;
                        seed(add,1) = x(ceil(r_3),ceil(c_3));
                        seed(add,2) = ceil(r_3);
                        seed(add,3) = ceil(c_3);
%                         pause
                    end
                        
                        
                     if ( x(floor(r_3),floor(c_3)) ) < max_gray_total    
                        if floor_floor_seed ~=  ceil_ceil_seed
                            add = add+1;
                            seed(add,1) = x(floor(r_3),floor(c_3));
                            seed(add,2) = floor(r_3);
                            seed(add,3) = floor(c_3);
                        end
                     end
                        
                     if ( x(ceil(r_3),floor(c_3)) ) < max_gray_total 
                        if (ceil_floor_seed ~=  ceil_ceil_seed ) && ( ceil_floor_seed ~=  floor_floor_seed )
                            add = add+1;
                            seed(add,1) = x(ceil(r_3),floor(c_3));
                            seed(add,2) = ceil(r_3);
                            seed(add,3) = floor(c_3);
                        end
                     end
                     
                     
                      if ( x(floor(r_3),ceil(c_3)) ) < max_gray_total   
                        if (floor_ceil_seed ~=  ceil_ceil_seed ) && ( floor_ceil_seed ~=  floor_floor_seed ) && ( floor_ceil_seed ~=  ceil_floor_seed )
                            add = add+1;
                            seed(add,1) = x(floor(r_3),ceil(c_3));
                            seed(add,2) = floor(r_3);
                            seed(add,3) = ceil(c_3);
                        end
                      end
                        
                        
                        


                end
            end
        end
            
end

if numel(seed) ~= 0

LEVEL = graythresh(uint8(seed(:,1)));
LEVEL = im2uint8(LEVEL);

SEED=seed;
            
                                    IMSHOW_IMAGE_KALMAN_ostad(seed , 2 , 3 , 6)
else
    SEED=0;
    LEVEL =0
    max_gray_total
    ROW
    COLOUMN
    WIDE
    ANGLE
    LEVEL =OLD_LEVEL
   note ='  numel (seed) = 0 in find max gray'
    pause
end













