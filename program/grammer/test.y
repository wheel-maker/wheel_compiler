%{
#include <stdio.h>
#include <string.h>
int yylex(void);
void yyerror(char*);
%}

%token KEY DRESS ID SINGARITH DOUBARITH COMPARITH DIGIT REAL IF ELSE FOR RET ASSIGN SEMI COMMAS LBRCT RBRCT LCBRCT RBRCT END CR 

%%
funList			:funList blackLine fun
				|fun
				;
blackLine		:blackLine CR
				|
				;
fun				:DRESS type ID LBRCT formParaList RBRCT LCBRCT funBody RCBRCT
				;
formParaList	:declare COMMAS formParaList
				|declare
				|
				;
declare			:DRESS type ID
				;
funBody			:sentence funBody
				|sentence
				;
sentence		:declareSentence
				|assignSentence
				|ifSentence
				|recSentence
				|retSentence
				;
declareSentence	:declare;
				|declare ASSIGN rightValue
				;
assignSentence	:ID ASSIGN rightValue
				;
rightValue		:expression
				|ID
				|ID LBRCT actuParaList RBRCT
				;
expression		:term DOUBARITH expression
				|term
				;
term			:SINGARITH ID SINGARITH
				|DIGIT
				;
actuParaList	:ID,actuParaList
				|ID
				|
				;
ifSentence		:IF LBRCT expression RBRCT LCBRCT funBody RCBRCT elseSentence
				;
elseSentence	:ELSE ifSentence
				|ELSE LCBRCT funBody RCBRCT
				;
recSentence		:FOR LBRCT declareSentence expression SEMI assignSentence RBRCT LCBRCT funBody RCBRCT
				;
retSentence		:RET expression
				;
type			:type*
				|KEY
				;
				
%%
void yyerror(char* str)
{
	fprintf(stderr,"error:%s\n",str);
}
int yywrap()
{
	return 1;
}
int main()
{
	yyparse();
}
