%{
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <string.h>
#include <vector>
#include <iostream>


extern FILE* yyin;
int yyerror(const char *s);
extern int yylex(void);

char *identToken;
int numberToken;


enum Type { Integer, Array };

struct Symbol {
	std::string name;
	Type type;
};

struct Function {
	std::string name;
	std::vector<Symbol> declarations;
};

bool foundFunc = false;
int incParam = 0;
std::string elseLabelGlobal;
std::string beginLoopGlobal;
std::string endLoopGlobal;
bool breakFlag = false;
bool contFlag = false;
bool loopCheck = false;


std::vector <Function> symbol_table;

Function *get_function() {
	int last = symbol_table.size()-1;
	if(last < 0) {
		printf("***Error. Attempt to call get_function with an empty symbol table\n");
		printf("Create a 'Function' object using 'add_function_to_symbol_table' before\n");
		printf("calling 'find' or 'add_variable_to_symbol_table'");
		exit(1);
	}
	return &symbol_table[last];
}

bool findFunc(std::string &value) {
	Function f;
	for(int i = 0; i < symbol_table.size(); i++) {
		f = symbol_table.at(i);
		//printf("TESTING: %s\n", f.name);
		if(f.name == value){
			return true;
		}
	}
	return false;
}
bool find(std::string &value, Type type) {

	Function *f = get_function();
	for(int i = 0; i < f->declarations.size(); i++) {
		Symbol *s = &f->declarations[i];
		if(s->name == value && s->type == type) {
			return true;
		}
	}
	return false;
}

bool findDup(std::string &value) {
	Function *f = get_function();
	for(int i = 0; i < f->declarations.size(); i++) {
		Symbol *s = &f->declarations[i];
		if(s->name == value) {
			return true;
		}
	}
	return false;
}


void add_function_to_symbol_table(std::string &value) {
	Function f;
	f.name = value;
	symbol_table.push_back(f);
}

void add_variable_to_symbol_table(std::string &value, Type t) {
	Symbol s;
	s.name = value;
	s.type = t;
	Function *f = get_function();
	f->declarations.push_back(s);
}

std::string create_temp() {
	static int num = 1;
	std::string value = "temp" + std::to_string(num);
	num += 1;
	return value;
}

std::string decl_temp_code(std::string &temp) {
	return std::string(". ") + temp + std::string("\n");
}

std::string create_label(std::string name) {
	static int num = 1;
	std::string value = name + std::to_string(num);
	num += 1;
	return value;
}

std::string decl_label_code(std::string &label) {
	return label + std::string("\n");
}
/*for debugging */
void print_symbol_table(void) {
	printf("Symbol Table:\n");
	printf("----------------------\n");
	for(int i = 0; i < symbol_table.size(); i++) {
		printf("function: %s\n", symbol_table[i].name.c_str());
		for(int j = 0; j < symbol_table[i].declarations.size(); j++) {
			printf(" locals: %s\n", symbol_table[i].declarations[j].name.c_str());
		}
	}
	printf("----------------------\n");
}

struct CodeNode {

	std::string code;
	std::string name;
};

%}



%union {

char *op_val;
struct CodeNode *node;
}

%token <op_val>		NUMBER
%token <op_val> 	IDENT

%token INTEGER ARRAY LT NTEQLTO EQLTO GT GTEQLTO LTEQLTO WHILE IF ELSE READ WRITE FUNCTION BEGINPARAMS
%token ENDPARAMS BEGINLOCALS ENDLOCALS BEGINBODY ENDBODY OF THEN ENDIF DO BEGINLOOP ENDLOOP CONTINUE BREAK NOT
%token TRUE FALSE RETURN MODULO SEMICOLON COLON COMMA LPR RPR LSQR RSQR ASSIGN ADD SUB MULT DIV
%start prog_start
%type <op_val> ident
%type <node> compare_operator
%type <node> values_expression
%type <node> values
%type <node> term
%type <node> var
%type <node> functionIdent
%type <node> functions
%type <node> function
%type <node> arguments
%type <node> argument
%type <node> statements
%type <node> statement
%type <node> assignment
%type <node> operation
%type <node> iout
%type <node> compare
%type <node> ifelse
%type <node> else
%type <node> loop


%%
prog_start: functions 
{ 

	CodeNode *node = $1;
	std::string code = node->code;

	 printf("Generated Code:\n");
	printf("%s\n", code.c_str()); /* converts string to characters */
	Function f;
  	for(int i = 0; i < symbol_table.size(); i++) {
	f = symbol_table.at(i);
		if(f.name == "main") {
			foundFunc = true;
		}
  	}

	if(!foundFunc) {
		std::string message = std::string("function 'main' not declared");
		yyerror(message.c_str());

	}
	print_symbol_table();

}

functions: %empty
{ 
	CodeNode *node = new CodeNode;
	$$ = node;
}
| function functions 
{ 
	CodeNode *func = $1;
	CodeNode *funcs = $2;
	std::string code = func->code + funcs->code;
	CodeNode *node = new CodeNode;
	node->code = code;
	$$ = node;
	

};

function: FUNCTION ident SEMICOLON 
	BEGINPARAMS arguments ENDPARAMS 
	BEGINLOCALS arguments ENDLOCALS BEGINBODY statements ENDBODY 
{ 
	CodeNode *params = $5;
	CodeNode *locals = $8;
	CodeNode *stmts = $11;
	std::string code = "func " + std::string($2) + "\n";
	code = code + params->code + locals->code;
	if(std::string($2) != "main") {
		Function *f = get_function();
		for(int i = 0; i < f->declarations.size(); i++) {
			Symbol *s = &f->declarations[i];
			code += std::string("= ") + s->name + std::string(", ") + std::string("$") + std::to_string(i) + std::string("\n");
		}
	}
	code += stmts->code + std::string("endfunc\n"); /*adding all of the params/locals/stmts after func + func_name + /n */
    CodeNode *node = new CodeNode;
	node->code = code;
	$$ = node;
};

ident: IDENT
{
  std::string func_name = $1;
  add_function_to_symbol_table(func_name);

  $$ = $1;
};

arguments: %empty 
{ 

	CodeNode *node = new CodeNode;
	$$ = node;
}
	 
	 
| argument arguments  { 
	CodeNode *arg = $1;
	CodeNode *args = $2;
	std::string code = arg->code + args->code;
	CodeNode *node = new CodeNode;
	node->code = code;
	$$ = node;
	};

	

argument: INTEGER IDENT SEMICOLON 
{ 	
	std::string val = $2;
	Type t = Integer;
	if(findDup(val)) {
		std::string message = std::string("variable/array '") + val + std::string("' already exists");
		yyerror(message.c_str());
	}
	
	add_variable_to_symbol_table(val, t);
	std::string code =  ". " + val + "\n";
	CodeNode *node = new CodeNode;
	node->code = code;
	$$ = node;


}
| INTEGER ARRAY LSQR NUMBER RSQR IDENT SEMICOLON
{
	std::string name = $6;
	std::string num = $4;
	Type t = Array;
	if(findDup(name)) {
		std::string message = std::string("array/variable '") + name + std::string("' already exists");
		yyerror(message.c_str());
	}
	
	if(atoi($4) <= 0) {
		std::string message = std::string("cannot declare array with size <= 0");
		yyerror(message.c_str());
	}
 	add_variable_to_symbol_table(name, t);
	std::string code = ".[] " + name + ", " + num + "\n";
	CodeNode *node = new CodeNode;
	node->code = code;
	$$ = node;
		
};

statements: %empty 
{ 
	CodeNode *node = new CodeNode;
	$$ = node;


}
| statement statements
{ 

	CodeNode *statement = $1;
	CodeNode *statements = $2;

	CodeNode *node = new CodeNode;
	node->code = statement->code + statements->code;
	
	$$ = node;
};

statement: assignment  
{ 
	

	$$ = $1;
}
| loop 
{
	$$ = $1;
}
| iout 
{  
	$$ = $1;
}
| ifelse 
{ 
	$$ = $1;
}

| BREAK SEMICOLON 
{ 
	std::string endLoop = create_label(std::string("endLoop"));
	endLoopGlobal = endLoop;
	CodeNode *node = new CodeNode;
	node->code = std::string(":= ") + endLoopGlobal + std::string("\n");
	breakFlag = true;
	$$ = node;
}

| RETURN values SEMICOLON 
{ 
	
	CodeNode *node = new CodeNode;
	Function *f = get_function();
	node->code += $2->code;
	node->code += std::string("ret ") + $2->name + std::string("\n");
	
	$$ = node;
	
}
| CONTINUE SEMICOLON 
{ 
	std::string beginLoop = create_label(std::string("beginLoop"));
	beginLoopGlobal = beginLoop;
	CodeNode *node = new CodeNode;
	node->code = std::string(":= ") + beginLoopGlobal + std::string("\n");
	contFlag = true;
	$$ = node;
};





ifelse: IF compare statements else ENDIF SEMICOLON 
{ 
	
	CodeNode *node = new CodeNode;
	std::string ifTrueLabel = create_label(std::string("if_true"));
	std::string endIfLabel = create_label(std::string("end_if"));
	node->code = $2->code;
	node->code += std::string("?:= ") + ifTrueLabel + std::string(", ") + $2->name + std::string("\n");
	if($4->name == "") {
		node->code += std::string(":= ") + endIfLabel + std::string("\n");
		node->code += std::string(": ") + ifTrueLabel + std::string("\n");
		node->code += $3->code;
		node->code += std::string(": ") + endIfLabel + std::string("\n");
		$$ = node;
	}
	else {
		node->code += std::string(":= ") + elseLabelGlobal + std::string("\n");
		node->code += std::string(": ") + ifTrueLabel + std::string("\n");
		node->code += $3->code + std::string(":= ") + endIfLabel + std::string("\n");
		node->code += $4->code;
		node->code += std::string(": ") + endIfLabel + std::string("\n");
		$$ = node;
	}

}; 

else: %empty
{ 
	CodeNode *node = new CodeNode;
	node->name = "";
	$$ = node;
}
| ELSE statements 
{ 
	std::string elseLabel = create_label(std::string("else"));
	elseLabelGlobal = elseLabel;
	
	CodeNode *node = new CodeNode;
	node->code = ": " + elseLabel + std::string("\n");
	node->code += $2->code;
	node->name = "else";
	$$ = node;

};


loop: WHILE compare BEGINLOOP statements ENDLOOP 
{ 

	if(breakFlag == true) {
		std::string beginLoop = create_label(std::string("beginLoop"));
		std::string loopBody = create_label(std::string("loopbody"));

		CodeNode *node = new CodeNode;
		node->code = std::string(": ") + beginLoop + std::string("\n");
		node->code += $2->code;
		node->code += std::string("?:= ") + loopBody + std::string(", ") + $2->name + std::string("\n");
		node->code += std::string(":= ") + endLoopGlobal + std::string("\n");
		node->code += std::string(": ") + loopBody + std::string("\n");
		node->code += $4->code + std::string(":= ") + beginLoop + std::string("\n");
		node->code += std::string(": ") + endLoopGlobal + std::string("\n");
		breakFlag = false;
		$$ = node;		
	}
	else if (contFlag == true) {
		std::string loopBody = create_label(std::string("loopbody"));
		std::string endLoop = create_label(std::string("endLoop"));
		CodeNode *node = new CodeNode;
		node->code = std::string(": ") + beginLoopGlobal + std::string("\n");
		node->code += $2->code;
		node->code += std::string("?:= ") + loopBody + std::string(", ") + $2->name + std::string("\n");
		node->code += std::string(":= ") + endLoop + std::string("\n");
		node->code += std::string(": ") + loopBody + std::string("\n");
		node->code += $4->code + std::string(":= ") + beginLoopGlobal + std::string("\n");
		node->code += std::string(": ") + endLoop + std::string("\n");
		contFlag = false;
		$$ = node;			
	}
	else {
		std::string beginLoop = create_label(std::string("beginLoop"));
		std::string loopBody = create_label(std::string("loopbody"));
		std::string endLoop = create_label(std::string("endLoop"));
		CodeNode *node = new CodeNode;
		node->code = std::string(": ") + beginLoop + std::string("\n");
		node->code += $2->code;
		node->code += std::string("?:= ") + loopBody + std::string(", ") + $2->name + std::string("\n");
		node->code += std::string(":= ") + endLoop + std::string("\n");
		node->code += std::string(": ") + loopBody + std::string("\n");
		node->code += $4->code + std::string(":= ") + beginLoop + std::string("\n");
		node->code += std::string(": ") + endLoop + std::string("\n");

		$$ = node;
	}
};

compare: values compare_operator values 
{ 
	std::string temp = create_temp();
	//std::string compareOperator = $2;
	CodeNode *node = new CodeNode;
	node->code = $1->code + $3->code + decl_temp_code(temp);
	if($2->code == "<-") {
		node->code += std::string("== ") + temp + std::string(", ") + $1->name + std::string(", ") + $3->name + std::string("\n");
	}
	else if($2->code == "<<") {
		node->code += std::string("< ") + temp + std::string(", ") + $1->name + std::string(", ") + $3->name + std::string("\n");
	}
	else if($2->code == "?<-") {
		node->code += std::string("!= ") + temp + std::string(", ") + $1->name + std::string(", ") + $3->name + std::string("\n");
	}
	else if($2->code == ">>") {
		node->code += std::string("> ") + temp + std::string(", ") + $1->name + std::string(", ") + $3->name + std::string("\n");
	}
	else if($2->code == ">><-") {
		node->code += std::string(">= ") + temp + std::string(", ") + $1->name + std::string(", ") + $3->name + std::string("\n");
	}
	else if($2->code == "<<<-") {
		node->code += std::string("<= ") + temp + std::string(", ") + $1->name + std::string(", ") + $3->name + std::string("\n");
	}
	node->name = temp;
	$$ = node;
 }
       | TRUE { printf("compare -> TRUE\n"); }
       | FALSE { printf("compare -> FALSE\n"); }
       ;

compare_operator: EQLTO 
{ 
	CodeNode *node = new CodeNode;
	node->code = "<-";
	$$ = node;
}
| LT 
{ 
	CodeNode *node = new CodeNode;
	node->code = "<<";
	$$ = node;
}
| NTEQLTO 
{ 
	CodeNode *node = new CodeNode;
	node->code = "?<-";
	$$ = node;
}
| GT 
{ 
	CodeNode *node = new CodeNode;
	node->code = ">>";
	$$ = node;
}
| GTEQLTO 
{ 
	CodeNode *node = new CodeNode;
	node->code = ">><-";
	$$ = node;
}
| LTEQLTO 
{ 
	CodeNode *node = new CodeNode;
	node->code = "<<<-";
	$$ = node;
};
 
assignment: 
IDENT ASSIGN values SEMICOLON 
{ 

		std::string ident = $1;
		if(!find(ident, Integer)) {
			std::string message = std::string("unidentified symbol '") + ident + std::string("'");
			yyerror(message.c_str());
		}

		CodeNode *node = new CodeNode;
		node->code = $3->code;
		node->code += std::string("= ") + ident + std::string(", ") + $3->name + std::string("\n");
		$$ = node;

}
| IDENT LSQR values RSQR ASSIGN values SEMICOLON 
{ 

	std::string ident = $1;
	if(!find(ident, Array)) {
		std::string message = std::string("unidentified symbol '") + ident + std::string("'");
		yyerror(message.c_str());
	}
	CodeNode *node = new CodeNode;
	node->code = $3->code + $6->code;
	node->code += std::string("[]= ") + std::string($1) + std::string(", ") + $3->name + std::string(", ") + $6->name + std::string("\n");
	$$ = node;

};

iout: WRITE LPR values RPR SEMICOLON { 
	
	CodeNode* node = new CodeNode;
	CodeNode* values = $3;
	node->code = ".> " + values->name + "\n";
	$$ = node;
 }
    | READ LPR values RPR SEMICOLON {

	CodeNode* node = new CodeNode;
	CodeNode* values = $3;
	node->code = ".< " + values->name + "\n";
	$$ = node;
}
| WRITE LPR IDENT LSQR NUMBER RSQR RPR SEMICOLON{
	CodeNode* node = new CodeNode;
	std::string ident = $3;
	std::string index = $5;
	node->code = ".[]> " + ident + ", " + index + "\n";
	$$ = node;
}
| READ LPR IDENT LSQR NUMBER RSQR RPR SEMICOLON{
	CodeNode* node = new CodeNode;
	std::string ident = $3;
	std::string index = $5;
	node->code = ".[]< " + ident + ", " + index + "\n";
	$$ = node;
};


values: values_expression {
	$$ = $1;
}
| values_expression ADD values {
		std::string temp = create_temp(); 
	CodeNode *node = new CodeNode;

	node->code = $1->code + $3->code +  decl_temp_code(temp);
	node->code += std::string("+ ") + temp + std::string(", ") + $1->name + std::string(", ") + $3->name + std::string("\n");

	node->name = temp;
	$$ = node;

}
| values_expression SUB values {
	std::string temp = create_temp();
	CodeNode *node = new CodeNode;	

	node->code = $1->code + $3->code +  decl_temp_code(temp);
	node->code += std::string("- ") + temp + std::string(", ") + $1->name + std::string(", ") + $3->name + std::string("\n");

	node->name = temp;
	$$ = node;

};


term: var { 

	CodeNode *node = new CodeNode;
	node->code = $1->code;
	node->name = $1->name;
	$$ = node;
	

}
| NUMBER {

	CodeNode *node = new CodeNode;
	node->name = $1;
	$$ = node;

} 
| LPR values RPR {
	CodeNode *node = new CodeNode;
	node->code = $2->code;
	node->name = $2->name;
	$$ = node;
}
| IDENT LPR functionIdent RPR { 

	std::string temp = create_temp();
	std::string ident = $1;
	if(!findFunc(ident)) {
		std::string message = std::string("unidentified function '") + ident + std::string("'");
		yyerror(message.c_str());
	}
	CodeNode *node = new CodeNode;
	node->code = $3->code + decl_temp_code(temp);
	node->code += std::string("call ") + ident + std::string(", ") + temp + std::string("\n");
	node->name = temp;
	$$ = node;

};


var: IDENT {
	CodeNode *node = new CodeNode;
	node->code = "";
	node->name = $1;
	std::string ident = $1;
	if(!find(ident, Integer )) {
		std::string message = std::string("unidentified symbol '") + ident + std::string("'");
		yyerror(message.c_str());
	}
	$$ = node;
}
| IDENT LSQR values RSQR {

	std::string temp = create_temp();
	CodeNode *node = new CodeNode;
	node->code = $3->code + decl_temp_code(temp);
	node->code += std::string("=[] ") + temp + std::string(", ") + std::string($1) + std::string(", ") + $3->name + std::string("\n");
	node->name = temp;
	std::string ident = $1;
	if(!find(ident, Array)) {
		std::string message = std::string("unidentified array variable '") + ident + std::string("'");
		yyerror(message.c_str());
	}
	
	$$ = node;
};


functionIdent: %empty {
	CodeNode *node = new CodeNode;
	$$ = node;
}
| values  {

	CodeNode *node = new CodeNode;


	node->code += $1->code;
	node->code += std::string("param ") + $1->name + std::string("\n");
	$$ = node;

}
| values COMMA functionIdent {
	CodeNode *node = new CodeNode;

	node->code = $1->code + $3->code; 
	node->code += std::string("param ") + $1->name + std::string("\n");
	$$ = node;
};

values_expression: term {

	$$ = $1;
}

| term operation term
{ 
	std::string temp = create_temp();
	CodeNode *node = new CodeNode;
	node->code = $1->code + $3->code +  decl_temp_code(temp);
	node->code += $2->code + std::string(" ") + temp + std::string(", ") + $1->name + std::string(", ") + $3->name + std::string("\n");

	node->name = temp;
	$$ = node;
};


operation: MULT { 
	 		CodeNode *node = new CodeNode;
		node->code = "*";
		$$ = node;	 }
	 | DIV { 
	 		CodeNode *node = new CodeNode;
		node->code = "/";
		$$ = node;	  }
	 | MODULO { 
	 		CodeNode *node = new CodeNode;
		node->code = "%";
		$$ = node;	  };





%%

int yyerror(const char *string)
{	extern int line;
	extern int pos;
	extern char *yytext;
	printf("** Line %d: %s\n", line, string);
	exit(1); 	
}


int yywrap() { return 1; }

int main (int argc, char** argv) 
{
	if(argc >= 2) {
		yyin = fopen(argv[1], "r");
		if(yyin == NULL)
			yyin = stdin;
	}
	else {
		yyin = stdin;
	}
	yyparse();
}



