%{
#include <iostream>
using namespace std;
%}

%option noyywrap

DIGIT [0-9]
ID    [a-zA-Z][a-zA-Z0-9]*

%%

\+|\-|\*|\/|\^ { return yytext[0]; }

{DIGIT}+ { return yytext[0]; }
{DIGIT}+"."{DIGIT}* { return yytext[0]; }

\(|\) { return yytext[0]; }
\{|\} { return yytext[0]; }
\[|\] { return yytext[0]; }
\; { return yytext[0]; }

[ \t\r\n]+ {  }

. { return yytext[0]; }

%%
