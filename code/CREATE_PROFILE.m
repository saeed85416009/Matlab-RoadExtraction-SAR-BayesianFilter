function [ PROFILE_1, PROFILE_2, PROFILE_3 , PROFILE_4 ] = CREATE_PROFILE ( PROFILE , SIZE_PROF )


 PROFILE_1 = PROFILE;
 
 if ( PROFILE - 10 > 0 )
 PROFILE_2 = PROFILE -10;
 else
     PROFILE_2 = zeros(1,SIZE_PROF);
 end

 if ( PROFILE - 20 > 0 )
 PROFILE_3 = PROFILE -20;
  else
     PROFILE_3 = zeros(1,SIZE_PROF);
 end
 
 if ( PROFILE -30 >0 )
 PROFILE_4 = PROFILE - 30;
  else
     PROFILE_4 = zeros(1,SIZE_PROF);
 end
 
 