function UNACCEPTED_SAMPLE( MIN_ROW , MAX_ROW , MIN_COLOUMN , MAX_COLOUMN )

global unaccepted_sample

size_sample = size(unaccepted_sample);
add = size_sample(1);

for i = MIN_ROW: MAX_ROW
    for j = MIN_COLOUMN : MAX_COLOUMN
    
    add = add + 1;
    unaccepted_sample(add , 2) = i;
    unaccepted_sample(add , 3) = j;

    end
end






