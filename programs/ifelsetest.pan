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

    whether a << b
        c :=: b;
     or 
        c :=: a;
    
    endw;
output<{c};
finishbody
