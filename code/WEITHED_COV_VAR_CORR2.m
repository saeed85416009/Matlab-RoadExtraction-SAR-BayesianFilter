


function [ WCOV , WVAR_X , WVAR_Y , WCORR2 ] = WEITHED_COV_VAR_CORR2 (MATRIX_X , MATRIX_Y , WEIGHT)

[ M , N ] = size (MATRIX_X);
sum_x = 0;
sum_y = 0 ;
sum_cov=0;
sum_weight=0;

%%% sigma ( weight )
for i = 1 : M
    for j= 1 : N
       sum_weight = sum_weight + WEIGHT(i,j);
    end
end

%%% mean of weighted matrix 
matrix_x = WEIGHT .* MATRIX_X;

for i= 1:M
    for j=1:N
       sum_x = sum_x + matrix_x(i,j);
    end
end
        
m_x= sum_x / sum_weight;  %% mean o matrix_x

matrix_y = WEIGHT .* MATRIX_Y;

for i= 1:M
    for j=1:N
       sum_y = sum_y + matrix_y(i,j);
    end
end
        
m_y= sum_y / sum_weight;  %% mean o matrix_y




%%% weighted covarience
for i = 1:M
    for j= 1:N
        
        pri_cov =WEIGHT(i,j) * ( (MATRIX_X(i,j) - m_x) * ( MATRIX_Y(i,j) - m_y ) );
        sum_cov = sum_cov + pri_cov;
    end
end

WCOV = sum_cov /  sum_weight;

%%% weighted variance
 sum_var=0;
for i = 1:M
    for j= 1:N
        
        pri_var =WEIGHT(i,j) * ( (MATRIX_X(i,j) - m_x) * ( MATRIX_X(i,j) - m_x ) );
        sum_var = sum_var + pri_var;
    end
end   

WVAR_X = sum_var / sum_weight ;


sum_var=0;
for i = 1:M
    for j= 1:N
        
        pri_var =WEIGHT(i,j) * ( (MATRIX_Y(i,j) - m_y) * ( MATRIX_Y(i,j) - m_y ) );
        sum_var = sum_var + pri_var;
    end
end   

WVAR_Y = sum_var / sum_weight ;
%%%weigted correlation coefficient
WCORR2 = WCOV / sqrt( WVAR_X * WVAR_Y);









