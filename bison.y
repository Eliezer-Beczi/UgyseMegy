%{
#include <iostream>
using namespace std;

int yyerror(const char*);
extern int yylex();
%}

%union {
  int ival;
  float fval;
  char* str;
}

%start s
%token<ival> INTNUMBER
%token DOUBLENUMBER
%token PLUS
%token MINUS
%token MULTIPLY
%token DIVIDE


%token <ival> INT
%token <fval> FLOAT
%token <str> STR

%left  PLUS MINUS 
%left  MULTIPLY DIVIDE

%type<ival> KIF

%%

s:  KIF { std::cout<<"Result:"<<$1<<endl;}
	| // empty
;

KIF: INTNUMBER {$$ = $1;}
	| INTNUMBER PLUS INTNUMBER {$$ = $1 + $3;}
	| INTNUMBER MINUS INTNUMBER {$$ = $1 - $3;}
	| INTNUMBER MULTIPLY INTNUMBER {$$ = $1 * $3;}
	| INTNUMBER DIVIDE INTNUMBER {$$ = $1 / $3;}

	| KIF  PLUS INTNUMBER {$$ = $1 + $3;}
	| KIF  MINUS INTNUMBER {$$ = $1 - $3;}
	| KIF  MULTIPLY INTNUMBER {$$ = $1 * $3;}
	| KIF  DIVIDE INTNUMBER {$$ = $1 / $3;}
;

%%

int main() {
	yyparse();    
}

int yyerror(const char* s) {
	cout << s << endl;
}
