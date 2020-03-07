%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% r_match : measurment row condidate that we want check its probabilily
%%% c_match : measurment coloumn condidate that we want check its probabilily
%%% FI : measurment angle 
%%% mw : ((wide of profile matching - 1) / 2 )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function BB=ORIGINAL_MATCH(r_match,c_match,FI)
        
        global x
        global match_wide
        i=1;
       for u = match_wide : -1 :1
       r_3 = round ( r_match - u *sind (90-FI ));    %  check shode dorosre
       c_3 = round ( c_match - u *cosd ( 90-FI ));
      
       BB(1,i) =  x( r_3 , c_3 ) ;            
       i = i + 1;
   end
   
   BB(1,i) = x(round(r_match),round(c_match) ) ;
   i=i+1;
     
   for u = 1:match_wide
       r_3 = round ( r_match + u *sind ( (90-FI)));
       c_3 = round ( c_match + u * cosd ( (90-FI )));
      
       BB(1,i) =  x( r_3 , c_3 );             
       i = i + 1;
       
   end