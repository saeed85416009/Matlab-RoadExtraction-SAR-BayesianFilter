function[e] = ERROR_MATCH_WEIGHTED (P,A,WEIGHT)
   [ WCOV , WVAR_X , WVAR_Y , WCORR2 ] = WEITHED_COV_VAR_CORR2(P, A , WEIGHT );
   e_1 = abs(1 - WCORR2);
   e_2 = (( mean ( P) - mean (A))/ mean ( P))^2;
   e = (e_1 + e_2 )/2; 