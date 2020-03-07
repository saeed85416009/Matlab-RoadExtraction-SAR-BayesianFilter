function BREAK_PARTICLE(SAMPLE)

global flag_repetitive_place

 %%%%%%%%% break for unacceptive state %%%%%%%%%
 if numel(SAMPLE) == 0
     
     SAMPLE
     note = ' dont find any sample'
     
     flag_repetitive_place = 0
     
 end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%