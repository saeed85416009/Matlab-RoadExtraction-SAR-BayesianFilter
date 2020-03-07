function  canny_edge = EDGE_FND_CANNY ( IMAGE )
 
 [ M,N] = size(IMAGE);

 
BW = edge(IMAGE,'canny');

for i = 1:M
    for j = 1:N
        if BW(i,j) == 1
            bw(i,j) = 255;
        end
    end
end
canny_edge = bw;