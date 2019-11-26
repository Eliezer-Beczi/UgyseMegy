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
%token ASSIGNMENT

%token L_BOX
%token R_BOX
%token L_ROUND
%token R_ROUND
%token L_CURLY
%token R_CURLY
%token L_ANGLE
%token R_ANGLE

%token EQUAL
%token NOT_EQUAL
%token AND
%token OR
%token NOT

%token END

%token READ
%token PRINT

%token IF
%token ELSE
%token WHILE

%token INTEGER_TYPE
%token DOUBLE_TYPE
%token VARIABLE_ID

%token <ival> INT
%token <fval> FLOAT
%token <fval> DOUBLE
%token <str> STR

%left  PLUS MINUS 
%left  MULTIPLY DIVIDE

%type<ival> KIF

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
