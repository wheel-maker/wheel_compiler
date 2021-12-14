%{
#include <stdio.h>
#include <string.h>

#define INTTYPE 0
#define FLOATTYPE 1
#define DOUBLETYPE 2

#define MAXVAR 100
#define MAXQUATER 80
extern int yylex(void);
void yyerror(char*);

extern FILE* yyin;
extern char tmp[20];
extern int intTmp;
extern double realTmp;

int varCount=0;
int offset=0;
int NXQ=0;

// 仅用于调试
void output();

int entry(char* name);
int fill(int p,int type,int offset);
int newtemp();
int gen(char* op,int e1,int e2,int t);
void backpatch(int p,int t);
int merge(int p1,int p2);

// 每个四元式由（运算符，表达式1，表达式2，结果）组成
struct quaterNode{
	char op[5];
	int arg1;
	int arg2;
	int result;
} quaterList[MAXQUATER];

// 每一个符号信息表由（名称、类型、地址）组成
struct varNode{
	char name[20];
	int type;
	int addr;
} varList[MAXVAR];
%}

%union
{
	int NO;
	char ROP[5];
	struct { int type; int width;} _VAR;
	struct { int type; int place;} _EXP;
	struct { int truelist; int falselist;} _BEXP;
	struct { int quad; int nextlist;} _WHILE;
}

%token INT
%token FLOAT
%token DOUBLE
%token AND NOT OR
%token COMPARE
%token DIGIT REAL
%token MARK RETURN WHILE IF ELSE LBRACKET RBRACKET LCBRACKET RCBRACKET BOUND ASSIGN CR ADD SUB DIV MUL COMMA

%type <NO> id
%type <NO> block
%type <NO> ifSentence
%type <NO> whileSentence
%type <NO> IF_T
%type <NO> IF_T_E
%type <NO> sentence
%type <NO> sentences
%type <NO> program
%type <_VAR> type
%type <_VAR> variable
%type <_EXP> expression
%type <_BEXP> boolExpression
%type <ROP> relop;
%type <_WHILE> wh;
%type <_WHILE> assignSentence;

%%
program			:type id LBRACKET paramentList RBRACKET block {$$=0;}
				;
paramentList	:variable COMMA paramentList
				|variable			
				|
				;
block			:LCBRACKET declare sentences {backpatch($3,NXQ);} RCBRACKET {$$=0;}
				;
declare			:declare variable BOUND
				|
				;
variable		:type id				{int p=$2;fill(p,$1.type,offset);$$.type=$1.type;$$.width=$1.width;}
				|variable COMMA	id		{int p=$3;offset=offset+$$.width;fill(p,$1.type,offset);$$.type=$1.type;$$.width=$1.width;}
				;
type			:INT					{$$.type=INTTYPE;$$.width=4;}
				|FLOAT					{$$.type=FLOATTYPE;$$.width=4;}
				|DOUBLE					{$$.type=DOUBLETYPE;$$.width=8;}
				;
id				:MARK	{$$=entry(tmp);/*在符号表中寻找MARK并将其地址赋给id*/}
sentences		:sentence sentences	{$$=$1;backpatch($1,NXQ);}
				|sentence			{$$=$1;backpatch($1,NXQ);}
				;
sentence		:ifSentence		{$$=$1;}
				|whileSentence	{$$=$1;}
				|returnSentence	{$$=0;}
				|assignSentence	{$$=0;}
				;
assignSentence	:id ASSIGN expression BOUND	{$$.quad=$1;$$.nextlist=NXQ-1;gen("=",$3.place,-1,$1);}
				;
returnSentence	:RETURN BOUND
				|RETURN expression BOUND
				;
whileSentence	:wh block {gen("j",-1,-1,$1.quad);backpatch($2,$1.quad);$$=$1.nextlist;}
				;
wh				:WHILE LBRACKET boolExpression RBRACKET	{backpatch($3.truelist,NXQ);$$.quad=NXQ;$$.nextlist=$3.falselist;}
				;
ifSentence		:IF_T block {$$=merge($1,$2);}
				|IF_T_E block {$$=merge($1,$2);}
				;
IF_T			:IF LBRACKET boolExpression RBRACKET {backpatch($3.truelist,NXQ);$$=$3.falselist;}
				;
IF_T_E			:IF_T block ELSE {int q=NXQ;gen("j",-1,-1,0);backpatch($1,NXQ);$$=merge($2,q);}
				;
boolExpression	:boolExpression AND {backpatch($1.truelist,NXQ);} boolExpression {$$.truelist=$4.truelist;$$.falselist=merge($1.falselist,$4.falselist);}
				|boolExpression OR {backpatch($1.falselist,NXQ);} boolExpression {$$.truelist=merge($1.truelist,$4.truelist);$$.falselist=$4.falselist;}
				|NOT boolExpression {$$.truelist=$2.falselist;$$.falselist=$2.truelist;}
				|LBRACKET boolExpression RBRACKET {$$.truelist=$2.truelist;$$.falselist=$2.falselist;}
				|expression relop expression	{$$.truelist=NXQ;$$.falselist=NXQ+1;gen($2,$1.place,$3.place,0);gen("j",-1,-1,0);}
				|expression {$$.truelist=NXQ;$$.falselist=NXQ+1;gen("jnz",$1.place,-1,0);gen("j",-1,-1,0);}
				;
expression		:expression ADD expression		{int T=newtemp();gen("+",$1.place,$3.place,T);$$.type=$1.type;$$.place=T;}
				|expression SUB expression		{int T=newtemp();gen("-",$1.place,$3.place,T);$$.type=$1.type;$$.place=T;}
				|expression MUL expression		{int T=newtemp();gen("*",$1.place,$3.place,T);$$.type=$1.type;$$.place=T;}
				|expression DIV expression		{int T=newtemp();gen("/",$1.place,$3.place,T);$$.type=$1.type;$$.place=T;}
				|'-' expression					{int T=newtemp();gen("@",$2.place,-1,T);$$.type=$2.type;$$.place=T;}
				|LBRACKET expression RBRACKET	{$$=$2;}
				|id								{$$.place=$1;$$.type=varList[$1].type;/*将id所在位置赋值为表达式*/}
				|DIGIT							{$$.place=intTmp;$$.type=INTTYPE;}
				|REAL							{$$.place=realTmp;$$.type=DOUBLETYPE;}
				;
relop			:COMPARE	{char ch[5]="j";strcpy(tmp,strcat(ch,tmp));strcpy($$,tmp);}
				;
%%
// 在符号表中寻找MARK并将其地址返回
int entry(char* name)
{
	int i;
	for(i=1;i<=varCount;i++)
		if(!strcmp(varList[i].name,name))
		{
			return i;
		}
	// 找不到就新增一个符号
	strcpy(varList[++varCount].name,name);
	varList[varCount].type=-1;
	return varCount;
}
// 在符号表位置p+offset处中填充类型type
int fill(int p,int type,int offset)
{
	varList[p].type=type;
	return 0;
}
// 生成新的临时单元并返回编号
int newtemp()
{
	static int no=0;
	char Tname[20];
	sprintf(Tname,"T%o",no++);
	return entry(Tname);
}
// 生成四元式
int gen(char* op,int e1,int e2,int t)
{
	strcpy(quaterList[NXQ].op,op);
	quaterList[NXQ].arg1=e1;
	quaterList[NXQ].arg2=e2;
	quaterList[NXQ].result=t;
	NXQ++;
	return NXQ;
}
// 回填技术
void backpatch(int p,int t)
{
	int q=p;
	while(q)
	{ 
		int next=quaterList[q].result;
		quaterList[q].result=t;
		q=next;
	} 
    return;
}
// 合并链
int merge(int p1,int p2)
{
	int p;
	if(!p2) 
		return p1;
	else
	{
	   p=p2;
	   while(quaterList[p].result)
			p=quaterList[p].result;
	   quaterList[p].result=p1;
	   return p2;
	}
}
// 仅用于调试输出
void output()
{
	int i;
	for(i=0;i<NXQ;i++)
	{
		printf("%d (%s",i+100,quaterList[i].op);
		if(quaterList[i].arg1==-1)
			printf(" _");
		else
			printf(" %d",quaterList[i].arg1);
		if(quaterList[i].arg2==-1)
			printf(" _");
		else
			printf(" %d",quaterList[i].arg2);
		printf(" %d)\n",quaterList[i].result+100);
	}
	printf("#\n");
	for(i=1;i<=varCount;i++)
	{
		printf("%d %s ",i,varList[i].name);
		switch(varList[i].type)
		{
			case -1:printf("NULL\n");
					break;
			case 0: printf("INT\n");
					break;
			case 1: printf("FLOAT\n");
					break;
			case 2: printf("DOUBLE\n");
					break;
			default:break;
		}
	}

}

void yyerror(char* str)
{
	fprintf(stderr,"error:%s\n",str);
}

int yywrap()
{
	return 1;
}
int main(int argc, char **argv)
{
  FILE *file;
  file=fopen(argv[1],"r");
  if(file)
	yyin=file;
  yyparse(); 
  yywrap();
  output();
  return 0;
}
