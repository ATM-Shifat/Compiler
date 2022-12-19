%{
#include<stdio.h>
#include<math.h>
#include<string.h>
#include<limits.h>
#include<float.h>
void yyerror(char *);

extern int yylex();
extern int yyparse();
	
typedef struct {
	char var_name[100];
    int  int_value;

}store;
	
store var[1000];
int id = 1; 

void declare_var(int i, char *var_n)
{	
 	
 	int l = strlen(var_n);
 	var_n[l-1] = '\0';
 	strcpy(var[i].var_name, var_n);
 	var[i].int_value = 0;
}

int if_declared(char *v)
{	
	printf("\n{%s}\n", v);
    for(int i = 1; i < 1000; i++){
    	if(strcmp(var[i].var_name, v) == 0)
    		return i;
    }
    return 0;
}
int new_val(char *v,int val)
{
	
	int i = if_declared(v);
	if(i){
		var[i].int_value = val;
		return i;
	}
	return 0;		
}

int get_val(char *v)
{
	
	int i = if_declared(v);
	if(i){
		return var[i].int_value;
	}
	return 0;		
}


	
	
%}
%union 
{
		int integer;
		double decimal;
        char *string;
}
/* BISON Declarations */
%start start
%token<integer> INT LONG DOUBLE FLOAT CHAR INTEGER  
%token<decimal> DECIMAL
%token<string> VAR 
%type<integer> declaration statement if else elseif while for write read main type assignment
%type<integer> expression condition
%token IF ELIF EL FOR WHILE ASSIGN INC DEC L R LB RB SL SR GREATER LESS EQUAL NOTEQ GREATEREQ LESSEQ OR AND ADD MINUS ADDAS MINUSAS MUL DIV MOD MULAS DIVAS MODAS SE C MAIN_START MAIN_END FUNCTION VOID RETURN PRINT READ STR HEADER
%left GREATER LESS EQUAL NOTEQ GREATEREQ LESSEQ OR AND 
%left ADDAS MINUSAS DIVAS MULAS MODAS
%left ADD MINUS
%left MUL DIV MOD
%left INC DEC

/* Simple grammar rules */

%%

start:
	| start main
	| start header
	
	;
	
header:
	HEADER  {printf("\nHeader file added\n");}
main:
	 MAIN_START main_statement MAIN_END {printf("\nMain Function\n");}
	;
main_statement:
	|main_statement statement
	;

statement:
	|declaration
	| assignment
	| if
	| for
	| while
	| write
	;
	

declaration:
	type VAR SE 		{  int i, a;
						 	
						 	for(i = 0; $2[i] != ' '; i++){}
						 	$2[++i] = '\0';
						 	a = 0;
						 	for(int j = 1; j < 1000; j++)
						 	{
						 		if(strcmp(var[j].var_name, $2) == 0){
						 		a = j;
								break;
								}
						 	}
						 	
						 	if(!a)
						 	{
						 		strcpy(var[id].var_name, $2);
 								var[id].int_value = 0;
								printf("\nSucccessfull declaration of  %s\n", var[id].var_name);
								id++;
						 	}
						 	else{ printf("\n%s is already declared\n", $2);}
						}
	| type VAR ASSIGN expression SE {  int i, a;
						 	
									 	for(i = 0; $2[i] != ' '; i++){}
									 	$2[++i] = '\0';
									 	a = 0;
									 	for(int j = 1; j < 1000; j++)
									 	{
									 		if(strcmp(var[j].var_name, $2) == 0){
									 		a = j;
											break;
											}
									 	}
									 	
									 	if(!a)
									 	{
									 		strcpy(var[id].var_name, $2);
			 								var[id].int_value = $4;
											printf("\nSucccessfull declaration with initialization of  %s with %d\n", var[id].var_name, var[id].int_value);
											id++;
									 	}else{ printf("\n%s is already declared\n", $2);}
									} 
								
	;

if:
    IF L condition R LB statement RB{ 
                                if($3)
                                {
                                    printf("\nInside if block\n");
                                }
    							}
   
    |IF L condition R LB statement RB elseif{
                                if($3)
                                {
                                   
                                    printf("\nInside if block\n");
                                }
                                else
                                {
                                    printf("\nInside else-if block\n");
                                }

    							}
    ;
    
elseif:
	ELIF  L condition R LB statement RB elseif{
                                			if($3)
                                			{
                                	    	 printf("\nInside else-if block\n");
                               				 }
                               				 }
    | else
    ;
else:
	EL LB statement RB {printf("\nInside else block\n");}
	
for:
    FOR L expression C expression R LB statement RB{		int i = $3;
						        							while(i < $5)
															{
																printf("\nThis is for loop\n");
																i++;
															}
															}
    ;
while:
	WHILE L condition R LB statement RB{
						        		while($3)
										{
										printf("\nThis is while loop\n");						
										}
										}
	;
	
											

write:
	PRINT L expression R SE {printf("%d", $3);}
	| PRINT L R SE {printf("\n");}
	;
type:
	INT
	;
assignment:
	VAR ASSIGN expression SE { int i, a;
						 	
								for(i = 0; $1[i] != ' '; i++){}
								$1[++i] = '\0';
								a = 0;
								for(int j = 1; j < 1000; j++)
								{
									 if(strcmp(var[j].var_name, $1) == 0){
									 a = j;
									 break;
									}
								}
							if(a)
							{
								var[a].int_value = $3;
								printf("\nAssignment successfull {%s} %d\n",$1, $3);
							}else{ printf("\n%s is not declared\n", $1);}
						}
	| VAR ADDAS expression SE { int i, a;
						 	
								for(i = 0; $1[i] != ' '; i++){}
								$1[++i] = '\0';
								a = 0;
								for(int j = 1; j < 1000; j++)
								{
									 if(strcmp(var[j].var_name, $1) == 0){
									 a = j;
									 break;
									}
								}
							if(a)
							{
								var[a].int_value += $3;
								printf("\nAdd assignment successfull {%s} %d\n",$1, var[a].int_value);
							}else{ printf("\n%s is not declared\n", $1);}
						}
						
	| VAR MINUSAS expression SE { int i, a;
						 	
								for(i = 0; $1[i] != ' '; i++){}
								$1[++i] = '\0';
								a = 0;
								for(int j = 1; j < 1000; j++)
								{
									 if(strcmp(var[j].var_name, $1) == 0){
									 a = j;
									 break;
									}
								}
							if(a)
							{
								var[a].int_value -= $3;
								printf("\nMinus assignment successfull {%s} %d\n",$1, var[a].int_value);
							}else{ printf("\n%s is not declared\n", $1);}
						}
	| VAR MULAS expression SE { int i, a;
						 	
								for(i = 0; $1[i] != ' '; i++){}
								$1[++i] = '\0';
								a = 0;
								for(int j = 1; j < 1000; j++)
								{
									 if(strcmp(var[j].var_name, $1) == 0){
									 a = j;
									 break;
									}
								}
							if(a)
							{
								var[a].int_value *= $3;
								printf("\nMultiply assignment successfull {%s} %d\n",$1, var[a].int_value);
							}else{ printf("\n%s is not declared\n", $1);}
						}
	| VAR DIVAS expression SE { int i, a;
						 	
								for(i = 0; $1[i] != ' '; i++){}
								$1[++i] = '\0';
								a = 0;
								for(int j = 1; j < 1000; j++)
								{
									 if(strcmp(var[j].var_name, $1) == 0){
									 a = j;
									 break;
									}
								}
							if(a)
							{
								if($3 != 0)
								{
									var[a].int_value /= $3;
									printf("\nAssignment successfull {%s} %d\n",$1, var[a].int_value);
								}else{printf("\nDivision by zero\n");}
							}else{ printf("\n%s is not declared\n", $1);}
						}
	;
condition:
	INTEGER {$$ = $1;}
	| VAR 		{ 		int i, a;
						 for(i = 0; $1[i] != ' '; i++){}
						$1[++i] = '\0';
						  a = 0;
						  for(int j = 1; j < 1000; j++)
						  {
								if(strcmp(var[j].var_name, $1) == 0){
								a = j;
								break;
								}
						  }
							if(a)
							{
							$$ = var[a].int_value;
							}
						}
    |expression GREATER expression {$$ = $1 > $3;}
    |expression LESS expression {$$ = $1 < $3;}
    |expression EQUAL expression {$$ = $1 == $3;}
    |expression NOTEQ expression {$$ = $1 != $3;}
    |expression GREATEREQ expression {$$ = $1 >= $3;}
    |expression LESSEQ expression {$$ = $1 <= $3;}
    |expression OR expression {$$ = $1 || $3;}
    |expression AND expression {$$ = $1 && $3;}
    ;
expression: 
			INTEGER {$$ = $1;}
			| VAR 		{ int i, a;
						 for(i = 0; $1[i] != ' '; i++){}
						$1[++i] = '\0';
						  a = 0;
						  for(int j = 1; j < 1000; j++)
						  {
								if(strcmp(var[j].var_name, $1) == 0){
								a = j;
								break;
								}
						  }
							if(a != 0)
							{
							$$ = var[a].int_value;
							}
							printf("\n%d\n",var[a].int_value);
						}
			
			| expression ADD expression {$$ = $1 + $3;}
			| expression MINUS expression {$$ = $1 - $3;}
			| expression MUL expression {$$ = $1 * $3;}
			| expression DIV expression {
										if($3)
										{$$ = $1 / $3;}
										else{printf("\nDivision by zero\n");}
										}
			| expression MOD expression {
										if($3)
										{$$ = $1 % $3;}
										else{printf("\nDivision by zero\n");}
										}
		    | L expression R {$$ = $2;}
		    | L expression R INC {int a = $2 + 1; $$ = a;}
		    | L expression R DEC {$$ = --$2;}
			;
	
%%

void yyerror(char *s){
	printf( "%s\n", s);
}

