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


function[ final_source_profile , SOURCE_PROF ] = SOURCE_PROFILE_EXTENDED_2( MAX_PROF  , SIZE_PROFILE  , INPUT_SEED ,SOURCE_PROF_OLD)

SOURCE_PROF = INPUT_SEED;
global max_gray_total

    SOURCE_PROF = round(SOURCE_PROF) ;
    %%  create original source profile 
    %%% profile segment beetween 10 gray level and profile choise beetween
    %%% them if have maximum elemnt
    if MAX_PROF <max_gray_total
       a =  MAX_PROF/10;
       a=ceil(a);
       b = a*10;
    end
    
    if b>MAX_PROF
        MAX_PROF = b;
    else
        MAX_PROF = b+10;
    end
    
    value = zeros( 1, MAX_PROF);
    
    for i=10:10:MAX_PROF
        
        count = 0;
        
        for k = 1: numel(SOURCE_PROF)
            
            if (SOURCE_PROF(k) <= i ) && ( SOURCE_PROF(k) > i - 10 )
                
                count = count + 1;

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

%     note='final_source_profile'
%         final_source_profile
%         pause
            
            
        
        
    if numel(final_source_profile)<SIZE_PROFILE
         final_source_profile   = SOURCE_PROF_OLD;
        jtdekyrxytcdlutc;iv;ikyv;iyv
         note = ' little size for source profile'
         pause
    end
    
        
            
            
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
%%



             