%{
#include <iostream>

#include "bison.tab.h"

using namespace std;

int poz[] = {1, 1, 0}

%}

%option noyywrap

DIGIT [0-9]
ID    [a-zA-Z][a-zA-Z0-9]*

%%

"=" {
  poz[1] += 1;
  poz[2] = 1;

  return ASSIGNMENT;
}

"+" {
  poz[1] += 1;
  poz[2] = 1;

  return PLUS;
}

"-" {
  poz[1] += 1;
  poz[2] = 1;

  return MINUS;
}

"*" {
  poz[1] += 1;
  poz[2] = 1;

  return MULTIPLY;
}

"/" {
  poz[1] += 1;
  poz[2] = 1;

  return DIVIDE;
}

"[" {
  poz[1] += 1;
  poz[2] = 1;

  return L_BOX;
}

"]" {
  poz[1] += 1;
  poz[2] = 1;

  return R_BOX;
}

"(" {
  poz[1] += 1;
  poz[2] = 1;

  return L_ROUND;
}

")" {
  poz[1] += 1;
  poz[2] = 1;

  return R_ROUND;
}

"{" {
  poz[1] += 1;
  poz[2] = 1;

  return L_CURLY;
}

"}" {
  poz[1] += 1;
  poz[2] = 1;

  return R_CURLY;
}

"<" {
  poz[1] += 1;
  poz[2] = 1;

  return L_ANGLE;
}

">" {
  poz[1] += 1;
  poz[2] = 1;

  return R_ANGLE;
}

"==" {
  poz[1] += 2;
  poz[2] = 2;

  return EQUAL;
}

"!=" {
  poz[1] += 2;
  poz[2] = 2;

  return NOT_EQUAL;
}

"es" {
  poz[1] += 1;
  poz[2] = 1;

  return AND;
}

"vagy" {
  poz[1] += 1;
  poz[2] = 1;

  return OR;
}

"forditva" {
  poz[1] += 3;
  poz[2] = 3;

  return NOT;
}

"." {
  poz[1] += 1;
  poz[2] = 1;

  return END;
}

"beolvas" {
  poz[1] += 4;
  poz[2] = 4;

  return READ;
}

"kiir" {
  poz[1] += 5;
  poz[2] = 5;

  return PRINT;
}

"vajon" {
  poz[1] += 2;
  poz[2] = 2;

  return IF;
}

"nemis" {
  poz[1] += 4;
  poz[2] = 4;

  return ELSE;
}

"fesztegyet" {
  poz[1] += 5;
  poz[2] = 5;

  return WHILE;
}

"egeszecske" {
  poz[1] += 3;
  poz[2] = 3;

  return INTEGER_TYPE;
}

"pottyos" {
  poz[1] += 6;
  poz[2] = 6;

  return DOUBLE_TYPE;
}

{ID} {
  poz[1] += yyleng;
  poz[2] = yyleng;

  return VARIABLE_ID;
}

{DIGIT}+ {
  poz[1] += yyleng;
  poz[2] = yyleng;

  yylval.ival = atoi(yytext);
  return INTNUMBER;
}

{DIGIT}+"."{DIGIT}* {
  poz[1] += yyleng;
  poz[2] = yyleng;

  yylval.fval = atof(yytext);
  return DOUBLENUMBER;
}

\n {
  ++poz[0];
  poz[1] = 1;
  poz[2] = 1;
}

[ \t\r]+ {
  poz[1] += yyleng;
  poz[2] = yyleng;
}

. {
  poz[1] += 1;
  poz[2] = 1;
}

%%
