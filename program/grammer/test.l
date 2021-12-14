%{
    
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
void yyerror(char*);

%}

KEY int|float|double|void
DRESS static|const|volatile extern
ID {ALPHA}+[a-zA-Z0-9_]*
SINGARITH "++"|"--"|"-"
DOUBARITH "+"|"-"|"*"|"/"|"**"|"%"
COMPARITH "=="|">"|"<"|"<="|">="|"!="
ALPHA [a-zA-Z]
DIGIT [1-9][0-9]*|[0]
REAL {DIGIT}|{DIGIT}\.[0-9]+

%%

{KEY}   return KEY;
{DRESS} return DRESS;
{ID} 	return ID;
{SINGARITH}	return SINGARITH;
{DOUBARITH}	return DOUBARITH;
{COMPARITH}	return COMPARITH;
{DIGIT}	return DIGIT;
{REAL}	return REAL;
"if"	return IF;
"else"	return ELSE;
"for"	return FOR;
"return"return RET;
"="		return ASSIGN;
";" 	return SEMI;
"," 	return COMMAS;
"(" 	return LBRCT;
")" 	return RBRCT;
"{" 	return LCBRCT;
"}"		return RCBRCT;
"#"		return END;
"//"[^\n]* |
"/*"([^\*]|(\*)*[^\*/])*(\*)*"*/" ;
\n		return CR;
[ \t]+	;
.

%%

int main(int argc, char **argv)
{
  FILE *file;
  file=fopen(argv[1],"r");
  if(file)
	yyin=file;
  yylex(); 
  yywrap();
}
int yywrap()
{
	return 1;
}