function[e ] = ERROR_MATCH_ARRANGED (P,A)

a = ARRANGE_MATRIX (A);
p = ARRANGE_MATRIX (P);

e_1 = abs( 1 - abs(corr2(a,p)));
e_2 = (( mean ( P) - mean (A))/ mean ( P))^2;
e = (e_1 + e_2 )/2;

