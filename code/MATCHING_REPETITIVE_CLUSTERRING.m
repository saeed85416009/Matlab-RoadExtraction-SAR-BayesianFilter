
function M_SAMPLE =  MATCHING_REPETITIVE_CLUSTERRING ( SAMPLE , CLASS )

s_i = 0;
M_SAMPLE = [];

size_sample = size(SAMPLE);

for j = 1 : size_sample(1)
    
    if SAMPLE(j,1) == CLASS 
        
        s_i = s_i + 1;
        M_SAMPLE(s_i , 1 ) = SAMPLE ( j , 1 );
         M_SAMPLE(s_i , 2 ) = SAMPLE ( j , 2 );
          M_SAMPLE(s_i , 3 ) = SAMPLE ( j , 3 );
           M_SAMPLE(s_i , 4 ) = SAMPLE ( j , 4 );
            M_SAMPLE(s_i , 5 ) = SAMPLE ( j , 5 );
             M_SAMPLE(s_i , 6 ) = SAMPLE ( j , 6 );
              M_SAMPLE(s_i , 7 ) = SAMPLE ( j , 7 );
               M_SAMPLE(s_i , 8 ) = SAMPLE ( j , 8 );
                M_SAMPLE(s_i , 9 ) = SAMPLE ( j , 9 );
                 M_SAMPLE(s_i , 10 ) = SAMPLE ( j , 10 );
                  M_SAMPLE(s_i , 11 ) = SAMPLE ( j , 11 );
                   M_SAMPLE(s_i , 12 ) = SAMPLE ( j , 12 );
             
    end
    
end