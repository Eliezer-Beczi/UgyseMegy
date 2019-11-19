%{
#include <iostream>

#include "bison.tab.h"

using namespace std;
%}

%option noyywrap

%union {
  int ival;
  float fval;
  char* str;
}

DIGIT [0-9]
ID    [a-zA-Z][a-zA-Z0-9]*

%%

\+|\-|\*|\/|\^ { return yytext[0]; }

{DIGIT}+ {
  yylval.ival = atoi(yytext);
  return INTNUMBER;
}

{DIGIT}+"."{DIGIT}* {
  yylval.fval = atof(yytext);
  return DOUBLENUMBER;
}

\(|\) { return yytext[0]; }
\{|\} { return yytext[0]; }
\[|\] { return yytext[0]; }
\; { return yytext[0]; }

[ \t\r\n]+ {  }

. { return yytext[0]; }

%%
