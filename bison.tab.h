/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_BISON_TAB_H_INCLUDED
# define YY_YY_BISON_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    INTNUMBER = 258,
    DOUBLENUMBER = 259,
    STR = 260,
    PLUS = 261,
    MINUS = 262,
    MULTIPLY = 263,
    DIVIDE = 264,
    ASSIGNMENT = 265,
    L_BOX = 266,
    R_BOX = 267,
    L_ROUND = 268,
    R_ROUND = 269,
    L_CURLY = 270,
    R_CURLY = 271,
    L_ANGLE = 272,
    R_ANGLE = 273,
    EQUAL = 274,
    NOT_EQUAL = 275,
    AND = 276,
    OR = 277,
    NOT = 278,
    END = 279,
    READ = 280,
    PRINT = 281,
    IF = 282,
    ELSE = 283,
    WHILE = 284,
    INTEGER_TYPE = 285,
    DOUBLE_TYPE = 286,
    VARIABLE_ID = 287,
    GLOBAL_MODIFIER = 288,
    PIPE = 289,
    DOUBLECOMMA = 290,
    TILDA = 291,
    NOT_INDEXED = 292
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 60 "bison.y" /* yacc.c:1909  */

  int ival;
  float fval;
  double dval;
  char* str;    
  struct ugysemegyVar* uVar;
  bool boolean;
  struct expression* expr;

#line 102 "bison.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_BISON_TAB_H_INCLUDED  */
