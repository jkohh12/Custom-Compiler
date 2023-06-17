# Custom Compiler
**Name**: Panda

**Extension**: .pan

**Compiler Name**: Panda-EXP

| Language Feature | Code Example |
| ----------- | ----------- |
| Integer Scalar Variables | `i a; i b; i count;` |
| One dimensional array of integers | `arr[{100}] a; arr[{5}] b = [{}]; arr[{5}] numbers = [{1,2,3,4,5}];` |
| Assignment Statements | `a :=: b; count :=: numbers;` |
| Arithmetic operators (e.g., “+”, “-”, “*”, “/”) | `a + b; a - b; a &* b; a / b;` |
| Relational Operators (e.g., “<”, “==”, “>”, “!=”) | `a << b; a <-b; a >> b; a ?<- b;` |
| While Loop | `during {true} [{ a <- a-b;  }] ` |
| If-then-else | `whether {a<<b} [{ a <- a@b }] or [{ a <- a! b;}]` |
| Read and write statements | `input>{a}; output<{a};` |
| Comments | `… comment …` |
| Functions | `task{a, b} [{a <- a!b; rebound}]` |

Define how comments would look like in your language: … (comment) … <br />
Define what would be the valid identifier: Identifier must have characters [A-Z] and/or [a-z] and/or numbers [0-9], and/or underscore(\_)
Identifier must also start with a lower case character [a-z], while the rest of the characters can be [A-Z] and/or [a-z] and/or numbers [0-9], and/or underscore(\_) <br />
Whether your language is case sensitive or not: This language is case sensitive <br />
What would be white spaces in your language: White spaces are ignored in this language. <br />


| Symbol in Language | Token Name |
| ----------- | ----------- |
| i | INTEGER |
| arr | ARRAY |
| <- | EQUAL TO |
| << | LESS THAN |
| ?<- | NOT EQUAL TO |
| >> | GREATER THAN |
| >><- | GREATER THAN OR EQUAL TO |
| <<<- | LESS THAN OR EQUAL TO |
| during | WHILE |
| whether | IF |
| or | ELSE |
| input>() | READ |
| output<() | WRITE |
| task | FUNCTION |
| startparams | BEGIN_PARAMS |
| finishparams | END_PARAMS |
| startlocals | BEGIN_LOCALS |
| finishlocals | END_LOCALS |
| startbody | BEGIN_BODY |
| finishbody | END_BODY |
| about | OF |
| after | THEN |
| endw | ENDIF |
| act | DO |
| startloop | BEGINLOOP |
| finishloop | ENDLOOP |
| resume | CONTINUE |
| pause | break |
| negate | NOT |
| true | TRUE |
| false | FALSE |
| rebound | RETURN |
| % | MODULO |
| + | ADDITION |
| - | SUBTRACTION |
| * | MULTIPLY |
| / | DIVIDE |
| ; | SEMICOLON |
| : | COLON |
| , | COMMA |
| { | L_PAREN |
| } | R_PAREN |
| [{ | L_SQUARE_BRACKET | 
| }] | R_SQUARE_BRACKET |
| :=: | ASSIGN |
| identifier (e.g "hello", "hello_WORLD", "asd223") | IDENT XXXX |
| number (e.g "12", "123") | NUMBER XXXX |

Was run/tested on ssh (bolt)

**How To Compile**
    1. run the command "make"
    2. *(If also running on bolt server)* make sure to run "chmod 777 mil_run", this will allow the server to execute mil_run
    3. ./parser ../programs/*any of the programs* > input.mil
    4. mil_run input.mil

If the user wishes to try out their own code, simply create a new .pan file in their desired directory and put that file after "./parser" followed by "> input.mil"


