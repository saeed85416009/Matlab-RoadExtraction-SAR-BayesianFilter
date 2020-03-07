function MERGE_CLUSTER_NEW_1(TH_ANGLE_MERGE_CLUSTER)

global clusterring

size_cluster = size(clusterring);
k=1;

for i=2:size_cluster(1)
    for j = 2:size_cluster(1)
        
                difference =  abs( clusterring(i,7) - clusterring(j,7) );
                if difference > 180
                    difference = 360 - difference ;
                end
                

                if ( difference < TH_ANGLE_MERGE_CLUSTER )

            clusterring( i , 1 ) =clusterring( j , 1 );
        end
    end
end



