all:
	bison -v -d --file-prefix=y lexer.y
	flex lexer.lex
	g++ -std=c++0x -o parser lex.yy.c y.tab.c -lfl

clean:
	rm -f parser lexer lex.yy.c y.tab.c y.tab.h y.output
