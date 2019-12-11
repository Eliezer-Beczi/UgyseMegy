%{
#include <iostream>
#include <unordered_map>
#include <utility> 
#include <vector> 
using namespace std;

int yyerror(const char*);
extern int yylex();
extern int poz[];
typedef unordered_map<string,int> scope;
vector<scope> symbolTable(1);
int getVar(char* id){	
	
	for( vector<scope>::reverse_iterator iter = symbolTable.rbegin();iter != symbolTable.rend();++iter){
		if((*iter).find(string(id)) != (*iter).end()){						
			return (*iter)[string(id)];
		}	
	} 	
	string errorMessage = "Dezső, elrontottad, miért nem deklaráltál ilyen változót "+string(id);
	yyerror(errorMessage.c_str());		
}
%}

%define parse.error verbose
%union {
  int ival;
  float fval;
  double dval;
  char* str;
}
%start START
%token<ival> INTNUMBER
%token<dval> DOUBLENUMBER
%token <str> STR

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
%token<str> VARIABLE_ID
%token GLOBAL_MODIFIER
%token PIPE
%token DOUBLECOMMA
%token TILDA


%left  PLUS MINUS 
%left  MULTIPLY DIVIDE

%left  OR AND
%type<dval> EXPRESSION
%type<ival> VARIABLE_TYPE
%type<ival> VARIABLE_EVAL
%%

START: 
	PROG 
	| // empty
;

PROG:
	  COMMAND END
	| PROG  COMMAND END
	| IFBLOCK
	| WHILEBLOCK	
	| PROG IFBLOCK 
	| PROG WHILEBLOCK
	| error	
; 

COMMAND:  EXPRESSION { }
		| DECLARATION
		| VARIABLE_ASSIGNMENT 
		| READ_VARIABLE
		| PRINT_VARIABLE
;

push: {scope map;symbolTable.push_back(map);};
pop:{symbolTable.pop_back();}

IFBLOCK: IF L_BOX BOOLEXPRESSION R_BOX  push L_ANGLE PROG  R_ANGLE 		pop
		|IF L_BOX BOOLEXPRESSION R_BOX  push L_ANGLE  PROG  L_ANGLE  pop push R_ANGLE   PROG  R_ANGLE pop
;

WHILEBLOCK:   WHILE L_BOX BOOLEXPRESSION R_BOX L_ANGLE  push PROG pop R_ANGLE			
;


EQUALITY: EXPRESSION EQUAL EXPRESSION
;
NOTEQUALITY: EXPRESSION NOT_EQUAL EXPRESSION
;

SMALLER: EXPRESSION L_ANGLE EXPRESSION
;
BIGGER: EXPRESSION R_ANGLE EXPRESSION
;

BOOLEXPRESSION:  EQUALITY
		|  NOTEQUALITY
		|  SMALLER
		|  BIGGER
		|  BOOLEXPRESSION OR BOOLEXPRESSION
		|  BOOLEXPRESSION AND BOOLEXPRESSION
		|  L_ROUND BOOLEXPRESSION R_ROUND
		|  NOT L_ROUND BOOLEXPRESSION R_ROUND
		|  error
;

EXPRESSION: VARIABLE_EVAL {$$ = DOUBLENUMBER;}
	| INTNUMBER {$$ = INTNUMBER;}
	| DOUBLENUMBER {$$ = DOUBLENUMBER;}
	| EXPRESSION  PLUS EXPRESSION { ( $1 == DOUBLENUMBER || $3 == DOUBLENUMBER )?$$ = DOUBLENUMBER:$$ = INTNUMBER;}
	| EXPRESSION  MINUS EXPRESSION { ( $1 == DOUBLENUMBER || $3 == DOUBLENUMBER )?$$ = DOUBLENUMBER:$$ = INTNUMBER;}
	| EXPRESSION  MULTIPLY EXPRESSION { ( $1 == DOUBLENUMBER || $3 == DOUBLENUMBER )?$$ = DOUBLENUMBER:$$ = INTNUMBER;}
	| EXPRESSION  DIVIDE EXPRESSION { ( $1 == DOUBLENUMBER || $3 == DOUBLENUMBER )?$$ = DOUBLENUMBER:$$ = INTNUMBER;}
	| PLUS EXPRESSION {$$ =  $2;}
	| MINUS EXPRESSION {$$ = $2;}
	| L_ROUND EXPRESSION R_ROUND { $$ = $2;}
;

VARIABLE_TYPE:  INTEGER_TYPE { $$ = INTNUMBER;}
			  | DOUBLE_TYPE {$$ = DOUBLENUMBER;}
;

VARIABLE_EVAL:	VARIABLE_ID { $$ = getVar($1);}
			|	VARIABLE_ID TILDA VARIABLE_TYPE {
												int typevar  = getVar($1); 
												int tocast = $3; 
												if(typevar == INTNUMBER && tocast == DOUBLENUMBER) {
													string errorMessage = "Dezső, elrontottad, nem lehet egeszt valosra castolni ";
													yyerror(errorMessage.c_str());
												}
												cout<<"Dezső, most aztán megcsináltad, kasztoltál mint az indiaiak."<<endl;
												}
;

ACCESS_MODIFIER:  GLOBAL_MODIFIER
				| /* epsilon */
;			

DECLARATION:  ACCESS_MODIFIER DOUBLECOMMA VARIABLE_ID L_ANGLE VARIABLE_TYPE	 
				{
					if(symbolTable.back().find(string($3)) == symbolTable.back().end()){
						symbolTable.back().insert({string($3),$5});
					}else{
						string errorMessage = "Dezső, elrontottad, már deklaráltál egy ilyen változót: "+string($3);
						yyerror(errorMessage.c_str());
					}
				}
			| ACCESS_MODIFIER DOUBLECOMMA VARIABLE_ID PIPE VARIABLE_TYPE			
;


VARIABLE_ASSIGNMENT: VARIABLE_ID ASSIGNMENT EXPRESSION { 
	if(getVar($1) == INTNUMBER && $3 == DOUBLENUMBER){
		string errorMessage = "Dezső, nem lehet ilyen erteket adni";
						yyerror(errorMessage.c_str());
	}	
	}
;

READ_VARIABLE: READ VARIABLE_ID
;

PRINT_VARIABLE: PRINT VARIABLE_ID
;

%%

int main() {
	yyparse();    
}

int yyerror(const char* s) {
	cout << "Line: " <<poz[0]<<" Col: "<<poz[1]<<" Len: "<<poz[2] << endl;
	cout<< s<<endl;
}
