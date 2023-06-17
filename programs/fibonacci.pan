task fibonacci;
startparams
 i k;
finishparams
startlocals
finishlocals
startbody
  whether k <<<- 1 
    rebound 1;
  endw;
  rebound fibonacci{k - 1} + fibonacci{k-2};
finishbody

task main;
startparams
finishparams
startlocals

i n;
i fib;

finishlocals
startbody

  input>{n};
  fib :=: fibonacci{n};
  output<{fib};

finishbody