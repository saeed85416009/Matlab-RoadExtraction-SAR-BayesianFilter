function BB = MATCH ( r_match,c_match)
    global x;
    BB(1,1) = x(r_match , c_match );
    BB(1,2) = x(r_match+1,c_match+1);
    BB(1,3) = x(r_match-1,c_match+1);
    BB(1,4) = x(r_match+1,c_match-1);
    BB(1,5) = x(r_match-1,c_match-1);
    BB(1,6) = x(r_match,c_match+1);
    BB(1,7) = x(r_match,c_match-1);
    BB(1,8) = x(r_match+1,c_match);
    BB(1,9) = x(r_match-1,c_match);