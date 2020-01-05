%{
#include <iostream>
#include <unordered_map>
#include <utility> 
#include <vector> 
#include "ugysemegytocpp.h"

using namespace std;

int yyerror(const char*);
extern int yylex();
extern int poz[];

struct ugysemegyVar{
	int type;
	bool array;	
	string id;
	string buffer;
};

struct expression{
	string buffer;
	int type;
};
typedef unordered_map<string,ugysemegyVar> scope;
vector<scope> symbolTable(1);
vector<expression*> expressions;
vector<ugysemegyVar*> vars;

void printErr(std::string message){
	yyerror(message.c_str());
}
ugysemegyVar& getVar(string id){
	
	for( vector<scope>::reverse_iterator iter = symbolTable.rbegin();iter != symbolTable.rend();++iter){
		if((*iter).find(id) != (*iter).end()){						
			return (*iter)[id];
		}	
	} 	
	printErr("Dezső, elrontottad, miért nem deklaráltál ilyen változót "+id);	
}
void freeExpressions(){
	for(int i=0;i<expressions.size();++i){
		delete expressions[i];
	}
}
void freeVars(){
	for(int i=0;i<vars.size();++i){
		delete vars[i];
	}
}
expression* getExpression(){
	expression* expr=new expression;
	expressions.push_back(expr);
	return expr;
}
%}

%define parse.error verbose
%union {
  int ival;
  float fval;
  double dval;
  char* str;    
  struct ugysemegyVar* uVar;
  bool boolean;
  struct expression* expr;
}
%start START
%token<str> INTNUMBER
%token<str> DOUBLENUMBER
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
%type<expr> EXPRESSION
%type<expr> BOOLEXPRESSION
%type<expr> EQUALITY
%type<expr> NOTEQUALITY
%type<expr> BIGGER
%type<expr> SMALLER
%type<ival> VARIABLE_TYPE
%type<expr> VARIABLE_EVAL
%type<uVar> VARIABLE
%type<expr> INDEXING
%token NOT_INDEXED;
%%

START: 
	{writeMain();}PROG {writeEnd(); freeExpressions();freeVars();}
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

COMMAND:  EXPRESSION {dot();} 
		| DECLARATION {dot();} 
		| VARIABLE_ASSIGNMENT {dot();} 
		| READ_VARIABLE {dot();} 
		| PRINT_VARIABLE {dot();} 
		| VARIABLE_SWAP {dot();} 
;

push: {scope map;symbolTable.push_back(map);};
pop:{symbolTable.pop_back();};
openIf: IF L_BOX {openIf();};
continueIf:L_ANGLE {openBlock();} PROG {closeBlock();};
captureExpression: BOOLEXPRESSION  R_BOX {writeExpression($1->buffer);};
IFBLOCK: openIf  captureExpression  push continueIf  R_ANGLE 		pop
		|openIf  captureExpression  push continueIf  L_ANGLE  pop push R_ANGLE {writeElse();} PROG {closeBlock();} R_ANGLE pop
;

WHILEBLOCK:   WHILE {openWhile();} L_BOX BOOLEXPRESSION {writeExpression($4->buffer);} R_BOX {openBlock();}L_ANGLE  push PROG pop R_ANGLE {closeBlock();}			
;


EQUALITY:  EXPRESSION  EQUAL  EXPRESSION {expression* expr = getExpression(); expr->buffer =  $1->buffer+getEquals()+$3->buffer; $$ = expr;}
;

NOTEQUALITY: EXPRESSION NOT_EQUAL  EXPRESSION {expression* expr = getExpression(); expr->buffer = $1->buffer+getNotEquals()+$3->buffer;$$ = expr; }
;

SMALLER: EXPRESSION L_ANGLE  EXPRESSION {expression* expr = getExpression(); expr->buffer = $1->buffer+getLessThan()+$3->buffer; $$ = expr;}
;

BIGGER: EXPRESSION R_ANGLE  EXPRESSION {expression* expr = getExpression(); expr->buffer = $1->buffer+getGreaterThan()+$3->buffer;$$ = expr; }
;

BOOLEXPRESSION:   EQUALITY  { $$ = $1;}
		|  NOTEQUALITY { $$ = $1;}
		|  SMALLER { $$ = $1;}
		|  BIGGER { $$ = $1;}
		|  BOOLEXPRESSION OR BOOLEXPRESSION { expression* expr = getExpression(); expr->buffer = $1->buffer + getOr() + $3->buffer; $$ = expr; }
		|  BOOLEXPRESSION AND  BOOLEXPRESSION { expression* expr = getExpression(); expr->buffer = $1->buffer + getAnd() + $3->buffer; $$ = expr;}
		|  L_ROUND   BOOLEXPRESSION R_ROUND  { expression* expr = getExpression(); expr->buffer = "(" + $2->buffer+ ")"; $$ = expr;}
		|  NOT  L_ROUND  BOOLEXPRESSION R_ROUND { expression* expr = getExpression(); expr->buffer = getNot()+"(" + $3->buffer+ ")"; $$ = expr;}
		|  error { expression* expr = getExpression(); expr->buffer = "error";$$ = expr;}
;

EXPRESSION: VARIABLE_EVAL {  $$ = $1;}
	| INTNUMBER { expression* expr = getExpression(); expr->type =  INTNUMBER; expr->buffer = string($1); $$ = expr;}
	| DOUBLENUMBER { expression* expr = getExpression(); expr->type =  DOUBLENUMBER; expr->buffer = string($1); $$ = expr;}
	| EXPRESSION  PLUS EXPRESSION { expression* expr = getExpression(); 
									( $1->type == DOUBLENUMBER || $3->type == DOUBLENUMBER )?expr->type = DOUBLENUMBER:expr->type = INTNUMBER; 
									expr->buffer = $1->buffer + " + " + $3->buffer;
									$$ = expr;}
	| EXPRESSION  MINUS EXPRESSION { expression* expr = getExpression(); 
									( $1->type == DOUBLENUMBER || $3->type == DOUBLENUMBER )?expr->type = DOUBLENUMBER:expr->type = INTNUMBER; 
									expr->buffer = $1->buffer + " - " + $3->buffer;
									$$ = expr;}
	| EXPRESSION  MULTIPLY EXPRESSION { expression* expr = getExpression(); 
									( $1->type == DOUBLENUMBER || $3->type == DOUBLENUMBER )?expr->type = DOUBLENUMBER:expr->type = INTNUMBER; 
									expr->buffer = $1->buffer + " * " + $3->buffer;
									$$ = expr;}
	| EXPRESSION  DIVIDE EXPRESSION { expression* expr = getExpression(); 
									( $1->type == DOUBLENUMBER || $3->type == DOUBLENUMBER )?expr->type = DOUBLENUMBER:expr->type = INTNUMBER; 
									expr->buffer = $1->buffer + " / " + $3->buffer;
									$$ = expr;}
	| PLUS EXPRESSION { expression* expr = getExpression(); 
									( $2->type == DOUBLENUMBER )?expr->type = DOUBLENUMBER:expr->type = INTNUMBER; 
									expr->buffer =  " + " + $2->buffer;
									$$ = expr;}
	| MINUS EXPRESSION { expression* expr = getExpression(); 
									( $2->type == DOUBLENUMBER )?expr->type = DOUBLENUMBER:expr->type = INTNUMBER; 
									expr->buffer =  " - " + $2->buffer;
									$$ = expr;}
	| L_ROUND  EXPRESSION R_ROUND  { expression* expr = getExpression();  expr = $2; expr->buffer = "("+expr->buffer+")"; $$ = expr;}
	|   VARIABLE_TYPE TILDA L_ROUND  EXPRESSION R_ROUND  {
												int typevar  = $4->type; 
												int tocast = $1; 
												if(typevar == INTNUMBER && tocast == DOUBLENUMBER) {
													printErr("Dezső, elrontottad, nem lehet egeszt valosra castolni ");													
												}
												cout<<"Dezső, most aztán megcsináltad, kasztoltál mint az indiaiak."<<endl;
												expression* expr = getExpression(); 
												expr->type = tocast;
												if(tocast == INTNUMBER) {
													expr->buffer= "(int)";
												}
												if(tocast == DOUBLENUMBER){
													expr->buffer= "(double)";
												}
												expr->buffer+="("+$4->buffer+")";
												$$ = expr;
												}
;

VARIABLE_TYPE:  INTEGER_TYPE { $$ = INTNUMBER;}
			  | DOUBLE_TYPE {$$ = DOUBLENUMBER;}
;
INDEXING:   PIPE  EXPRESSION PIPE {
				if($2->type != INTNUMBER){
					printErr("Csakis egesz szammal lehet indexelni!");
				}
				$$ = $2;
				}
			| /* epsilon*/ {
				expression* expr = getExpression(); 
				expr->type = NOT_INDEXED;
				$$ = expr;
			}
;
VARIABLE: INDEXING VARIABLE_ID  {
	ugysemegyVar* var = new ugysemegyVar;
	*var=getVar(string($2));
	
	if ( (var->array && $1->type == NOT_INDEXED ) ||  (!var->array && $1->type != NOT_INDEXED)){
		printErr("Helytelen indexeles!");
	}

	if($1->type != NOT_INDEXED){			
		var->id = var->id+"["+$1->buffer+"]";				
		if(getVar(string($2)).array){
			var->array = false;
		}
	}	
	vars.push_back(var);
	$$ = var;	
}
;
VARIABLE_EVAL:	VARIABLE { expression* expr = getExpression();  expr->type = $1->type; expr->buffer = $1->id;$$ =expr;} 			
;

ACCESS_MODIFIER:  GLOBAL_MODIFIER
				| /* epsilon */
;			

DECLARATION:  ACCESS_MODIFIER DOUBLECOMMA VARIABLE_ID DOUBLECOMMA VARIABLE_TYPE	 
				{
					if(symbolTable.back().find(string($3)) == symbolTable.back().end()){												
						ugysemegyVar var;
						var.type = $5;
						var.array = false;
						var.id = string($3);
						symbolTable.back().insert({string($3),var});
						if($5 == INTNUMBER){
							declareInt(string($3));
						}else{
							declareDouble(string($3));
						}
					}else{
						printErr("Dezső, elrontottad, már deklaráltál egy ilyen változót: "+string($3));						
					}
				}
			| ACCESS_MODIFIER DOUBLECOMMA VARIABLE_ID DOUBLECOMMA VARIABLE_TYPE DOUBLECOMMA  EXPRESSION 
			  {
				  			if($7->type != INTNUMBER){
										printErr("Tomb merete egesz kell legyen!");
							}						
							if(symbolTable.back().find(string($3)) == symbolTable.back().end()){									
									ugysemegyVar var;						
									var.type = $5;
									var.array = true;
									var.id = string($3);
									symbolTable.back().insert({string($3),var});

									if($5 == INTNUMBER){
										declareIntArray(string($3),$7->buffer);
									}else{
										declareDoubleArray(string($3),$7->buffer);
									}												
								}else{
									printErr("Dezső, elrontottad, már deklaráltál egy ilyen változót: "+string($3));
								}
			  } 		
			| ACCESS_MODIFIER DOUBLECOMMA VARIABLE_ID DOUBLECOMMA VARIABLE_TYPE DOUBLECOMMA  EXPRESSION  DOUBLECOMMA  EXPRESSION
			  {
				  			if($7->type != INTNUMBER){
										printErr("Tomb merete egesz kell legyen!");
							}						
							if(symbolTable.back().find(string($3)) == symbolTable.back().end()){									
									ugysemegyVar var;						
									var.type = $5;
									var.array = true;
									var.id = string($3);
									symbolTable.back().insert({string($3),var});

									if($5 == INTNUMBER){
										declareIntArrayWithDefValue(string($3),$7->buffer,$9->buffer);
									}else{
										declareDoubleArrayWithDefValue(string($3),$7->buffer,$9->buffer);
									}												
								}else{
									printErr("Dezső, elrontottad, már deklaráltál egy ilyen változót: "+string($3));
								}
			  } 							
;

VARIABLE_SWAP: VARIABLE L_ANGLE MINUS R_ANGLE VARIABLE {
	if($1->type != $5->type ||  $1->array != $5->array){
		printErr("Csere azonos tipusu valtozok kozott tortenhet");
	}
	string type = $1->type == INTNUMBER ? "int":"double";
	swap($1->id,$5->id,type,$1->array);
}
;

VARIABLE_ASSIGNMENT:VARIABLE 					
					ASSIGNMENT EXPRESSION { 
										if($1->type == INTNUMBER && $3->type == DOUBLENUMBER){
											printErr("Dezső, nem lehet ilyen erteket adni");	
										}	
										writeAssignment($1->id,$3->buffer);																												  
					}
;

READ_VARIABLE: READ VARIABLE_ID {
					ugysemegyVar* var = &getVar(string($2)); 
					if(var->array){
						printErr("Kerlek mondd meg hany elemet szeretnel olvasni !");
					}
					readVar(string($2));
				}
				| READ VARIABLE_ID DOUBLECOMMA EXPRESSION {
					if($4->type !=INTNUMBER ){
						printErr("Csak egesz szamokkal lehet indexelni!");
					}
					ugysemegyVar* var = &getVar(string($2)); 
					if(!var->array){
						printErr(var->id+" nem tomb tipusu");
					}
					readArray(var->id,$4->buffer);
				}
;

PRINT_VARIABLE: PRINT VARIABLE_ID DOUBLECOMMA EXPRESSION MINUS R_ANGLE EXPRESSION {
								ugysemegyVar* var = &getVar(string($2)); 
								if( !var->array ) {
									printErr(var->id+" nem tomb tipusu");
								}
						rangePrint(var->id,$4->buffer,$7->buffer);
				}
				|PRINT VARIABLE_ID DOUBLECOMMA EXPRESSION ASSIGNMENT R_ANGLE EXPRESSION {
								ugysemegyVar* var = &getVar(string($2)); 
								if( !var->array ) {
									printErr(var->id+" nem tomb tipusu");
								}
						rangePrintEq(var->id,$4->buffer,$7->buffer);
				}
				| PRINT DOUBLECOMMA EXPRESSION {
								printExpression($3->buffer);
				}
;

%%

int main() {
	yyparse();    
}

int yyerror(const char* s) {
	cout << "Line: " <<poz[0]<<" Col: "<<poz[1]<<" Len: "<<poz[2] << endl;
	cout<< s<<endl;
}

