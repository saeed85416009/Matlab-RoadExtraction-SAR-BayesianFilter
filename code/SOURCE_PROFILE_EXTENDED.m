%%%------------------------------- create source profile----------------------------------------------------------------------------------%%%%%%%%%%%
%%% its very professional program... this program automaticaly find refrence profile from near input point that profile select between 10  
%%% pixel's gray level that most repeatet than round pixel 
%%% input :
%%% ROW_OPTIMUM & COLOUMN_OPTIMUM : cordinate of input point in first situation
%%% ANGLE : angle of road that we assumed in first situation ( if angle in quarter 1 or 2 we assume up of point 'be onvane' road class and 
%%% if angle in quarter 3 or 4 we assume down of point 'be onvane' road class ) 
%%% W : wide of road in first situation
%%% MAX_PROF :  maximum value for gray level road that we want classify (
%%% mazrabe 10)
%%% MAX_CLASYFY_SEARCH : number of search for classifying
%%% MAX_WIDE_PROFILE : maximum element of profile
%%% DIFF_PROF : diffresntial between 2 pixel for join in 1 class (
%%% pishfarz 10 )
%%% SIZE_PROFILE :   number of profile ( 3,5,7,9,...)
%%%
%%% output :
%%% final_source_profile : original profile after create profile element
%%% and choose optimal value between SOURCE_PROFILE according to lenght of
%%% SIZE_PROFILE
%%% SOURCE_PROF : all of found pixel of class ( gray level value )
%%%--------------------------------------------------------------------------------------------------------------------------------------------------%%%%%%%%%


function[ final_source_profile , SOURCE_PROF ] = SOURCE_PROFILE_EXTENDED(ROW_OPTIMUM , COLOUMN_OPTIMUM , ANGLE , W  , MAX_PROF , MAX_CLASYFY_SEARCH , MAX_WIDE_PROFILE , DIFF_PROF , SIZE_PROFILE , SOURCE_PROFILE_OLD)

global x
seed = x;

[M , N ] =size(x)

%% create seed for earn profile
wide_SOURCE_PROFILE = W;
SOURCE_PROF =[];
final_source_profile=[];
flag_find_profile = 0;
find_point =[];
while(flag_find_profile==0)

for k = 10 : 10 : MAX_PROF
for i= 1:M
    for j=1:N
      
        if (x(i,j) <=k) && ( x(i,j) > k - 10 )
        seed(i,j) = k;
        end
        
        end
    end
end

for i= 1:M
    for j=1:N
        if seed(i,j) > MAX_PROF
            seed(i,j) = 255;
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

if ((ANGLE > 0 ) && (ANGLE < 180 ) ) || ((ANGLE > -360 ) && (ANGLE < -180 ) )  %%% choose moving up or down for earn class of road
    up_down = 1;
else
    up_down = -1;
end

r_prof = ROW_OPTIMUM
c_prof = COLOUMN_OPTIMUM
prof_count = 1;


    R_prof =0;
    R_prof(1,1) = seed(r_prof,c_prof );
    r_4 = r_prof;
    c_4 = c_prof;
    i=1;
    %%
    while(abs( R_prof (1,i) - seed(ROW_OPTIMUM,COLOUMN_OPTIMUM )) <= DIFF_PROF ) && ( i < wide_SOURCE_PROFILE ) && ( prof_count <MAX_WIDE_PROFILE)
      

            if x(r_prof,c_4 ) < MAX_PROF
            SOURCE_PROF(1,prof_count) = x(r_prof , c_4 );
            end
            
             i = i + 1;
             c_4 = c_4 + 1;
             prof_count = prof_count + 1; 
             
             R_prof(1,i) = seed(r_prof , c_4 );
             
        

                    if ( round(r_4) > M ) || ( round(r_4) == 0 ) || ( round(c_4) > N ) || ( round(c_4) == 0 )   %% [M,N] = size(x)
                       break;
                   end 
                   
                   j=1;
                   C_prof =0;
                   C_prof(1,1) = seed(r_prof,c_4 );
                   while(abs( C_prof (1,j) - seed(ROW_OPTIMUM,COLOUMN_OPTIMUM )) <= DIFF_PROF ) && ( j< wide_SOURCE_PROFILE )
                       
                             if x(r_4,c_4 ) < MAX_PROF
                             SOURCE_PROF(1,prof_count) = x(r_4 , c_4 );
                             end
                             
                             j= j + 1;
                             r_4 = r_4 + (up_down);
                             prof_count = prof_count + 1 ;
                             
                             if ( round(r_4) > M ) || ( round(r_4) == 0 ) || ( round(c_4) > N ) || ( round(c_4) == 0 )   %% [M,N] = size(x)
                                   break;
                               end

                             C_prof(1,j) = seed(r_4 , c_4 );
                             
                               
                               
                   end
                       

                          
      
    end

  %%

    R_prof =0;
    R_prof(1,1) = seed(r_prof,c_prof );
    r_4 = r_prof;
    c_4 = c_prof;
    i=1;
    
    while(abs( R_prof (1,i) - seed(ROW_OPTIMUM,COLOUMN_OPTIMUM )) <= DIFF_PROF ) && ( i < wide_SOURCE_PROFILE ) &&  ( prof_count <MAX_WIDE_PROFILE)
      

            if x(r_prof,c_4 ) < MAX_PROF
            SOURCE_PROF(1,prof_count) = x(r_prof , c_4 );
            end
            
             i = i + 1;
             c_4 = c_4 - 1;
             prof_count = prof_count + 1 ;
             
             R_prof(1,i) = seed(r_prof , c_4 );
             
        

                   if ( r_prof > M-2 ) || ( r_prof == 2 ) || ( c_4 > N-2 ) || ( c_4 == 2 )   %% [M,N] = size(x)
                       break;
                   end 
                   
                   j=1;
                   C_prof =0;
                   C_prof(1,1) = seed(r_prof,c_4 );
                   while(abs( C_prof (1,j) - seed(ROW_OPTIMUM,COLOUMN_OPTIMUM )) <= DIFF_PROF ) && ( j< wide_SOURCE_PROFILE )
                       
                             if x(r_4,c_4 ) < MAX_PROF
                             SOURCE_PROF(1,prof_count) = x(r_4 , c_4 );
                             size_f = size(find_point)
                             add = size_f(1)+1;
                             find_point(add,1)=r_4;
                             find_point(add,2)=c_4;
                             end
                             
                             j= j + 1;
                             r_4 = r_4 +  (up_down);
                             prof_count = prof_count + 1 ;
                             
                             if ( round(r_4) > M ) || ( round(r_4) == 0 ) || ( round(c_4) > N ) || ( round(c_4) == 0 )   %% [M,N] = size(x)
                                   break;
                               end

                             C_prof(1,j) = seed(r_4 , c_4 );
                             
                               
                               
                   end
        
      
    end
    
   if numel( SOURCE_PROF) == 0
           SOURCE_PROF  = SOURCE_PROFILE_OLD;
           final_source_profile = SOURCE_PROFILE_OLD;
           flag_find_profile = 1;
           break
   end
    SOURCE_PROF = round(SOURCE_PROF); 
    %%  create original source profile 
    %%% profile segment beetween 10 gray level and profile choise beetween
    %%% them if have maximum elemnt
    
    value = zeros( 1, MAX_PROF);
    
    for i=10:10:MAX_PROF
        
        count = 0;
        
        for k = 1: numel(SOURCE_PROF)
            
            if (SOURCE_PROF(k) <= i ) && ( SOURCE_PROF(k) > i - 10 )
                
                count = count + 1 ;
            end
        end
        
        value(i) = count;
        
    end
    
    [ size_max_prof , max_prof ] = max(value);
    
    k=0;
    for i = 1 : numel(SOURCE_PROF)
        
        if (SOURCE_PROF(i) <=  max_prof) && ( SOURCE_PROF(i) > max_prof - 10)
            
            k = k+1;
            prof(k) = SOURCE_PROF(i);
            
        end
    end
    
    %% regulation original profile according to preference
    %%% regulation profile according to number of repeat element of profile
    %%% matrix
    
    unique_prof = unique(prof);
    A = histc(prof , unique_prof);
    k=0;
    
    while( max(A) ~= 0 )
        
        k= k+1;
        [maximum , max_element ] = max(A);
        profile_equ(1,k) = unique_prof(max_element);
        profile_equ(2,k) = maximum;
        
        A(max_element) = 0;
        
    end
    
    %% creat source profile in different state
    
    final_source_profile = 0;
    
    u_size = numel(unique_prof);
    
    if u_size < SIZE_PROFILE
        
        d=1;
        k = SIZE_PROFILE - u_size;
        final_source_profile = unique_prof;
        
        while ( k ~= 0 )
            
            for i=1:u_size
                
                t=profile_equ(2,i);
                
                for j = 1:t
                    
                    final_source_profile( u_size + d) = profile_equ(1,i);
                    d=d+1;
                    k=k-1;
                    
                    if k == 0
                        break
                    end
                    
                end
                
                if k == 0
                        break
                end
                    
            end
        end
        
    elseif u_size == SIZE_PROFILE
        
        final_source_profile = unique_prof;
        
    elseif u_size > SIZE_PROFILE
        
        for i = 1: SIZE_PROFILE
            
            final_source_profile(i) = profile_equ(1,i);
        
        end
    end
%     SOURCE_PROF
%     IMSHOW_IMAGE_KALMAN(find_point , 1 , 2 , 6)
%     pause
    flag_find_profile = 1;
end
        
            
            
        
        
        
    
    
        
            
            
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
%%



             