%% ------------------------------------------ CREATE SOURCE PROFILE FOR KALMAN FILTER ------------------------------------------------%%%
%%% input :
%%%           MAX_CLASSIFY_SEARCH : maximmum search for find profile ... when choose bigger search then my total profile be bigger 
%%%           DIFF_GRAY_PROFILE : diff gray between each point of profile 
%%%           MAX_PROFILE_NUMBER : maximmum element in total profile like 100
%%%           SIZE_PROFILE : final size of extract profile that must be less than of  road wide
%% --------------------------------------------------------------------------------------------------------------------------------------------------------------------------%%%


function SOURCE_PROFILE = INITIALIZE_REFERENCE_PROFILE(MAX_GARY , MAX_CLASSIFY_SEARCH , MAX_PROFILE_NUMBER , DIFF_GRAY_PROFILE , SIZE_PROFILE)

% global p_1
global r_optimum
global c_optimum
global angle
global Wide
global max_profile

 %%%%%%%%%%% initialize reference profile%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 p_1 =[ 53 54 49  ];        %% initialize reference profile                  %%---**---%%
%  m=max(p_1);
max_profile = MAX_GARY;                       %%---**---%%    %% this point show when point out of road
%  max_clasify_search = 150;
%  max_wide_profile =200;
%  diff_profile = 10;
%  size_profile = round(3*Wide/4);
 [ SOURCE_PROFILE , pf ] = SOURCE_PROFILE_EXTENDED(round(r_optimum) , round(c_optimum) , angle , Wide  , max_profile , MAX_CLASSIFY_SEARCH , MAX_PROFILE_NUMBER , DIFF_GRAY_PROFILE , SIZE_PROFILE , p_1);


%  [ SOURCE_PROFILE , pf ] = SOURCE_PROFILE_EXTENDED(r_optimum , c_optimum , angle , Wide  , max_profile , max_clasify_search , max_wide_profile , diff_profile , size_profile);


