function  CREATE_FIRST_SOURCE_POINT_2()

global sample_t
global x_total



x_total =[];


x_total (1 , 1 ) = sample_t ( 1 , 7 );
x_total (1 , 2 ) = sample_t ( 1 , 8 );
x_total (1 , 3 ) = sample_t ( 1 , 4 );



s_s = size(sample_t);
s=1;
for i = 2 : s_s(1)
    
    if ( sample_t ( i-1 , 1 ) ~= sample_t ( i , 1 ) )
        
        s=s+1;
        x_total (s , 1 ) = sample_t ( i , 7 );
        x_total (s , 2 ) = sample_t ( i , 8 );
        x_total (s , 3 ) = sample_t ( i , 9 );
        
        
        
    end
    
end

x_total ( : , 4 ) = 0;



        
        
    