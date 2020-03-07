function  MATRIX_WITHOUT_180 = REGULATE_ANGLE_180(MATRIX_WITH_180 , PLACE)

P = PLACE;
size_mat = size(MATRIX_WITH_180);
mat = MATRIX_WITH_180;
Remove =[];
add_remove =0;
for i = 1: size_mat(1)
    
    if abs( mat(i , P) ) == 180
        
        add_remove = add_remove + 1;
        Remove(add_remove) = i;
        
    end
    
    
end

mat(Remove,:)=[];

angle = median(mat(:,P));

if angle >= 0
    
    angle_180 =180;
    
elseif angle < 0
    
    angle_180 =-180;
    
end
    

for i = 1: size_mat(1)
    
    if abs( MATRIX_WITH_180(i , P) ) == 180
        
        MATRIX_WITH_180(i,P) = angle_180;
        
    end
    
    
end

MATRIX_WITHOUT_180 = MATRIX_WITH_180;







