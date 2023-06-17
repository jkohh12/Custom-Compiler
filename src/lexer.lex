%{
#include "y.tab.h"
#include <string.h>
int line = 1;
int pos = 1;
int yyerror(const char *s); 
extern char *identToken;
extern int numberToken;
%}

ID		[a-z][a-zA-Z0-9_]*
DIGIT		[0-9]


/*beginning of rules below */

%%
"i"			{ pos+=yyleng; return INTEGER;}
"arr"			{ pos+=yyleng; return ARRAY; }
"<-"			{ pos+=yyleng; return EQLTO; }
"<<"			{ pos+=yyleng; return LT; }
"?<-"			{ pos+=yyleng; return NTEQLTO; }
">>"			{ pos+=yyleng; return GT; }
">><-"			{ pos+=yyleng; return GTEQLTO; }
"<<<-"			{ pos+=yyleng; return LTEQLTO; }
"during"		{ pos+=yyleng; return WHILE; }
"whether"		{ pos+=yyleng; return IF; }
"or"			{ pos+=yyleng; return ELSE; }
"input>"		{ pos+=yyleng; return READ; }
"output<"		{ pos+=yyleng; return WRITE; }
"task"			{ pos+=yyleng; return FUNCTION; }
"startparams"		{ pos+=yyleng; return BEGINPARAMS; }
"finishparams"		{ pos+=yyleng; return ENDPARAMS; }
"startlocals"		{ pos+=yyleng; return BEGINLOCALS; }
"finishlocals"		{ pos+=yyleng; return ENDLOCALS;}
"startbody"		{ pos+=yyleng; return BEGINBODY;}
"finishbody"		{ pos+=yyleng; return ENDBODY; }
"about"			{ pos+=yyleng; return OF; }
"after"			{ pos+=yyleng; return THEN; }
"endw"			{ pos+=yyleng; return ENDIF; }
"act"			{ pos+=yyleng; return DO; }
"startloop"		{ pos+=yyleng; return BEGINLOOP; }
"finishloop"		{ pos+=yyleng; return ENDLOOP; }
"resume"		{ pos+=yyleng; return CONTINUE; }
"pause"			{ pos+=yyleng; return BREAK; }
"negate" 		{ pos+=yyleng; return NOT; }
"true"			{ pos+=yyleng; return TRUE; }
"false"			{ pos+=yyleng; return FALSE; }
"rebound"		{ pos+=yyleng; return RETURN; }
"%"			{ pos+=yyleng; return MODULO; }

";"			{ pos+=yyleng; return SEMICOLON; }
":"			{ pos+=yyleng; return COLON; }
","			{ pos+=yyleng; return COMMA; }
"{"			{ pos+=yyleng; return LPR; }
"}"			{ pos+=yyleng; return RPR; }
"[{"			{ pos+=yyleng; return LSQR; }
"}]"			{ pos+=yyleng; return RSQR; }
":=:"			{ pos+=yyleng; 	return ASSIGN; }

{ID}			{
	pos+=yyleng; 
	char * token = new char[yyleng];
	strcpy(token, yytext);
	yylval.op_val = token;
	identToken = yytext;
	return IDENT;
	
}

{DIGIT}+		{ 
	pos+=yyleng; 
	char * token = new char[yyleng];
	strcpy(token, yytext);
	yylval.op_val = token;
	numberToken = atoi(yytext);
	return NUMBER; 

}
[ ]+		{ pos+=yyleng; } /*white space*/
[\t]	{ pos+=yyleng; } /*tab*/


"+"       { pos += yyleng; return ADD; }
"-"       { pos += yyleng; return SUB; }
"*"       { pos += yyleng; return MULT; }
"/"       { pos += yyleng; return DIV; }

"..."[^}\n]*"..."	{ pos += yyleng; }

"\n"      {line++; pos = 1;}

[A-Z0-9_][_a-zA-Z0-9]* {printf("ERROR: Identifier must start with a lowercase letter, on line %d \n", line);}


.		{ printf("Error location: %d:%d Unrecognized symbol gang\"%s\"\n", line, pos, yytext); }

%%


