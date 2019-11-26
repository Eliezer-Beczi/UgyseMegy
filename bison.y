%{
#include <iostream>
using namespace std;

int yyerror(const char*);
extern int yylex();
extern int poz[];
%}

%union {
  int ival;
  float fval;
  double dval;
  char* str;
}

%start START
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

%left  OR AND


%type<ival> KIF

%%

START: 
	PROG 
	| // empty
;

PROG:
	UTASITAS END
	| PROG  UTASITAS END
	| IFBLOCK
	| WHILEBLOCK	
;

UTASITAS: KIF { cout<<$1;}
;

IFBLOCK: IF L_BOX BOOLKIF R_BOX L_ANGLE PROG R_ANGLE
		|IF L_BOX BOOLKIF R_BOX L_ANGLE PROG R_ANGLE ELSE L_ANGLE PROG R_ANGLE
;

WHILEBLOCK: WHILE L_BOX BOOLKIF R_BOX L_ANGLE PROG R_ANGLE
;

EQUALITY: KIF EQUAL KIF
;

NOTEQUALITY: KIF NOT_EQUAL KIF
;

BOOLKIF: EQUALITY 
		| NOTEQUALITY 
		| BOOLKIF OR BOOLKIF
		| BOOLKIF AND BOOLKIF
		| L_ROUND BOOLKIF R_ROUND
;

KIF: INTNUMBER {$$ = $1;}	
	| KIF  PLUS KIF {$$ = $1 + $3;}
	| KIF  MINUS KIF {$$ = $1 - $3;}
	| KIF  MULTIPLY KIF {$$ = $1 * $3;}
	| KIF  DIVIDE KIF {$$ = $1 / $3;}
	| L_ROUND KIF R_ROUND { $$ = $2;}
;

%%

int main() {
	yyparse();    
}

int yyerror(const char* s) {
	cout << "Line: " <<poz[0]<<" Col: "<<poz[1]<<" Len: "<<poz[2] << endl;
	cout<< s<<endl;
}
