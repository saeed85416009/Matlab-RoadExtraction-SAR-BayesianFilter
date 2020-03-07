function SAMPLE = MERGE_SAMPLE_NEW_1(SAMPLE , TH_ANGLE_MERGE_CLUSTER , ANGLE_TOTAL)

m = ANGLE_TOTAL;

size_cluster = size(SAMPLE);
k=1;

for i=1:size_cluster(1)
    for j = 1:size_cluster(1)
        
                difference =  abs( SAMPLE(i,m) - SAMPLE(j,m) );
                if difference > 180
                    difference = 360 - difference ;
                end
                

                if ( difference < TH_ANGLE_MERGE_CLUSTER )

            SAMPLE( j , 1 ) =SAMPLE( i , 1 );
        end
    end
end



