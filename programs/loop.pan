...This is a simple loop that counts from 1 to 10...

task main;
startparams
finishparams
startlocals

i integer;


finishlocals

startbody

integer :=: 0;
during integer << 10 startloop
	integer :=: integer + 1;
	output<{integer};

finishloop
finishbody
