function MERGE_CLUSTER_2(TH_ANGLE_MERGE_CLUSTER)

global clusterring

% class_total = max(clusterring(:,13));
size_cluster = size(clusterring);
k=1;

for i=2:size_cluster(1)
    
    if clusterring(i-1,13) == clusterring(i,13)

            difference =  abs( clusterring(i,14) - clusterring(i,14) );
                if difference > 180
                    difference = 360 - difference ;
                end
                

                if ( difference < TH_ANGLE_MERGE_CLUSTER )

                clusterring( i-1 , 1 ) =k;
                clusterring( i , 1 ) = k;
            else
                k=k+1;
                clusterring( i , 1 ) = k;

            end
    else
        k=k+1;
        clusterring( i , 1 ) = k;
    end
end



