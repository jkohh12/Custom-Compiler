task main;
startparams
finishparams
startlocals



finishlocals

startbody	... main program ...

  b :=: 3;
  c :=: 5;
  a[{0}] :=: b + c;
  output<{a[{0}]};    ... should print out 8 ...

  a[{1}] :=: 100;
  output<{a[{1}]};    ... should print out 100 ...

  a[{2}] :=: 200;
  output<{a[{2}]};    ... should print out 200 ...

  a[{3}] :=: a[{0}] - {a[{1}] + c};
  output<{a[{3}]};    ... should print out 840; since 840 = 8 * (100 +5) ...
finishbody
