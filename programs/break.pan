... This is a simple loop with a break statement ...

task main;
startparams
finishparams
startlocals

i a;

finishlocals
startbody

  a :=: 0;
  during a <<<- 10 startloop
    output<{a};

    whether a >> 3
      pause;
    endw;

    a :=: a + 1;

  finishloop

finishbody
