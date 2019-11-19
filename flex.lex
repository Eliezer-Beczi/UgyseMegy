%{
#include <iostream>
using namespace std;
%}

%option noyywrap

%%

[ \t\r\n]+ {}

. { return yytext[0]; }

%%
