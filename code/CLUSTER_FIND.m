%%%____________________________________________________ create new cluster______________________________________%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% build new cluster accourding to new coardinate that founded and compare
%%% that with old cluster. 
%%% input :
%%% PROFILE : source profile
%%% B1 ~ B9 : new cluster profile that will update during of moving path
%%% ROW : row of final detect point in end section
%%% COLOUMN :  coloumn of final detect point in end section
%%% ANGLE : angle of final detect point in end section
%%% CONTRAST_ROAD : contrast value of road in canny equal
%%% WIDE_MARGIN : maximum value of edge road that point can be have in canny situation 
%%% CONTRAST_CLUSTER_PROF : maximum value for new profile element that can be have
%%% WIDE_MAX_CLUSTER : maximum wide of new profile
%%% VAR_MAX_CLUSTER : maximum variance of new profile that can be have
%%% Cluster_Similarity_Modify : if similarity between new profile and source profile new profile ( or new profile and other detect profile ) less than Cluster_Similarity_Modify , profile choose for new profile  
%%% 
%%% output :
%%% B1 ~ B9 : new cluster profile that will update during of moving path
%%% W_1 ~ W_9 : wide of new cluster profile that will update during of moving path
%%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%%%%%%%%%%%%%%%%%%%%%%%
function [ B1 , B2 , B3 , B4 , B5 ,  B6 , B7 , B8 , B9 , W_1 , W_2 , W_3 , W_4 , W_5 , W_6 , W_7 , W_8 , W_9 ] = CLUSTER_FIND (PROFILE , B1 , B2 , B3 , B4 ,  B5 , B6 , B7 , B8 , B9 , W_1 , W_2 , W_3 , W_4 , W_5 , W_6 , W_7 , W_8 , W_9 ,  ROW , COLOUMN , ANGLE , CONTRAST_ROAD , WIDE_MARGIN , CONTRAST_CLUSTER_PROF , WIDE_MAX_CLUSTER , VAR_MAX_CLUSTER , Cluster_Similarity_Modify ) 

global cluster 
%%%%%%%%



 %%% measurment wide of road 
           [C , edge_canny_wide_C]  = DIFF_PROFILE ( ROW , COLOUMN , ANGLE , CONTRAST_ROAD ,  WIDE_MARGIN  );

     %% the end of ANGLEnd wide of road
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

       j=1;
       i=2; %%initial point for cluster
               %%%%%% new cluster 1 %%%%%%%%%%%%%%%%%%%%%%%%

    if cluster == 1      
    
   bb= ORIGINAL_MATCH(ROW , COLOUMN , ANGLE );      

   bb= double(bb);

   if  ( bb < CONTRAST_CLUSTER_PROF ) 
         if  ( var(bb) < VAR_MAX_CLUSTER ) && ( C < WIDE_MAX_CLUSTER )

   A=intersect(round(PROFILE),round(bb));
   Asize=size(A);
   Asize(2);
   
   if ( Asize(2) < Cluster_Similarity_Modify )
       B1 = bb ;
       cluster=cluster+1;
        W_1 = edge_canny_wide_C - 2;
   end
  
      end
   end 

                   %%%%%% new cluster 2 %%%%%%%%%%%%%%%%%%%%%%%%

    
    elseif cluster == 2

   bb= ORIGINAL_MATCH(ROW , COLOUMN , ANGLE );       
   bb= double(bb);
       
   if  ( bb < CONTRAST_CLUSTER_PROF ) 
         if  ( var(bb) < VAR_MAX_CLUSTER ) && ( C < WIDE_MAX_CLUSTER )

   
   A=intersect(round(PROFILE),round(bb));
   Asize=size(A);
   B = intersect(round(B1) ,round( bb) );
   Bsize=size(B);
   
   if ( Asize(2) < Cluster_Similarity_Modify ) && ( Bsize(2) <Cluster_Similarity_Modify )
       B2 = bb ;
          cluster=cluster+1;
          W_2 = edge_canny_wide_C- 2;
   end
   end
   end
                  %%%%%% new cluster 3 %%%%%%%%%%%%%%%%%%%%%%%%

   
        elseif cluster == 3
            
   bb= ORIGINAL_MATCH(ROW , COLOUMN , ANGLE );       
   bb= double(bb);
            
   if  ( bb < CONTRAST_CLUSTER_PROF ) 
         if  ( var(bb) < VAR_MAX_CLUSTER ) && ( C < WIDE_MAX_CLUSTER )
       
   A=intersect(round(PROFILE),round(bb));
   Asize=size(A);
   B = intersect(round(B1) ,round( bb) );
   Bsize=size(B);
   C=intersect(round(B2),round(bb));
   Csize=size(C);
   if ( Asize(2) < Cluster_Similarity_Modify )&&(Bsize(2)< Cluster_Similarity_Modify)&&(Csize(2)<Cluster_Similarity_Modify)
          B3 = bb ;
          cluster=cluster+1;
          W_3 = edge_canny_wide_C- 2;

   end
             end
   end
                  %%%%%% new cluster 4 %%%%%%%%%%%%%%%%%%%%%%%%

            elseif cluster == 4
                
   bb= ORIGINAL_MATCH(ROW , COLOUMN , ANGLE );       
   bb= double(bb);
   
   if  ( bb < CONTRAST_CLUSTER_PROF ) 
         if  ( var(bb) < VAR_MAX_CLUSTER ) && ( C < WIDE_MAX_CLUSTER )
   
 
   A=intersect(round(PROFILE),round(bb));
   Asize=size(A);
   B = intersect(round(B1) ,round( bb) );
   Bsize=size(B);
   C=intersect(round(B2),round(bb));
   Csize=size(C);
   D=intersect(round(B3),round(bb));
   Dsize=size(D);
   if ( Asize(2) < Cluster_Similarity_Modify )&&( Bsize(2)<Cluster_Similarity_Modify ) && ( Csize(2)<Cluster_Similarity_Modify)&& ( Dsize(2)<Cluster_Similarity_Modify)
       B4 = bb ;
          cluster=cluster+1;
          W_4 = edge_canny_wide_C- 2;

   end
             end
   end
                  %%%%%% new cluster 5 %%%%%%%%%%%%%%%%%%%%%%%%

   
                elseif cluster == 5
                    
   bb= ORIGINAL_MATCH(ROW , COLOUMN , ANGLE );       
   bb= double(bb);
   
   if  ( bb < CONTRAST_CLUSTER_PROF ) 
         if  ( var(bb) < VAR_MAX_CLUSTER ) && ( C < WIDE_MAX_CLUSTER )

   A=intersect(round(PROFILE),round(bb));
   Asize=size(A);
   B = intersect(round(B1) ,round( bb) );
   Bsize=size(B);
   C=intersect(round(B2),round(bb));
   Csize=size(C);
   D=intersect(round(B3),round(bb));
   Dsize=size(D);
   E=intersect(round(B4),round(bb));
   Esize=size(E);
   if ( Asize(2) < Cluster_Similarity_Modify )&&(Bsize(2)<Cluster_Similarity_Modify)&&(Csize(2)<Cluster_Similarity_Modify)&(Dsize(2)<Cluster_Similarity_Modify)&&(Esize(2)<Cluster_Similarity_Modify)
          B5 = bb ;
          cluster=cluster+1;
          W_5 = edge_canny_wide_C - 2;

   end
             end
   end
                     %%%%%% new cluster 6 %%%%%%%%%%%%%%%%%%%%%%%%

                    elseif cluster == 6
                        
   bb= ORIGINAL_MATCH(ROW , COLOUMN , ANGLE );       
   bb= double(bb);
                        
   if  ( bb < CONTRAST_CLUSTER_PROF ) 
         if  ( var(bb) < VAR_MAX_CLUSTER ) && ( C < WIDE_MAX_CLUSTER )

   A=intersect(round(PROFILE),round(bb));
   Asize=size(A);
   B = intersect(round(B1) ,round( bb) );
   Bsize=size(B);
   C=intersect(round(B2),round(bb));
   Csize=size(C);
   D=intersect(round(B3),round(bb));
   Dsize=size(D);
   E=intersect(round(B4),round(bb));
   Esize=size(E);
   F=intersect(round(B5),round(bb));
   Fsize=size(F);
   if ( Asize(2) < Cluster_Similarity_Modify )&&(Bsize(2)<Cluster_Similarity_Modify)&&(Csize(2)<Cluster_Similarity_Modify)&(Dsize(2)<Cluster_Similarity_Modify)&&(Esize(2)<Cluster_Similarity_Modify)&&(Fsize(2)<Cluster_Similarity_Modify)
          B6 = bb ;
          cluster=cluster+1;
          W_6=edge_canny_wide_C - 2;

   end
             end
   end
               %%%%%% new cluster 7 %%%%%%%%%%%%%%%%%%%%%%%%

                        elseif cluster == 7
                            
   bb= ORIGINAL_MATCH(ROW , COLOUMN , ANGLE );       
   bb= double(bb);
   
   if  ( bb < CONTRAST_CLUSTER_PROF ) 
         if  ( var(bb) < VAR_MAX_CLUSTER ) && ( C < WIDE_MAX_CLUSTER )

   A=intersect(round(PROFILE),round(bb));
   Asize=size(A);
   B = intersect(round(B1) ,round( bb) );
   Bsize=size(B);
   C=intersect(round(B2),round(bb));
   Csize=size(C);
   D=intersect(round(B3),round(bb));
   Dsize=size(D);
   E=intersect(round(B4),round(bb));
   Esize=size(E);
   F=intersect(round(B5),round(bb));
   Fsize=size(F);
   R=intersect(round(B6),round(bb));
   Rsize=size(R);
   if ( Asize(2) < Cluster_Similarity_Modify )&&(Bsize(2)<Cluster_Similarity_Modify)&&(Csize(2)<Cluster_Similarity_Modify)&&(Dsize(2)<Cluster_Similarity_Modify)&&(Esize(2)<Cluster_Similarity_Modify)&&(Fsize(2)<Cluster_Similarity_Modify)&&(Rsize(2)<Cluster_Similarity_Modify)
     
          B7 = bb ;
      
          W_7 = edge_canny_wide_C - 2;
          cluster=cluster+1;

          
   end
             end
   end
         %%%%%% new cluster 8%%%%%%%%%%%%%%%%%%%%%%%%

                            elseif cluster == 8
                               
   bb= ORIGINAL_MATCH(ROW , COLOUMN , ANGLE );       
   bb= double(bb);
   
   if  ( bb < CONTRAST_CLUSTER_PROF ) 
         if  ( var(bb) < VAR_MAX_CLUSTER ) && ( C < WIDE_MAX_CLUSTER )

    A=intersect(round(PROFILE),round(bb));
   Asize=size(A);
   B = intersect(round(B1) ,round( bb) );
   Bsize=size(B);
   C=intersect(round(B2),round(bb));
   Csize=size(C);
   D=intersect(round(B3),round(bb));
   Dsize=size(D);
   E=intersect(round(B4),round(bb));
   Esize=size(E);
   F=intersect(round(B5),round(bb));
   Fsize=size(F);
   R=intersect(round(B6),round(bb));
   Rsize=size(R);
   J=intersect(round(B7),round(bb));
   Jsize=size(J);
   if ( Asize(2) < Cluster_Similarity_Modify )&&(Bsize(2)<Cluster_Similarity_Modify)&&(Csize(2)<Cluster_Similarity_Modify)&&(Dsize(2)<Cluster_Similarity_Modify)&&(Esize(2)<Cluster_Similarity_Modify)&&(Fsize(2)<Cluster_Similarity_Modify)&&(Rsize(2)<Cluster_Similarity_Modify)&&(Jsize(2)<Cluster_Similarity_Modify)
    
          B8 = bb ;
          cluster=cluster+1;
          W_8=edge_canny_wide_C - 2;

   end
             end
   end
     
   %%%%%% new cluster 9%%%%%%%%%%%%%%%%%%%%%%%%
                                elseif cluster == 9
                                    
   bb= ORIGINAL_MATCH(ROW , COLOUMN , ANGLE );       
   bb= double(bb);
   
   if  ( bb < CONTRAST_CLUSTER_PROF ) 
         if  ( var(bb) < VAR_MAX_CLUSTER ) && ( C < WIDE_MAX_CLUSTER )

   A=intersect(round(PROFILE),round(bb));
   Asize=size(A);
   B = intersect(round(B1) ,round( bb) );
   Bsize=size(B);
   C=intersect(round(B2),round(bb));
   Csize=size(C);
   D=intersect(round(B3),round(bb));
   Dsize=size(D);
   E=intersect(round(B4),round(bb));
   Esize=size(E);
   F=intersect(round(B5),round(bb));
   Fsize=size(F);
   R=intersect(round(B6),round(bb));
   Rsize=size(R);
   J=intersect(round(B7),round(bb));
   Jsize=size(J);
   L=intersect(round(B8),round(bb));
   Lsize = size(L);
   
   if ( Asize(2) < Cluster_Similarity_Modify )&&(Bsize(2)<Cluster_Similarity_Modify)&&(Csize(2)<Cluster_Similarity_Modify)&&(Dsize(2)<Cluster_Similarity_Modify)&&(Esize(2)<Cluster_Similarity_Modify)&&(Fsize(2)<Cluster_Similarity_Modify)&&(Rsize(2)<Cluster_Similarity_Modify)&&(Jsize(2)<Cluster_Similarity_Modify)&&(Lsize(2)<Cluster_Similarity_Modify)
       B9 = bb ;
       W_9=edge_canny_wide_C - 2;
       cluster = 1;
   end
             end
   end   
    %%%%%%%%%
        end   %% end of new cluster search and build that
