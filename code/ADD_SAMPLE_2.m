function   SAMPLE_FOR_CLUSTER = ADD_SAMPLE_2 ( SAMPLE_FOR_CLUSTER , SAMPLE_NUMBER , CLASS_NUMBER_OLD , TH_ANGLE_ADD , TH_GRAY ,DIS , TH_DIS   )

global x_total;
global x

size_sample_for_cluster = size(SAMPLE_FOR_CLUSTER);
add=size_sample_for_cluster(1);
for class = 1 :  CLASS_NUMBER_OLD
    
    k=0;
    ext_sample=[];
    extention_sample=[];
    
    for j=1 : size_sample_for_cluster(1)
        
        if  SAMPLE_FOR_CLUSTER( j , 1 )==class  
            
            k=k+1;
            ext_sample(k , :) = SAMPLE_FOR_CLUSTER(j , :);
                
        end
        
    end
    
    weight_arrange = ARRANGE_MATRIX(ext_sample(:,6));
    r_y = 0;
    size_ext = size(ext_sample);
    size_weight = size(weight_arrange);
   
    for h = 1:size_weight(1)
    
        size_ext = size(ext_sample);  %% THIS SIZE CHANGE EATH STEP
        for d=1:size_ext(1)
           
            if ext_sample(d,6) == weight_arrange(h,1)
            
                r_y = r_y+1;
                extention_sample(r_y,:)=ext_sample(d,:);

                    ext_sample(d,:)=[];  
                   break;

            end
                                                
        end
        
    end  %% end for h = 1:size_weight
    
    size_extention = size(extention_sample);
    k=size_extention(1);
    angle = x_total(class,3)*180/pi;
    dis = DIS;
    while(k <= SAMPLE_NUMBER)
        
        
        for i = 1:size_extention(1)
        
            for fi = angle - TH_ANGLE_ADD : angle + TH_ANGLE_ADD
%               fi
                r_4 =  extention_sample(i,2) - dis * sind ( fi ) ;  
                c_4 =  extention_sample(i,3) + dis * cosd ( fi );
                
                flag_duplicate_extention=0;
                flag_duplicate_sample=0;
                
                                 for m = 1:size_extention(1)
                                      if ( round(r_4) == round(extention_sample(m,2)) ) && ( round(c_4) == round(extention_sample(m,3)) ) 

                                          flag_duplicate_extention = 1;

                                      end
                                 end
                    
                                  for m=1:size_sample_for_cluster(1)
                                         if  ( round(r_4) == round(SAMPLE_FOR_CLUSTER(m,2)) ) && ( round(c_4) == round(SAMPLE_FOR_CLUSTER(m,3)) )

                                             flag_duplicate_sample = 1;
                                             
                                         end
                                  end
                                  
                    if   (flag_duplicate_extention == 0) && (flag_duplicate_sample == 0)
                        
                        if (x(round(r_4),round(c_4)) < TH_GRAY )
                        
                                
                                %%% angle%%%
                                d(1)=r_4;
                                d(2)=c_4;
                                e(1)=x_total(class,1);
                                e(2)=x_total(class,2);
                                angle_new=ANGLE_FIND(d,e);
                                angle_radian=angle_new*pi/180;
                                %%%%%%%%%
                               abs_angle = ( abs(angle_new) - abs(angle));
                                if abs_angle > 180
                                    abs_angle = 360 - abs_angle ;
                                end
                                
                                if abs_angle < TH_ANGLE_ADD
                                            k=k+1;
                                            add=add+1;
                                        SAMPLE_FOR_CLUSTER(add,1)=class;
                                           SAMPLE_FOR_CLUSTER(add,2)=r_4;
                                              SAMPLE_FOR_CLUSTER(add,3)=c_4;
                                                  SAMPLE_FOR_CLUSTER(add,4)=angle_radian;
                                                    SAMPLE_FOR_CLUSTER(add,5)=extention_sample(i,5);
                                                        SAMPLE_FOR_CLUSTER(add,6)=extention_sample(i,6);
                                                            SAMPLE_FOR_CLUSTER(add,7)=extention_sample(i,7);
                                                                SAMPLE_FOR_CLUSTER(add,8)=extention_sample(i,8);
                                                                    SAMPLE_FOR_CLUSTER(add,9)=extention_sample(i,9);
                                                                        SAMPLE_FOR_CLUSTER(add,10)=extention_sample(i,10);
                                                                            SAMPLE_FOR_CLUSTER(add,11)=extention_sample(i,11);
                                                                                SAMPLE_FOR_CLUSTER(add,12)=extention_sample(i,12);
                                                                                    SAMPLE_FOR_CLUSTER(add,12)=extention_sample(i,12);
                                                                        
                               size_sample_for_cluster = size(SAMPLE_FOR_CLUSTER);    
                                end
                        end
                        
                    end
                    
                                        if k>SAMPLE_NUMBER
                                            break;
                                        end
                                  
            end

                                        if k>SAMPLE_NUMBER
                                            break;
                                        end
        end
        
                                        if k>SAMPLE_NUMBER
                                            break;
                                        end
                                        
                 dis=dis+1       
                 if(dis > TH_DIS)
                     break;
                 end
    end  %% end search while
    
end %% end search in class







