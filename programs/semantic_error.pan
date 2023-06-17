task main;
startparams
finishparams
startlocals
	i n;
    i arr[{10}] r;
    i arr[{10}] n;

finishlocals
startbody
    input>{n};
	n :=: z + 1;
 	n :=: n + r;
    output<{n};
	resume;
finishbody