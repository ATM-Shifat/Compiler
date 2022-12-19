%{
	#include "1807015.tab.h"
 	#include<stdio.h>
	#include<string.h>
   	#include<math.h>
	#include<stdlib.h>
	void yyerror(char *);
	
	
%}


variable _[a-zA-Z]+([a-zA-Z0-9])*
integer [0-9]+
decimal [0-9]*[.][0-9]+

%%  


"library"		{ return HEADER; }
"root_start"		{ return MAIN_START;}
"root_end"		{ return MAIN_END;}
"#"			{ return SE;}
","			{ return C;}
"function" 		{ return FUNCTION;}
"empty"			{ return VOID;}
"get"			{ return RETURN;}
"whole"			{ return INT;}
"bigwhole"		{ return LONG;}
"bigpoint"		{ return DOUBLE;}
"point"			{ return FLOAT;}
"letter"		{ return CHAR;}
"fi"			{ return IF;}
"fiesle"		{ return ELIF;}
"esle"			{ return EL;}
"loop"			{ return FOR;}
"whileloop"		{ return WHILE;}
"assign"		{ return ASSIGN;}
"inc"			{ return INC;}
"dec"			{ return DEC;}
"bigger"		{ return GREATER;}
"smaller"		{ return LESS;}
"equal"			{ return EQUAL;}
"notequal"		{ return NOTEQ;}
"big_equal"		{ return GREATEREQ;}
"less_equal"		{ return LESSEQ;}
"or"			{ return OR;}
"and"			{ return AND;}
"L"			{ return L;}
"R"			{ return R;}
"LB"			{ return LB;}
"RB"			{ return RB;}
"SL"			{ return SL;}
"SR"			{ return SR;}
"add"			{ return ADD;}
"minus"			{ return MINUS;}
"mul"			{ return MUL;}
"div"			{ return DIV;}
"mod"			{ return MOD;}
"add_assign"		{ return ADDAS;}
"minus_assign"		{ return MINUSAS;}
"mul_assign"		{ return MULAS;}
"div_assign" 		{ return DIVAS;}
"write"			{ return PRINT;}
"read"			{ return READ;}

"\""(.)*"\"" 		{yylval.string = yytext; return STR;}

{variable}		{yylval.string = yytext;return VAR;}

{integer}		{yylval.integer=atoi(yytext);return INTEGER;}

{decimal}		{yylval.decimal= atof(yytext);return DECIMAL;}

"$*" 			{
					printf("\nStart of a comment\n");
					char x = input();
					while(1){
						if(x == '*') {
							char y = input();
							if(y == '$'){
								printf("\nEnd of a  comment\n");
								break;
							}
							printf("%c", x);
							x = y;
						}
						;
						x = input();
					}
				}


[ \t]*	 		;
.				{ yyerror("\nUnknown Character.\n");}
%%

int yywrap(){
	return 1;
}

int main(){

    freopen("input.txt","r",stdin);
    freopen("output.txt","w",stdout);
   yyparse();

}

