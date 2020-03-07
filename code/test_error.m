aa= [  71    77    77    94    86    86    95 ]
find_error_flag = 1000
if cov(p_1 , aa ) < var_max   
[error_1] = ERROR_MATCH_ARRANGED (p_1,aa)
find_error_flag = 0;
 end

if cov(b_1,aa ) < var_max
[error_2] = ERROR_MATCH_ARRANGED (b_1,aa)
find_error_flag = 0;
end

if cov(b_2,aa ) < var_max
[error_3] = ERROR_MATCH_ARRANGED (b_2,aa)
find_error_flag = 0;
end

if cov(b_3,aa ) < var_max
[error_4] = ERROR_MATCH_ARRANGED (b_3,aa)
find_error_flag = 0;
end

if cov(b_4,aa ) < var_max
[error_5] = ERROR_MATCH_ARRANGED (b_4,aa)
find_error_flag = 0;
end

if cov(b_5,aa ) < var_max
[error_6] = ERROR_MATCH_ARRANGED (b_5,aa)
find_error_flag = 0;
end

if cov(b_6,aa ) < var_max
[error_7] = ERROR_MATCH_ARRANGED (b_6,aa)
find_error_flag = 0;
end

if cov(b_7,aa ) < var_max
[error_8] = ERROR_MATCH_ARRANGED (b_7,aa)
find_error_flag = 0;
end

if cov(b_8,aa ) < var_max
[error_9] = ERROR_MATCH_ARRANGED (b_8,aa)
find_error_flag = 0;
end

if cov(b_9,aa ) < var_max
[error_10] = ERROR_MATCH_ARRANGED (b_9,aa)
find_error_flag = 0;
end


if cov(p_2,aa ) < var_max
[error_11] = ERROR_MATCH_ARRANGED (p_2,aa)
find_error_flag = 0;
end

if cov(p_3,aa ) < var_max
[error_12] = ERROR_MATCH_ARRANGED (p_3,aa)
find_error_flag = 0;
end

if cov(p_4,aa ) < var_max
[error_13] = ERROR_MATCH_ARRANGED (p_4,aa)
find_error_flag = 0;
end

find_error_flag
   error_out = [error_1,error_2,error_3,error_4,error_5,error_6,error_7,error_8,error_9,error_10,error_11,error_12,error_13 ]
   e=min(error_out)
