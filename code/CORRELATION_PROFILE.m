
function [ CORRELLATION ] = CORRELATION_PROFILE ( P_1 , P_2 , NP )



p_1_sigma=0;
p_2_sigma=0;
CORRELLATION=0;
sigma=0;


for i=1:NP
    sigma = sigma + P_1(i)*P_2(i);
    p_1_sigma = p_1_sigma +( P_1(i))^2;
    p_2_sigma = p_2_sigma +( P_2(i))^2;
    
end

CORRELLATION =  ( sigma / sqrt( p_1_sigma * p_2_sigma ));


    
    
    
    