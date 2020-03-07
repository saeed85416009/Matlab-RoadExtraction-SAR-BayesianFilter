function  sobel_edge = EDGE_FND_SOBEL ( IMAGE )
 
 [ M,N] = size(IMAGE);

 
BW = edge(IMAGE,'sobel');

for i = 1:M
    for j = 1:N
        if BW(i,j) == 1
            bw(i,j) = 255;
        end
    end
end
sobel_edge = bw;