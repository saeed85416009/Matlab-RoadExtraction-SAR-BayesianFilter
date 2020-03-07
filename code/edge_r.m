I = x;
figure, imshow(I), title('original image');
text(size(I,2),size(I,1)+15, ...
    'Image courtesy of Alan Partin', ...
    'FontSize',7,'HorizontalAlignment','right');
text(size(I,2),size(I,1)+25, ....
    'Johns Hopkins University', ...
    'FontSize',7,'HorizontalAlignment','right');


[~, threshold] = edge(x, 'sobel');
fudgeFactor = .2;
BWs = edge(I,'sobel', threshold * fudgeFactor);
figure, imshow(uint8(BWs)), title('binary gradient mask');


se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);

BWsdil = imdilate(BWs, [se90 se0]);
figure, imshow(uint8(BWsdil)), title('dilated gradient mask');


BWdfill = imfill(BWsdil, 'holes');
figure, imshow(uint8(BWdfill));
title('binary image with filled holes');


