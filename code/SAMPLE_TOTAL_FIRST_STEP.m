function SAMPLE_TOTAL_FIRST_STEP(   )

global clusterring
global sample_t


size_cluster = size(clusterring);
weight = 1/size_cluster(1);

for i=1:size_cluster(1)
    
    %%% class number
    sample_t( i , 1 ) = clusterring( i , 1 );
    
    %%% sample
    sample_t( i , 2 ) = clusterring( i , 2 );
    sample_t( i , 3 ) = clusterring( i , 3 );
    sample_t( i , 4 ) = clusterring( i , 4 );
    sample_t( i , 5 ) = clusterring( i , 5 );
    
    %%% weight
    sample_t( i , 6 ) = weight;
    
    %%% measurement
    sample_t( i , 7 ) = clusterring( i , 2 );
    sample_t( i , 8) = clusterring( i , 3 );
    sample_t( i , 9 ) = clusterring( i , 4 );
    
    %%% average angle
    sample_t(i , 16) = clusterring(i , 7); 

end


class=max(sample_t(:,1));
b=1;
for i=1:class
    
   
    for j=1:size_cluster(1)
   
        if (sample_t(j,1) ==i)
            
            sample_t(j,10) = sample_t(b,2);
            sample_t(j,11) = sample_t(b,3);
            sample_t(j,12) = sample_t(b,4);
            L=j;
        end
    end
    
    b=L+1;
end
            
%%% average angle
    sample_t(: , 16) = sample_t(: , 12)*180/pi;             
            




