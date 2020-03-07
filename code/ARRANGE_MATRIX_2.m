function [X]=ARRANGE_MATRIX_2(MATRIX)

if numel(MATRIX ~= 0)
    
        A=MATRIX;
        [M , N ] = size(A);

        for i = 1:M
            for j=1:N
        [ a b ] = min(A);
        A(b) = 100000000000;
        X(i,j) = a;
            end
        end

end





