function MERGE_CLUSTER_NEW_2(TH_ANGLE_MERGE_CLUSTER)

global clusterring

% class_total = max(clusterring(:,13));
size_cluster = size(clusterring);
k=1;

for i=1:size_cluster(1)
    for j = 1:size_cluster(1)
    
        if clusterring(i,13) == clusterring(j,13)

                difference =  abs( clusterring(i,14) - clusterring(j,14) );
                if difference > 180
                    difference = 360 - difference ;
                end
                

                if ( difference < TH_ANGLE_MERGE_CLUSTER )

                    clusterring( j , 1 ) = clusterring( i , 1 );
                
                end
        end
    end
end



