task main;
startparams
finishparams
startlocals

  i a;
  i b;
  i c;

finishlocals

startbody
  a :=: 100;
  b :=: 50;
 
  ... Addition, answer is 150, since 150 := 100+50 ...
  c :=: a + b;
  output<{c};

  ... Subtraction, answer is 50, since 50 := 100-50 ...
  c :=: a - b;
  output<{c};

  ... Multiplication, answer is 5000, since 5000 := 100 * 50 ...
  c :=: a * b;
  output<{c};

  ... Division, answer is 2, since 2 := 100/50 ...
  c :=: a / b;
  output<{c};

  ... Modulus, answer is 0, since 0 := 100 % 50 ...
  c :=: a % b;
  output<{c};

  ... "Complex" Expression. ...
  a :=: 4;
  b :=: 2;
  c :=: {a + b} * 7;
  output<{c};

finishbody
