%{
#include <iostream>

#include "bison.tab.h"

using namespace std;
%}

%option noyywrap

DIGIT [0-9]
ID    [a-zA-Z][a-zA-Z0-9]*

%%

"+" { return PLUS; }  
"-" { return MINUS; }
"*" { return MULTIPLY; }
"/" { return DIVIDE; }
"a" { return BRACK; }
";" {return yytext[0];}
"if" { return IF; }

{DIGIT}+ {
  yylval.ival = atoi(yytext);
  return INTNUMBER;
}

{DIGIT}+"."{DIGIT}* {
  yylval.fval = atof(yytext);
  return DOUBLENUMBER;
}

[ \t\r\n]+ {  }

%%
