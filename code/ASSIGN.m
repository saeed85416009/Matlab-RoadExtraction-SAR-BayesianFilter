function ASSIGN(  WIDE , SIGMA_FIO  )
global sample_t



R_k = SIGMA_FIO * [  0.4*WIDE 0 0 ; 0 0.4*WIDE 0 ; 0 0 100000000 ]; 
cons_weight = 1/( ((2*pi)^1.5) * (det( R_k )^0.5) );

 simple_sample_t =sample_t;
 size_sample_t=size(simple_sample_t);
 k=size_sample_t(1);
%  sample_t=[];
 n=0;
 class_number_old = max(sample_t(:,1));
 
 
 for class = 1 : class_number_old
     
     s_w=n;
     sum_weight=0;
     Z_M=[];
     X_I=[];
     s=0;
  for s_i=1:k
      
      if simple_sample_t(s_i , 1)==class
          
            s=s+1;
            Z_M(s,1) = simple_sample_t(s_i,7);
            Z_M(s,2) = simple_sample_t(s_i,8);
            Z_M(s,3) = simple_sample_t(s_i,9);

            X_I(s,1) = simple_sample_t(s_i,2);
            X_I(s,2) = simple_sample_t(s_i,3);
            X_I(s,3) = simple_sample_t(s_i,4);
            
            EXTERA(s,1) = simple_sample_t(s_i,1);
            EXTERA(s,5) = simple_sample_t(s_i,5);
            EXTERA(s,6) = simple_sample_t(s_i,6);
            EXTERA(s,10) = simple_sample_t(s_i,10);
            EXTERA(s,11) = simple_sample_t(s_i,11);
            EXTERA(s,12) = simple_sample_t(s_i,12);
            
      end
  end

size_z_m = size(Z_M);
for i=1 : size_z_m(1)
    
    j=1;
    distance=[];
    
    assign_j=1;
    min_distance = (Z_M(1,:) - X_I(i,:) ) * inv(R_k) *transpose(Z_M(1,:) - X_I(i,:) ) ;
    
        for j=2:size_z_m(1)
            
            distance(j) = (Z_M(j,:) - X_I(i,:) ) * inv(R_k) *transpose(Z_M(j,:) - X_I(i,:) ) ;
            
                if distance(j)<min_distance
                    
                    min_distance = distance(j);
                    assign_j = j;
                                     
                end
     
        end
        
        n=n+1;
    %%% assign class
    sample_t( n , 1 ) = class;
    %%% sample
    sample_t( n , 2 ) = X_I ( i , 1 );
    sample_t( n , 3 ) = X_I ( i , 2 );
    sample_t( n , 4 ) = X_I ( i , 3 );
    sample_t( n , 5 ) = EXTERA ( i , 5 );
    %%% old weight
    sample_t( n , 6 ) = EXTERA ( i , 6 );
    sample_t( n , size_sample_t(2)+1 ) = min_distance;
    %%% assign measurment
    sample_t( n , 7 ) = Z_M ( assign_j , 1 );
    sample_t( n , 8 ) = Z_M ( assign_j , 2 );
    sample_t( n , 9 ) = Z_M ( assign_j , 3 );
    sample_t( n , 10 ) = EXTERA ( assign_j , 10 );
    sample_t( n , 11 ) = EXTERA ( assign_j , 11 );
    sample_t( n , 12 ) = EXTERA ( assign_j , 12 );
    
    %% calculate weight
    
              weight_particle(n) = sample_t(n,6) * cons_weight * exp( -min_distance/2 );  
              
             
              sum_weight = sum_weight + weight_particle(n);

end

for j = s_w+1 : n %% normalize weight
     weight_particle(j) = weight_particle(j)/sum_weight;
                                                                                              if( abs(weight_particle(j)) < 0.00001)
                                                                                                  weight_particle(j) = 0;
                                                                                              end
     sample_t( j , 6 ) = weight_particle(j);
end
 


 end %% end search class



