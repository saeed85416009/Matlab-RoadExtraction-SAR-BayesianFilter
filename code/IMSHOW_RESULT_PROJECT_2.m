function IMSHOW_RESULT_PROJECT_2( IMAGE , M , N , F ,G , H )

global  max_margin 
global add_particle_to_kalman

size_a = size(add_particle_to_kalman);
remove=[];
size_r = size(IMAGE);
result = IMAGE;
result(size_r+1 : size_r +size_a , : ) = add_particle_to_kalman;

% size_result = size(result);
% add=0;
% for i = 1:size_result(1)
%     for j = 1:4
%         if result(i,j) == 0
%             add=add+1;
%             remove(add)=i;
%             break;
%         end
%     end
% end
% 
%  if numel(remove) >0
% result(remove,:) =[];
%  end

IMSHOW_IMAGE_KALMAN_ostad_2(IMAGE , M , N , F)
IMSHOW_RESULT_PROJECT_2(add_particle_to_kalman , M , N , G)
IMSHOW_RESULT_PROJECT_2(result , M , N , H)







