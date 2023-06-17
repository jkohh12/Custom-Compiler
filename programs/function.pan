task add;
startparams
    i a;
    i b;
finishparams
startlocals
finishlocals
startbody
        rebound a + b;
finishbody


task mult;
startparams
    i a;
    i b;
finishparams
startlocals
finishlocals
startbody
        rebound a * b;
finishbody



task main;
startparams
finishparams

startlocals
  i a;
  i b;
  i c;
  i d;
finishlocals

startbody    

  a :=: 100;
  b :=: 50;
  c :=: add{a,b};
  output<{c};        ... should print 150 ...


  d :=: mult{c, a + b};
  output<{d};        ... should print "22500", since 22500 = 150 * 150 ...
finishbody
