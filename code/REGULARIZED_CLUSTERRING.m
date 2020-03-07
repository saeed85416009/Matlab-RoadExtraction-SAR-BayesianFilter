function REGULARIZED_CLUSTERRING()

global clusterring



size_clusterring = size(clusterring);
k=size_clusterring(1);
class_number_old = max(clusterring(:,13));
class=0;
flag_find_class = 0;
simple_sample_t=clusterring;
i_s=0;

for i = 0 : class_number_old
    
    if flag_find_class == 0
     class=class+1;
     flag_find_class = 1;
    end
    
        for j=1:k

            if clusterring( j , 13 ) == i
                
                i_s = i_s + 1;
                flag_find_class = 0;
                simple_sample_t( i_s , 13 ) = class;
                simple_sample_t( i_s , 1:12 ) = clusterring( j , 1:12 );
                simple_sample_t( i_s , 14 ) = clusterring( j , 14 );


            end

        end
%         class
%     clusterring
%     pause
end
clusterring=[];
clusterring=simple_sample_t;



