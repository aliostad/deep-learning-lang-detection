#!/usr/bin/octave -q 

EnterTime0 = [ \
	loadMatrix("ScopedMemoryTiming0/EnterTime4096", "%f")'; \
	loadMatrix("ScopedMemoryTiming0/EnterTime8192", "%f")'; \
	loadMatrix("ScopedMemoryTiming0/EnterTime16384", "%f")'; \
	loadMatrix("ScopedMemoryTiming0/EnterTime32768", "%f")'; \
	loadMatrix("ScopedMemoryTiming0/EnterTime65536", "%f")'; \
	loadMatrix("ScopedMemoryTiming0/EnterTime131072", "%f")'; \
	loadMatrix("ScopedMemoryTiming0/EnterTime262144", "%f")'; \
	loadMatrix("ScopedMemoryTiming0/EnterTime524288", "%f")'; \
	loadMatrix("ScopedMemoryTiming0/EnterTime1048576", "%f")'; \
];

EnterTime1 = [ \
	loadMatrix("ScopedMemoryTiming1/EnterTime4096", "%f")'; \
	loadMatrix("ScopedMemoryTiming1/EnterTime8192", "%f")'; \
	loadMatrix("ScopedMemoryTiming1/EnterTime16384", "%f")'; \
	loadMatrix("ScopedMemoryTiming1/EnterTime32768", "%f")'; \
	loadMatrix("ScopedMemoryTiming1/EnterTime65536", "%f")'; \
	loadMatrix("ScopedMemoryTiming1/EnterTime131072", "%f")'; \
	loadMatrix("ScopedMemoryTiming1/EnterTime262144", "%f")'; \
	loadMatrix("ScopedMemoryTiming1/EnterTime524288", "%f")'; \
	loadMatrix("ScopedMemoryTiming1/EnterTime1048576", "%f")'; \
];

EnterTime2 = [ \
	loadMatrix("ScopedMemoryTiming2/EnterTime4096", "%f")'; \
	loadMatrix("ScopedMemoryTiming2/EnterTime8192", "%f")'; \
	loadMatrix("ScopedMemoryTiming2/EnterTime16384", "%f")'; \
	loadMatrix("ScopedMemoryTiming2/EnterTime32768", "%f")'; \
	loadMatrix("ScopedMemoryTiming2/EnterTime65536", "%f")'; \
	loadMatrix("ScopedMemoryTiming2/EnterTime131072", "%f")'; \
	loadMatrix("ScopedMemoryTiming2/EnterTime262144", "%f")'; \
	loadMatrix("ScopedMemoryTiming2/EnterTime524288", "%f")'; \
	loadMatrix("ScopedMemoryTiming2/EnterTime1048576", "%f")'; \
];

ExitTime0 = [ \
	loadMatrix("ScopedMemoryTiming0/ExitTime4096", "%f")'; \
	loadMatrix("ScopedMemoryTiming0/ExitTime8192", "%f")'; \
	loadMatrix("ScopedMemoryTiming0/ExitTime16384", "%f")'; \
	loadMatrix("ScopedMemoryTiming0/ExitTime32768", "%f")'; \
	loadMatrix("ScopedMemoryTiming0/ExitTime65536", "%f")'; \
	loadMatrix("ScopedMemoryTiming0/ExitTime131072", "%f")'; \
	loadMatrix("ScopedMemoryTiming0/ExitTime262144", "%f")'; \
	loadMatrix("ScopedMemoryTiming0/ExitTime524288", "%f")'; \
	loadMatrix("ScopedMemoryTiming0/ExitTime1048576", "%f")'; \
];

ExitTime1 = [ \
	loadMatrix("ScopedMemoryTiming1/ExitTime4096", "%f")'; \
	loadMatrix("ScopedMemoryTiming1/ExitTime8192", "%f")'; \
	loadMatrix("ScopedMemoryTiming1/ExitTime16384", "%f")'; \
	loadMatrix("ScopedMemoryTiming1/ExitTime32768", "%f")'; \
	loadMatrix("ScopedMemoryTiming1/ExitTime65536", "%f")'; \
	loadMatrix("ScopedMemoryTiming1/ExitTime131072", "%f")'; \
	loadMatrix("ScopedMemoryTiming1/ExitTime262144", "%f")'; \
	loadMatrix("ScopedMemoryTiming1/ExitTime524288", "%f")'; \
	loadMatrix("ScopedMemoryTiming1/ExitTime1048576", "%f")'; \
];

ExitTime2 = [ \
	loadMatrix("ScopedMemoryTiming2/ExitTime4096", "%f")'; \
	loadMatrix("ScopedMemoryTiming2/ExitTime8192", "%f")'; \
	loadMatrix("ScopedMemoryTiming2/ExitTime16384", "%f")'; \
	loadMatrix("ScopedMemoryTiming2/ExitTime32768", "%f")'; \
	loadMatrix("ScopedMemoryTiming2/ExitTime65536", "%f")'; \
	loadMatrix("ScopedMemoryTiming2/ExitTime131072", "%f")'; \
	loadMatrix("ScopedMemoryTiming2/ExitTime262144", "%f")'; \
	loadMatrix("ScopedMemoryTiming2/ExitTime524288", "%f")'; \
	loadMatrix("ScopedMemoryTiming2/ExitTime1048576", "%f")'; \
];

CreationTime0 = [ \
	loadMatrix("ScopedMemoryTiming0/CreationTime4096", "%f")'; \
	loadMatrix("ScopedMemoryTiming0/CreationTime8192", "%f")'; \
	loadMatrix("ScopedMemoryTiming0/CreationTime16384", "%f")'; \
	loadMatrix("ScopedMemoryTiming0/CreationTime32768", "%f")'; \
	loadMatrix("ScopedMemoryTiming0/CreationTime65536", "%f")'; \
	loadMatrix("ScopedMemoryTiming0/CreationTime131072", "%f")'; \
	loadMatrix("ScopedMemoryTiming0/CreationTime262144", "%f")'; \
	loadMatrix("ScopedMemoryTiming0/CreationTime524288", "%f")'; \
	loadMatrix("ScopedMemoryTiming0/CreationTime1048576", "%f")'; \
];

CreationTime1 = [ \
	loadMatrix("ScopedMemoryTiming1/CreationTime4096", "%f")'; \
	loadMatrix("ScopedMemoryTiming1/CreationTime8192", "%f")'; \
	loadMatrix("ScopedMemoryTiming1/CreationTime16384", "%f")'; \
	loadMatrix("ScopedMemoryTiming1/CreationTime32768", "%f")'; \
	loadMatrix("ScopedMemoryTiming1/CreationTime65536", "%f")'; \
	loadMatrix("ScopedMemoryTiming1/CreationTime131072", "%f")'; \
	loadMatrix("ScopedMemoryTiming1/CreationTime262144", "%f")'; \
	loadMatrix("ScopedMemoryTiming1/CreationTime524288", "%f")'; \
	loadMatrix("ScopedMemoryTiming1/CreationTime1048576", "%f")'; \
];

CreationTime2 = [ \
	loadMatrix("ScopedMemoryTiming2/CreationTime4096", "%f")'; \
	loadMatrix("ScopedMemoryTiming2/CreationTime8192", "%f")'; \
	loadMatrix("ScopedMemoryTiming2/CreationTime16384", "%f")'; \
	loadMatrix("ScopedMemoryTiming2/CreationTime32768", "%f")'; \
	loadMatrix("ScopedMemoryTiming2/CreationTime65536", "%f")'; \
	loadMatrix("ScopedMemoryTiming2/CreationTime131072", "%f")'; \
	loadMatrix("ScopedMemoryTiming2/CreationTime262144", "%f")'; \
	loadMatrix("ScopedMemoryTiming2/CreationTime524288", "%f")'; \
	loadMatrix("ScopedMemoryTiming2/CreationTime1048576", "%f")'; \
];

ExecTime0 = [ \
	loadMatrix("ScopedMemoryTiming0/ExecTime4096", "%f")'; \
	loadMatrix("ScopedMemoryTiming0/ExecTime8192", "%f")'; \
	loadMatrix("ScopedMemoryTiming0/ExecTime16384", "%f")'; \
	loadMatrix("ScopedMemoryTiming0/ExecTime32768", "%f")'; \
	loadMatrix("ScopedMemoryTiming0/ExecTime65536", "%f")'; \
	loadMatrix("ScopedMemoryTiming0/ExecTime131072", "%f")'; \
	loadMatrix("ScopedMemoryTiming0/ExecTime262144", "%f")'; \
	loadMatrix("ScopedMemoryTiming0/ExecTime524288", "%f")'; \
	loadMatrix("ScopedMemoryTiming0/ExecTime1048576", "%f")'; \
];

ExecTime1 = [ \
	loadMatrix("ScopedMemoryTiming1/ExecTime4096", "%f")'; \
	loadMatrix("ScopedMemoryTiming1/ExecTime8192", "%f")'; \
	loadMatrix("ScopedMemoryTiming1/ExecTime16384", "%f")'; \
	loadMatrix("ScopedMemoryTiming1/ExecTime32768", "%f")'; \
	loadMatrix("ScopedMemoryTiming1/ExecTime65536", "%f")'; \
	loadMatrix("ScopedMemoryTiming1/ExecTime131072", "%f")'; \
	loadMatrix("ScopedMemoryTiming1/ExecTime262144", "%f")'; \
	loadMatrix("ScopedMemoryTiming1/ExecTime524288", "%f")'; \
	loadMatrix("ScopedMemoryTiming1/ExecTime1048576", "%f")'; \
];

ExecTime2 = [ \
	loadMatrix("ScopedMemoryTiming2/ExecTime4096", "%f")'; \
	loadMatrix("ScopedMemoryTiming2/ExecTime8192", "%f")'; \
	loadMatrix("ScopedMemoryTiming2/ExecTime16384", "%f")'; \
	loadMatrix("ScopedMemoryTiming2/ExecTime32768", "%f")'; \
	loadMatrix("ScopedMemoryTiming2/ExecTime65536", "%f")'; \
	loadMatrix("ScopedMemoryTiming2/ExecTime131072", "%f")'; \
	loadMatrix("ScopedMemoryTiming2/ExecTime262144", "%f")'; \
	loadMatrix("ScopedMemoryTiming2/ExecTime524288", "%f")'; \
	loadMatrix("ScopedMemoryTiming2/ExecTime1048576", "%f")'; \
];

printf("Saving Workspace...\n")
save -ascii /home/angelo/Devel/RTJPerf/WS/SMTiming.ows


hold on 

printf("Plotting CTMemory Enter Time\n")

for i = 1:size(EnterTime0)(1)
	semilogy(EnterTime0(i, 5:(size(EnterTime0)(2))));
	hold on
endfor

printf("Press a key to see CTMEmory Exit Time")
scanf("%s", 1)
for i = 1:size(ExitTime0)(1)
	semilogy(ExitTime0(i, 5:(size(ExitTime0)(2))));
	hold on
endfor

hold off 

printf("Press a key to see LT Enter Time")
scanf("%s", 1)
for i = 1:size(EnterTime1)(1)
	semilogy(EnterTime1(i, 5:(size(EnterTime1)(2))));
	hold on
endfor
printf("Press a key to see LT Exit Time")
scanf("%s", 1)
for i = 1:size(ExitTime1)(1)
	semilogy(ExitTime1(i, 5:(size(ExitTime1)(2))));
	hold on
endfor

hold off 

printf("Press a key to see VT Enter Time")
scanf("%s", 1)
for i = 1:size(EnterTime2)(1)
	semilogy(EnterTime2(i, 5:(size(EnterTime2)(2))));
	hold on
endfor
printf("Press a key to see VT Exit Time")
scanf("%s", 1)
for i = 1:size(ExitTime2)(1)
	semilogy(ExitTime2(i, 5:(size(ExitTime2)(2))));
	hold on
endfor

hold off 

printf("Press a key to continue...")
scanf("%s", 1)
printf("Plotting Creation Times\n")

for i = 1:size(CreationTime0)(1)
	semilogy(CreationTime0(i, 5:(size(CreationTime0)(2))));
	hold on
endfor
printf("...")
scanf("%s", 1)

hold off 

for i = 1:size(CreationTime1)(1)
	semilogy(CreationTime1(i, 5:(size(CreationTime1)(2))));
	hold on
endfor

hold off 

for i = 1:size(CreationTime2)(1)
	semilogy(CreationTime2(i, 5:(size(CreationTime2)(2))));
	hold on
endfor

hold off 

printf("Press a key to continue...")
scanf("%s", 1)
printf("Plotting Execution Times\n")

for i = 1:size(ExecTime0)(1)
	semilogy(ExecTime0(i, 5:(size(ExecTime0)(2))));
	hold on
endfor
printf("...")
scanf("%s", 1)
for i = 1:size(ExecTime1)(1)
	semilogy(ExecTime1(i, 5:(size(ExecTime1)(2))));
	hold on
endfor
printf("...")
scanf("%s", 1)
for i = 1:size(ExecTime2)(1)
	semilogy(ExecTime2(i, 5:(size(ExecTime2)(2))));
	hold on
endfor
printf("Press a key to exit...")
scanf("%s", 1)

