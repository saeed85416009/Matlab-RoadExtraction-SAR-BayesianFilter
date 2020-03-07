function [min_row , max_row , min_coloumn , max_coloumn ] = MIN_MAX_UNACCEPTED_SAMPLE( SAMPLE )

size_sample = size(SAMPLE);
s_s = size_sample(1);

add=0;
for i = 1: s_s
    
    add = add + 1;
    row(add) = SAMPLE(i,2);
    coloumn(add) = SAMPLE(i,3);
    
end
    
min_row = min(row);
max_row = max(row);

min_coloumn = min(coloumn);
max_coloumn = max(coloumn);

% for i =  min_row : max_row
%     for j = min_coloumn : max_coloumn
%         
%         Unaccepted_Sample 













