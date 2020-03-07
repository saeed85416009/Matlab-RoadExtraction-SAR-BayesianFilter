function SOURCE_PROF = SOURCE_PROFILE(ROW_OPTIMUM , COLOUMN_OPTIMUM , ANGLE , W , Dt , MAX_PROF , MAX_CLASYFY_SEARCH , MAX_WIDE_PROFILE)

global x
seed = x;

[M , N ] =size(x)

%% create seed for earn profile
wide_SOURCE_PROFILE = W;

for k = 10 : 10 : MAX_PROF
for i= 1:M
    for j=1:N
      
        if (x(i,j) <=k) && ( x(i,j) > k - 10 )
        seed(i,j) = k;
        end
        
        end
    end
end

m_search =0;
flag_seed = 0;
while ( m_search < MAX_CLASYFY_SEARCH )
    flag_seed = 0;
    for i=2:M-2
        for j=2:N-2
            if seed(i,j) <=70
           if  (abs(seed(i,j) - seed(i+1,j-1) ) <= 10) &&  ( seed( i+1 , j-1 ) <= 100 )
               flag_seed = flag_seed + 1;
               seed(i,j)  = seed(i+1,j-1);
            elseif (abs(seed(i,j) - seed(i,j-1) ) <= 10) &&  ( seed( i , j-1 ) <= 100 ) 
             flag_seed = flag_seed + 1;
             seed(i,j)  = seed(i,j-1);
           elseif (abs(seed(i,j) - seed(i+1,j) ) <= 10) &&  ( seed( i+1 , j ) <= 100 ) 
             flag_seed = flag_seed + 1;
             seed(i,j)  = seed(i+1,j);
           elseif (abs(seed(i,j) - seed(i+1,j+1) ) <= 10) &&  ( seed( i+1 , j+1 ) <= 100 ) 
             flag_seed = flag_seed + 1;
             seed(i,j)  = seed(i+1,j+1);
           elseif (abs(seed(i,j) - seed(i,j+1) ) <= 10) &&  ( seed( i , j+1 ) <= 100 ) 
             flag_seed = flag_seed + 1;
             seed(i,j)  = seed(i,j+1);
             elseif (abs(seed(i,j) - seed(i+1,j) ) <= 10) &&  ( seed( i+1 , j ) <= 100 ) 
             flag_seed = flag_seed + 1;
             seed(i,j)  = seed(i+1,j);
             elseif (abs(seed(i,j) - seed(i-1,j-1) ) <= 10) &&  ( seed( i-1 , j-1 ) <= 100 ) 
             flag_seed = flag_seed + 1;
             seed(i,j)  = seed(i-1,j-1);
             elseif (abs(seed(i,j) - seed(i-1,j+1) ) <= 10) &&  ( seed( i-1 , j+1 ) <= 100 ) 
             flag_seed = flag_seed + 1;
             seed(i,j)  = seed(i-1,j+1);
             elseif (abs(seed(i,j) - seed(i-1,j) ) <= 10) &&  ( seed( i-1 , j ) <= 100 ) 
             flag_seed = flag_seed + 1;
             seed(i,j)  = seed(i-1,j);
           end
            end
        end
    end
    m_search = m_search +1
end

%%

r_prof = ROW_OPTIMUM
c_prof = COLOUMN_OPTIMUM
prof_count = 1;


while(abs(seed(r_prof,c_prof ) - seed(ROW_OPTIMUM,COLOUMN_OPTIMUM ))<= 0 )&& ( prof_count <MAX_WIDE_PROFILE)
    flag_wide_SOURCE_PROFILE=1;
    R_prof =0;
    R_prof(1,1) = seed(r_prof,c_prof );
    r_4 = r_prof;
    c_4 = c_prof;
    i=1;
    %%
    while(abs( R_prof (1,i) - seed(ROW_OPTIMUM,COLOUMN_OPTIMUM )) <= 0 ) && ( i < wide_SOURCE_PROFILE )
      

            
            SOURCE_PROF(1,prof_count) = x(r_prof , c_4 );
            
             i = i + 1;
             c_4 = c_4 + 1;
             prof_count = prof_count + 1 ;
             
             R_prof(1,i) = seed(r_prof , c_4 );
             
        

                   if ( r_prof > M-2 ) || ( r_prof == 2 ) || ( c_4 > N-2 ) || ( c_4 == 2 )   %% [M,N] = size(x)
                       break;
                   end 
        
      
    end
  %%
    R_prof =0;
    R_prof(1,1) = seed(r_prof,c_prof );
    r_4 = r_prof;
    c_4 = c_prof;
    i=1;
    
    while(abs( R_prof (1,i) - seed(ROW_OPTIMUM,COLOUMN_OPTIMUM )) <= 0 ) && ( i < wide_SOURCE_PROFILE )
      

            
            SOURCE_PROF(1,prof_count) = x(r_prof , c_4 );
            
             i = i + 1;
             c_4 = c_4 - 1;
             prof_count = prof_count + 1 ;
             
             R_prof(1,i) = seed(r_prof , c_4 );
             
        

                   if ( r_prof > M-2 ) || ( r_prof == 2 ) || ( c_4 > N-2 ) || ( c_4 == 2 )   %% [M,N] = size(x)
                       break;
                   end 
        
      
    end
  
    %%
        row_prof = round( r_prof - Dt * sind ( ANGLE ))    
        column_prof = round( c_prof + Dt * cosd ( ANGLE ))
        
        if (abs(seed(r_prof,c_prof ) - seed(ROW_OPTIMUM,COLOUMN_OPTIMUM ))<= 0 )
            
       u=0; 
       i=1;
       R_wide_prof = 0;
       R_wide_prof(1,1) =  seed(r_prof,c_prof )  ;     
              
    while(abs( R_wide_prof (1,i) - seed(ROW_OPTIMUM,COLOUMN_OPTIMUM )) <= 0 )
        i = i + 1;
        u=u+1;
        r_4 = round ( r_prof + u *sind (90-ANGLE ));    %  check shode dorosre
        c_4 = round ( c_prof + u *cosd ( 90-ANGLE ));
       
       if ( r_4 > M-2 ) || ( r_4 == 2 ) || ( c_4 > N-2 ) || ( c_4 == 2 )   %% [M,N] = size(x)
           break;
       end 
       
       R_wide_prof(1,i) = seed(r_4 , c_4 );
       T = i ;
       
       if (T>wide_SOURCE_PROFILE)
           T=1000;
           flag_wide_SOURCE_PROFILE = 0;
           break
       end

       
      
end

if T ~= 1000
T = sqrt ( ( r_4 - r_prof )^2 + ( c_4 - c_prof)^2 );    %%% measurement T
end
    
       u=0; 
       i=1;
       R_wide_prof = 0;
       R_wide_prof(1,1) =  seed(r_prof,c_prof )  ;  
      
while(abs( R_wide_prof (1,i) - seed(ROW_OPTIMUM,COLOUMN_OPTIMUM )) <= 0 )
        i = i + 1;
        u=u+1;
        r_4 = round ( r_prof - u *sind (90-ANGLE ));    %  check shode dorosre
        c_4 = round ( c_prof - u *cosd ( 90-ANGLE ));
       
       if ( r_4 > M-2 ) || ( r_4 == 2 ) || ( c_4 > N-2 ) || ( c_4 == 2 )   %% [M,N] = size(x)
           break;
       end 
       
       R_wide_prof(1,i) = seed(r_4 , c_4 );
       G = i ;
       
       if (G>wide_SOURCE_PROFILE)
           G=1000;
           flag_wide_SOURCE_PROFILE = 0;
           break
       end

       
      
end
    
if G ~= 100
G = sqrt ( ( r_4 - r_prof )^2 + ( c_4 - c_prof)^2 );    %%% measurement T
end
    

%%
                if            flag_wide_SOURCE_PROFILE ~= 0

                if G >= T
                    u=abs(T-G);
                    r_prof = round ( row_prof - u *sind (90-ANGLE ))    %  check shode dorosre
                    c_prof = round ( column_prof - u *cosd ( 90-ANGLE ))
                else
                    r_prof = round ( row_prof + u *sind (90-ANGLE ))    %  check shode dorosre
                    c_prof = round ( column_prof + u *cosd ( 90-ANGLE ))
                end

                end
                        
        end
        
end









    
    
    
%%
for i= 1:M
    for j=1:N
        if seed(i,j) > MAX_PROF
            seed(i,j) = 255;
        end
    end
end


             