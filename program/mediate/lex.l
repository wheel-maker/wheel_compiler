%{
    
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
void yyerror(char*);

// 存放标识符
char tmp[20];
int intTmp;
double realTmp;
%}

KEY int|float|double|void|if|else|while|return
AND and
OR or
NOT not
MARK {ALPHA}+[a-zA-Z0-9_]*
ARITH "+"|"-"|"*"|"/"|"**"|"%"
COMPARE "=="|">"|"<"|"<="|">="|"!="
ALPHA [a-zA-Z]
DIGIT [1-9][0-9]*|[0]
REAL {DIGIT}\.[0-9]+

%%

{KEY} {
		if(yytext[0]=='i')
		{
			if(yytext[1]=='f')
				return IF;
			else if(yytext[1]=='n')
				return INT;
		}
		else if(yytext[0]=='e')
			return ELSE;
		else if(yytext[0]=='w')
			return WHILE;
		else if(yytext[0]=='r')
			return RETURN;
		else if(yytext[0]=='f')
			return FLOAT;
		else if(yytext[0]=='d')
			return DOUBLE;
		}
{AND} return AND;
{OR}  return OR;
{NOT} return NOT;
{MARK} {strcpy(tmp,yytext);return MARK;/*将标识符的内容存储到tmp中*/}
{DIGIT} return DIGIT;
{REAL} return REAL;
{COMPARE} {strcpy(tmp,yytext);return COMPARE;}
"("	return LBRACKET;
")" return RBRACKET;
"{" return LCBRACKET;
"}" return RCBRACKET;
";" return BOUND;
"," return COMMA;
"=" return ASSIGN;
"+" return ADD;
"-" return SUB;
"/" return DIV;
"*" return MUL;

\n
[ \t]+
.


%%


