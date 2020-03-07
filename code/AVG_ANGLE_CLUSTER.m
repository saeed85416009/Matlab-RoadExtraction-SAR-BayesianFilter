function AVG_ANGLE_CLUSTER ()
global clusterring
global class_number

size_cluster = size(clusterring);

for j = 1:class_number
    
    k = 0;
    sum = 0;
    
    for i=1:size_cluster(1)
        
        if ( clusterring(i,1) == j )
            
            sum = sum+clusterring(i,6);
            k=k+1;
            
        end
    end
    
    avg = sum/k;
    
    for i=1:size_cluster(1)
       
        if ( clusterring(i,1) == j )
        
            clusterring(i,7) = avg;
        end
    end
    
end
            
    
    
    
    
    