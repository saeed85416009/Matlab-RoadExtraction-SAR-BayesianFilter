function [ SEED_POINT , FLAG_SEED_POINT ] = AUTOMATIC_FIND_SEED_POINT(TH_SEARCH_AUTOMAT , TH_ANGLE_AUTOMAT , TH_DIS_FIRST_AUTOMAT , TH_DIS_AUTOMAT          ,        MAX_WIDE_AUTOMAT , COFF_WIDE_AUTOMAT )

global x
global edge_canny
global edge_point
global L
global T
global prob_point

FLAG_SEED_POINT =1;
SEED_POINT = [];
edge_point = EDGE_FND_CANNY ( edge_canny );
level =0;

[L , T ] = size(edge_point);

for i = 1:L
    for j = 1: T
        
        if edge_point(i,j) > level
            
            edge_point(i,j) = 255;
            
        end
    end
end

% figure(1)
% imshow(uint8(edge_point))


add = 0;
for i = L - 20 : -1 : 20
    for j = 20 : T - 20
        
        if edge_point(i,j) > 0
            
            add = add+1;
            prob_point(add,1) = i;
            prob_point(add,2) = j;
            
        end
    end
end
a=[];
flag_find_road =1;
while (flag_find_road == 1)
[road_line , flag_find_line ] = STEP_ONE_AUTOMATIC_FIND_SEED_POINT_2(TH_SEARCH_AUTOMAT , TH_ANGLE_AUTOMAT , TH_DIS_FIRST_AUTOMAT , TH_DIS_AUTOMAT );

if flag_find_line == 0
   [ adjacency_road_line , adjacency_first_point , flag_find_road]= STEP_TWO_AUTOMATIC_FIND_SEED_POINT (road_line , MAX_WIDE_AUTOMAT  , COFF_WIDE_AUTOMAT , TH_DIS_AUTOMAT , TH_SEARCH_AUTOMAT ,  TH_ANGLE_AUTOMAT , TH_DIS_FIRST_AUTOMAT ,  TH_DIS_AUTOMAT);
end
end

if flag_find_road ==0
        adjacency_first_point
        road_first_point = road_line(1,:)
        ROW = (road_first_point(1) + adjacency_first_point(1) ) /2;
        COLOUMN = (road_first_point(2) + adjacency_first_point(2) ) /2;
        WIDE_INIT = sqrt( ((road_first_point(1) - adjacency_first_point(1) )^2) + ( (road_first_point(2) - adjacency_first_point(2) )^2));

        cov_angle_1 = cov(road_line(:,3))
        median(road_line(:,3))
        cov_angle_2 = cov(adjacency_road_line(:,3))
        median(adjacency_road_line(:,3))

        if cov_angle_1 <= cov_angle_2

           ANGLE = median(road_line(:,3));
        else
            ANGLE = median(adjacency_road_line(:,3));
        end



        road_line
        adjacency_road_line
        SEED_POINT = [ ROW , COLOUMN , ANGLE , WIDE_INIT ]
        FLAG_SEED_POINT=0;
end
note =' finishhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh'
pause
pause
pause
pause
pause
pause
pause


if numel (SEED_POINT) == 0
    SEED_POINT = [ 0 0 0 0]
    FLAG_SEED_POINT = 1;
end
    








