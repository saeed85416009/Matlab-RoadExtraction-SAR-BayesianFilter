function MERGE_CLUSTER(TH_ANGLE_MERGE_CLUSTER)

global clusterring

size_cluster = size(clusterring);
k=1;

for i=2:size_cluster(1)
    
                difference =  abs( clusterring(i,7) - clusterring(i,7) );
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
end



