
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
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


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     INT = 258,
     FLOAT = 259,
     DOUBLE = 260,
     AND = 261,
     NOT = 262,
     OR = 263,
     COMPARE = 264,
     DIGIT = 265,
     REAL = 266,
     MARK = 267,
     RETURN = 268,
     WHILE = 269,
     IF = 270,
     ELSE = 271,
     LBRACKET = 272,
     RBRACKET = 273,
     LCBRACKET = 274,
     RCBRACKET = 275,
     BOUND = 276,
     ASSIGN = 277,
     CR = 278,
     ADD = 279,
     SUB = 280,
     DIV = 281,
     MUL = 282,
     COMMA = 283
   };
#endif
/* Tokens.  */
#define INT 258
#define FLOAT 259
#define DOUBLE 260
#define AND 261
#define NOT 262
#define OR 263
#define COMPARE 264
#define DIGIT 265
#define REAL 266
#define MARK 267
#define RETURN 268
#define WHILE 269
#define IF 270
#define ELSE 271
#define LBRACKET 272
#define RBRACKET 273
#define LCBRACKET 274
#define RCBRACKET 275
#define BOUND 276
#define ASSIGN 277
#define CR 278
#define ADD 279
#define SUB 280
#define DIV 281
#define MUL 282
#define COMMA 283




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 50 "bison.y"

	int NO;
	char ROP[5];
	struct { int type; int width;} _VAR;
	struct { int type; int place;} _EXP;
	struct { int truelist; int falselist;} _BEXP;
	struct { int quad; int nextlist;} _WHILE;



/* Line 1676 of yacc.c  */
#line 119 "y.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


