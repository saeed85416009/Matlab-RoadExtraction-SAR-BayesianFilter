function   SAMPLE_FOR_CLUSTER = CREATE_SAMPLE_FOR_CLUSTERRING ()

global sample_t

 s_s = size(sample_t);
 ss_c=0;
 SAMPLE_FOR_CLUSTER=[];
 
 for ss = 1:s_s(1)
     
     if sample_t(ss,2) ~= 0
        ss_c = ss_c+1; 
        
        %%% class number
        SAMPLE_FOR_CLUSTER (ss_c , 1 ) = sample_t(ss,1);
        
        %%% sample
        SAMPLE_FOR_CLUSTER (ss_c , 2 ) = sample_t(ss,2);
        SAMPLE_FOR_CLUSTER (ss_c , 3 ) = sample_t(ss,3);
        SAMPLE_FOR_CLUSTER (ss_c , 4 ) = sample_t(ss,4);
        SAMPLE_FOR_CLUSTER (ss_c , 5 ) = sample_t(ss,5);
        
        %%% weight
        SAMPLE_FOR_CLUSTER (ss_c , 6 ) = sample_t(ss,6);
        
        %%% measurement
        SAMPLE_FOR_CLUSTER (ss_c , 7 ) = sample_t(ss,7);
        SAMPLE_FOR_CLUSTER (ss_c , 8 ) = sample_t(ss,8);
        SAMPLE_FOR_CLUSTER (ss_c , 9 ) = sample_t(ss,9);
        
        %%%  source point
        SAMPLE_FOR_CLUSTER (ss_c , 10 ) = sample_t(ss,10);
        SAMPLE_FOR_CLUSTER (ss_c , 11 ) = sample_t(ss,11);
        SAMPLE_FOR_CLUSTER (ss_c , 12 ) = sample_t(ss,12);
        
        
     end
     
 end
 
 
 