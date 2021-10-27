%{
    
#include <stdio.h>
#include <string.h>

%}

KEY int|float|double|void|if|else|while|return
MARK {ALPHA}+[a-zA-Z0-9_]*
ARITH "+"|"-"|"*"|"/"|"**"|"%"
COMPARE "=="|">"|"<"|"<="|">="|"!="
ALPHA [a-zA-Z]
DIGIT [1-9][0-9]*|[0]
REAL {DIGIT}|{DIGIT}\.[0-9]+

%%

{KEY} {
		if(yytext[0]=='i')
		{
			if(yytext[1]=='f')
				printf("<$IF,->\n");
			else if(yytext[1]=='n')
				printf("<$INT,->\n");
		}
		else if(yytext[0]=='f')
			printf("<$FLOAT,->\n");
		else if(yytext[0]=='d')
			printf("<$DOUBLE,->\n");
		else if(yytext[0]=='v')
			printf("$<VOID,->\n");
		else if(yytext[0]=='e')
			printf("<$ELSE,->\n");
		else if(yytext[0]=='w')
			printf("<$WHILE,->\n");
		else if(yytext[0]=='r')
			printf("<$RETURN,->\n");
		}
{MARK} printf("<$ID,%s>\n",yytext);
{REAL} printf("<$REAL,%s>\n",yytext);
"=" printf("<$ASSIGN,->\n");
{ARITH} printf("<$ARITH,%s>\n",yytext);
{COMPARE} printf("<COMP,%s>\n",yytext);
";" printf("<$BOUND,->\n");
"," printf("<$GAP,->\n");
"(" printf("<(,->\n");
")" printf("<),->\n");
"{" printf("<{,->\n");
"}" printf("<},->\n");
"#" {printf("<#END,->\n");return 0;}
"//"[^\n]* |
"/*"([^\*]|(\*)*[^\*/])*(\*)*"*/" printf("<$NOTE,->\n");
" "|"\t"|"\n" 
[.]+ printf("ERROR:%s",yytext);

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