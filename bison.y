%{
#include <iostream>
using namespace std;

int yyerror(const char*);
extern int yylex();
%}

%union {
  int ival;
  float fval;
  double dval;
  char* str;
}

%start s
%token<ival> INTNUMBER
%token<ival> DOUBLENUMBER

%token PLUS
%token MINUS
%token MULTIPLY
%token DIVIDE


%token <ival> INT
%token <fval> FLOAT
%token <fval> DOUBLE
%token <str> STR

%left  PLUS MINUS 
%left  MULTIPLY DIVIDE

%type<ival> KIF
%token IF
%token BRACK

%%

s:  KIF { std::cout<<"Result:"<<$1<<endl;}
	| IFBLOCK
	| s ';' KIF 
	| s ';' IFBLOCK
	| // empty
;

IFBLOCK: IF BRACK KIF BRACK
;
KIF: INTNUMBER {$$ = $1;}	
	| KIF  PLUS KIF {$$ = $1 + $3;}
	| KIF  MINUS KIF {$$ = $1 - $3;}
	| KIF  MULTIPLY KIF {$$ = $1 * $3;}
	| KIF  DIVIDE KIF {$$ = $1 / $3;}
;

%%

int main() {
	yyparse();    
}

int yyerror(const char* s) {
	cout << s << endl;
}
