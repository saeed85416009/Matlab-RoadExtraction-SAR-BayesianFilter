%%%------------------ detect point is out of road ---------------------------------------------------------------%%%%%%%%%%%%%%%
%%% 
%%% if number of bad guss profile road more than of threshould we detect point is out of road
%%% input :
%%% AA : condidate road profile 
%%% THRESHOULD_PIXEL_OUT_ROAD : maximmum pixel that profile can put out of road 
%%% MAXIMUM_PROFILE : maximmum value of road profile 
%%%
%%% output :
%%% ERROR : error in bad or good position according to function situation
%%%---------------------------------------------------------------------------------------------------------------------%%%%%%%%%%%%%%


function [ ERROR ] = OUT_ROAD ( AA , THRESHOULD_PIXEL_OUT_ROAD , ERROR_IN , MAXIMUM_PROFILE)
ERROR = ERROR_IN;
k=numel(AA);
i=0;
u=0;
while ( k )
    i=i+1;
 
    if AA(i) > MAXIMUM_PROFILE
        u=u+1;
    end
    k=k-1;
end
if u > THRESHOULD_PIXEL_OUT_ROAD
    ERROR = 100000;
    note = ' point out of road '
end