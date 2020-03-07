%%% ------------find car in earn profile and if found car change profile ---------------------%%%%%%%%%%%%%%
%%% input : 
%%% PROFILE : earn profile in measurment process
%%% GRAY_CAR : gray level of earned profile that more than of this maybe exist car
%%% SOURCE_PROFILE : source profile
%%% NUMBER_PIXEL_CAR :  profile pixel number that profile gray level of them is more than of GRAY_CAR 
%%% DIS_FROM_FST : distance car from first of profile
%%% DIS_FROM_END :  distance car from end of profile
%%% MAX_GRAY_PROF_CAR : maximum gray level of pofile in new position
%%%
%%% output :
%%% new earned profile
%%%----------------------------------------------------------------------------------------------------------%%%%%%%%%%%



function CAR_PROFILE = CAR( PROFILE ,GRAY_CAR , SOURCE_PROFILE , NUMBER_PIXEL_CAR , DIS_FROM_FST , DIS_FROM_END , MAX_GRAY_PROF_CAR )

        [ row_car , column_car ] = find( PROFILE >GRAY_CAR );
        
        i = numel(column_car);

        if (numel(column_car) <=  NUMBER_PIXEL_CAR) && ( i ~= 0 )
            PROFILE_car = PROFILE;
            while(i)
                if (column_car(i) >= DIS_FROM_FST ) && ( column_car(i) <= DIS_FROM_END )
                    PROFILE_car(1,column_car(i) ) = mean(SOURCE_PROFILE);
                end
                i=i-1;
            end
            
            if PROFILE_car < MAX_GRAY_PROF_CAR
                CAR_PROFILE = PROFILE_car
                note=' there is exist car '
            else
                CAR_PROFILE = PROFILE;
            end
        else
                CAR_PROFILE = PROFILE;
        end