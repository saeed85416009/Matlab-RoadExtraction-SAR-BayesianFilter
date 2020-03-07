function  REGULARIZED_SAMPLE_2()

global sample_t

size_sample_t = size(sample_t);
k=size_sample_t(1);
class_number_old = max(sample_t(:,1));
class=1;
flag_find_class = 0;
simple_sample_t=sample_t;
i_s=0;


    
        for j=2:k

            if sample_t(j-1,1) == sample_t(j,1)
                
                
                simple_sample_t( j , 1 ) = class;
                simple_sample_t( j-1 , 1 ) = class;
            else
                class = class + 1;
                simple_sample_t( j , 1 ) = class;
                

            end

        end
    

sample_t=[];
sample_t=simple_sample_t;

