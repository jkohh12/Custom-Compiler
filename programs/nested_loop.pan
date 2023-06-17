...This is a nested loop...

task main;
startparams
finishparams
startlocals

i integer;
i integer2;


finishlocals

startbody

integer :=: 0;
during integer << 2 startloop
    integer2 :=: 1;
    during integer2 <<<- 3 startloop   
        output<{integer2};
	    integer2 :=: integer2 + 1;
	finishloop
    integer :=: integer + 1;
finishloop
finishbody
