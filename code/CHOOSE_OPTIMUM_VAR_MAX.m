function [ VAR_MAX ] = CHOOSE_OPTIMUM_VAR_MAX( AA , P_1 , P_2, P_3 , P_4 , B_1 , B_2 , B_3 , B_4 , B_5 , B_6 , B_7 , B_8 , B_9 , VAR_MEAN_GOOD , VAR_MEAN_BAD )


      AA_1 =ARRANGE_MATRIX (AA);
      P_1_1= ARRANGE_MATRIX (P_1);
      P_2_1 = ARRANGE_MATRIX (P_2);
      P_3_1 = ARRANGE_MATRIX (P_3);
      P_4_1 = ARRANGE_MATRIX (P_4);
      B_1_1 = ARRANGE_MATRIX (B_1);
      B_2_1 = ARRANGE_MATRIX (B_2);
      B_3_1 = ARRANGE_MATRIX (B_3);
      B_4_1 = ARRANGE_MATRIX (B_4);
      B_5_1 = ARRANGE_MATRIX (B_5);
      B_6_1 = ARRANGE_MATRIX (B_6);
      B_7_1 = ARRANGE_MATRIX (B_7);
      B_8_1 = ARRANGE_MATRIX (B_8);
      B_9_1 = ARRANGE_MATRIX (B_9);

      if (mean( AA_1) < mean (P_1_1) )
          VAR_MAX = VAR_MEAN_GOOD;
      elseif ( mean(AA_1) < mean( P_2_1 ) )
          VAR_MAX = VAR_MEAN_GOOD;
      elseif ( mean(AA_1) < mean(P_3_1) )
          VAR_MAX = VAR_MEAN_GOOD;
      elseif( mean(AA_1) < mean(P_4_1) ) 
          VAR_MAX = VAR_MEAN_GOOD;
      elseif( mean(AA_1) < mean(B_1_1) )
          VAR_MAX = VAR_MEAN_GOOD;
      elseif( mean(AA_1) < mean(B_2_1) )
          VAR_MAX = VAR_MEAN_GOOD;
      elseif( mean(AA_1) < mean(B_3_1) )
          VAR_MAX = VAR_MEAN_GOOD;
      elseif( mean(AA_1) < mean(B_4_1) )
          VAR_MAX = VAR_MEAN_GOOD;
      elseif( mean(AA_1) < mean(B_5_1) )
          VAR_MAX = VAR_MEAN_GOOD;
      elseif( mean(AA_1) < mean(B_6_1) )
          VAR_MAX = VAR_MEAN_GOOD;
      elseif( mean(AA_1) < mean(B_7_1) )
          VAR_MAX = VAR_MEAN_GOOD;
      elseif( mean(AA_1) < mean(B_8_1) )
          VAR_MAX = VAR_MEAN_GOOD;
      elseif( mean(AA_1) < mean(B_9_1) )
          VAR_MAX = VAR_MEAN_GOOD;
      else
          VAR_MAX = VAR_MEAN_BAD;
      end


end

