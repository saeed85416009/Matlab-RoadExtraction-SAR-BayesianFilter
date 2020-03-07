function  REGULARIZED_SAMPLE_3(M)

global sample_t

size_sample_t = size(sample_t);

for i = 1 : size_sample_t(1)
    if sample_t(i,2)==0
        sample_t(i,:)=[];
    end
end


class_number_old = max(sample_t(:,M));
class=0;
flag_find_class = 0;
i_s=0;
simple_sample_t=sample_t;
size_sample_t = size(sample_t);
k=size_sample_t(1);
t=size_sample_t(2);

for i = 1 : class_number_old
    
    if flag_find_class == 0
       
%         simple_sample_t
%          i
     class=class+1;
     flag_find_class = 1;
     
%      pause
    end
    
        for j=1:size_sample_t(1)

            if sample_t( j , M ) == i
                
                i_s = i_s + 1;
                flag_find_class = 0;
                simple_sample_t( i_s , M+300 ) = class;
                
                
%                 t(1)=simple_sample_t(j,M)
%                 i
%                 class
%                 v(1,:)=simple_sample_t( i_s , : )
%                 pause
                
                
                simple_sample_t( i_s , 1:t) = sample_t( j , 1:t );


            end

        end
%         simple_sample_t
%           size_sample_t 
%          i
%      class
%      pause
    
end
% sample_t=[];

sample_t( : , 1:t) = simple_sample_t( : , 1:t );
sample_t(:,M)=simple_sample_t(:,M+300);




