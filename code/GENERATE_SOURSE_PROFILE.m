function  [ FINAL_SOURCE_PROFILE , LEVEL , SOURCE_PROFILE ] = GENERATE_SOURSE_PROFILE( ROW_P , COLOUMN_P , ANGLE_P ,WIDE_P, FINAL_SOURCE_PROFILE_OLD , LEVEL_OLD )

global flag_big_wide
global flag_little_wide
global little_wide
global big_wide

seed = [];
[level , seed_total ] = FIND_MAX_GRAY_AND_SEED( ROW_P , COLOUMN_P , ANGLE_P ,WIDE_P , LEVEL_OLD );

LEVEL =level;
seed_first = seed_total(:,1);
size_seed = size(seed_first);

if numel(seed_first) > 1
flag_little_wide =1;
flag_big_wide = 1;
while(flag_little_wide == 1 )
% 
%             if (WIDE_P <=little_wide)
%                 flag_little_wide = 0;
%                 FINAL_SOURCE_PROFILE = FINAL_SOURCE_PROFILE_OLD;
%                 SOURCE_PROFILE = seed_first;
%                 break
% 
%             elseif (WIDE_P >little_wide) && (WIDE_P <=15)
%                 flag_bad_wide = 1;
%                 size_profile = 3;
% 
%             elseif (WIDE_P >15) &&( WIDE_P <= big_wide)
%                 flag_bad_wide = 1;
%                 size_profile = 3;
%             else 
%                 flag_big_wide = 0;
%                 FINAL_SOURCE_PROFILE = FINAL_SOURCE_PROFILE_OLD;
%                 SOURCE_PROFILE = seed_first;
%                 break

%             end

 size_profile = 3;
add=0;
for i =1:size_seed(1)
    if seed_first(i) < level
        
        add=add+1;
        seed(add) = seed_first(i);
        
    end
end

if numel (seed) ~=0

    [ FINAL_SOURCE_PROFILE , SOURCE_PROFILE ] = SOURCE_PROFILE_EXTENDED_2( level , size_profile , seed ,FINAL_SOURCE_PROFILE_OLD );
else
                FINAL_SOURCE_PROFILE = FINAL_SOURCE_PROFILE_OLD
                SOURCE_PROFILE = 0;
                pause
                ROW_P
                 COLOUMN_P 
                 ANGLE_P 
                 WIDE_P
                note ='  numel (seed) = 0 in generate source'
                pause
               
end
break;
end
else
                FINAL_SOURCE_PROFILE = FINAL_SOURCE_PROFILE_OLD;
                SOURCE_PROFILE = 0;
               note ='  numel(seed_first) = 1 in generate source'
               pause
end



