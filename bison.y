%{
#include <iostream>
using namespace std;

int yyerror(const char*);
extern int yylex();
int count=0;
%}
%start s
%%

s: 'a' s 'b' {
    ++count;    
}
 | %empty {std::cout<<count<<endl;}
; 

%%

int main() {
	yyparse();    
}

int yyerror(const char* s) {
	cout << s << endl;
}
