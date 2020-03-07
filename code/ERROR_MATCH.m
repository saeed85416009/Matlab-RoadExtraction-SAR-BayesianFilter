function[e] = ERROR_MATCH (P,A)
   co = cov ( P , A );
   r =abs( co(2) / sqrt( var ( P)*var(A)));
   e_1 = abs(1 - r);
   e_2 = (( mean ( P) - mean (A))/ mean ( P))^2;
   e = (e_1 + e_2 )/2;                                                  %% measurement error