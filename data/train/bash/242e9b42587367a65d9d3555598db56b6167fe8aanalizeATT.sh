#!/usr/bin/octave -q

CT = [loadMatrix("AllocTime0/AllocTime32", "%f")' ;\ 
      loadMatrix("AllocTime0/AllocTime64", "%f")'  ;\
      loadMatrix("AllocTime0/AllocTime128", "%f")' ;\
      loadMatrix("AllocTime0/AllocTime256", "%f")' ;\
      loadMatrix("AllocTime0/AllocTime512", "%f")' ;\
      loadMatrix("AllocTime0/AllocTime1024", "%f")' ;\
      loadMatrix("AllocTime0/AllocTime2048", "%f")' ;\
      loadMatrix("AllocTime0/AllocTime4096", "%f")' ;\
      loadMatrix("AllocTime0/AllocTime8192", "%f")' ;\
      loadMatrix("AllocTime0/AllocTime16384", "%f")' ];

LT = [loadMatrix("AllocTime1/AllocTime32", "%f")' ;\ 
      loadMatrix("AllocTime1/AllocTime64", "%f")'  ;\
      loadMatrix("AllocTime1/AllocTime128", "%f")' ;\
      loadMatrix("AllocTime1/AllocTime256", "%f")' ;\
      loadMatrix("AllocTime1/AllocTime512", "%f")' ;\
      loadMatrix("AllocTime1/AllocTime1024", "%f")' ;\
      loadMatrix("AllocTime1/AllocTime2048", "%f")' ;\
      loadMatrix("AllocTime1/AllocTime4096", "%f")' ;\
      loadMatrix("AllocTime1/AllocTime8192", "%f")' ;\
      loadMatrix("AllocTime1/AllocTime16384", "%f")' ];
            
hold on;
printf("Parsed Data...\n");

for i = 1:size(CT)(1)
    semilogy(CT(i,10:(size(CT)(2))));
endfor
printf("Are you ready to see the LTMemory Results?...\n");
scanf("%s", 1);
for i = 1:size(LT)(1)
    semilogyLT(i,10:(size(LT)(2))));
endfor
        
printf("Press a key and enter to exit...\n");
scanf("%s", 1);
