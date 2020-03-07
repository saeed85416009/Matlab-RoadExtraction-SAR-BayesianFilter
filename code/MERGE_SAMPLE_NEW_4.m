function MERGE_SAMPLE_NEW_4(TH_ANGLE_MERGE_CLUSTER , M )

global sample_t

% class_total = max(clusterring(:,13));
size_sample_t = size(sample_t);
simple_sample_t = sample_t;
% simple_sample_t( 1 , M ) = 1; 

for i=1:size_sample_t(1)
    for j = 1:size_sample_t(1)
    
                difference =  abs( sample_t(i,14) - sample_t(j,14) );
                if difference > 180
                    difference = 360 - difference ;
                end
                

                if ( difference < TH_ANGLE_MERGE_CLUSTER )

                    simple_sample_t( j , M ) = sample_t( i , M );
                else
%                     sample_t
%                     sample_t(i,14)
%                     sample_t(j,14)
%                     pause
                
                    
                end
       
    end
end

sample_t(:,M) = simple_sample_t(:,M);

