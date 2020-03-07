function MERGE_SAMPLE_NEW_2(TH_ANGLE_MERGE_CLUSTER)

global sample_t

% class_total = max(clusterring(:,13));
size_sample_t = size(sample_t);

for i=1:size_sample_t(1)
    for j = 1:size_sample_t(1)
    
        if sample_t(i,13) == sample_t(j,13)

                difference =  abs( sample_t(i,14) - sample_t(j,14) );
                if difference > 180
                    difference = 360 - difference ;
                end
                

                if ( difference < TH_ANGLE_MERGE_CLUSTER )

                    sample_t( j , 1 ) = sample_t( i , 1 );
                
                end
        end
    end
end



