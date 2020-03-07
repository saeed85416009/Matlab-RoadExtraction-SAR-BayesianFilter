function  REGULARIZED_SAMPLE()

global sample_t

size_sample_t = size(sample_t);
k=size_sample_t(1);
class_number_old = max(sample_t(:,1));
class=0;
flag_find_class = 0;
simple_sample_t=sample_t;
i_s=0;

for i = 1 : size_sample_t(1)
    if sample_t(i,2)==0
        sample_t(i,:)=[];
    end
end

size_sample_t = size(sample_t);

for i = 1 : class_number_old
    
    if flag_find_class == 0
     class=class+1;
     flag_find_class = 1;
    end
    
        for j=1:k

            if sample_t( j , 1 ) == i
                
                i_s = i_s + 1;
                flag_find_class = 0;
                simple_sample_t( i_s , 1 ) = class;
                simple_sample_t( i_s , 2:end ) = sample_t( j , 2:end );


            end

        end
    
end
sample_t=[];
sample_t=simple_sample_t;

