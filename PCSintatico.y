%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <iostream>
#include <string>
#include <map>

using namespace std;

// stuff from flex that bison needs to know about:
extern int yylex();
extern int yyparse();
extern FILE *yyin;

void yyerror(const char *s);

map <string,string> dicionario;

%}

%union {
	int number;
	char caracter;
	char* string;
}

%token <string> TIPO
%token <number> NUMERO_REAL

%token ATRIBUICAO DIFERENTE 
%token <string> IDENTIFICADOR
%token MAIS MENOS 
%token ASTERISCO BARRA POTENCIA

%token FIM_LINHA TABULACAO

%token E OU
%token MAIS_ATRIBUICAO MENOS_ATRIBUICAO 
%token ASTERISCO_ATRIBUICAO BARRA_ATRIBUICAO

%token MENOR MAIOR MAIOR_IGUAL MENOR_IGUAL
%token IGUAL EXCLAMACAO COMENTARIO

%token E_COMERCIAL BARRA_VERTICAL

%token DOIS_PONTOS PONTO_E_VIRGULA VIRGULA
%token CHAVE_ESQUERDA CHAVE_DIREITA
%token COLCHETE_ESQUERDO COLCHETE_DIREITO
%token PARENTESIS_ESQUERDO PARENTESIS_DIREITO

%token INCLUA PRINCIPAL DEFINA

/*ESTRUTURA DE ENTRADA E SAIDA*/
%token LEIA ESCREVA

/*SESSAO DE ESTRUTURAS CONDICIONAIS E DE REPETICAO*/
%token SE SENAO
%token PARA PARE ENQUANTO FACA REPITA 
%token RETORNE

%left MAIS MENOS
%left ASTERISCO BARRA

%start Entrada

%%

Entrada:
	/* Empty */
	| Entrada Linha
   	;

/*Comentario:
	COMENTARIO Expressao
	| COMENTARIO Tipo
	| COMENTARIO Retorno
;*/

Linha:
	TABULACAO { printf("\t"); }	
	| FIM_LINHA {printf ("\n");}
//	| Principal
//	| Expressao
	| Tipo
//	| Retorno
//	| Comentario
//	| Condicional
//	| InclusaoDefinicao
//	| LeituraEscrita
;
/*
InclusaoDefinicao:
	INCLUA MENOR IDENTIFICADOR MAIOR { printf("#include <%s.h>", buffer); }
	| DEFINA IDENTIFICADOR Expressao { printf("#define %s %.2f", buffer, $3); }
;

Principal:
	INTEIRO PRINCIPAL PARENTESIS_ESQUERDO PARENTESIS_DIREITO CHAVE_ESQUERDA { printf("int main(){");}
	| CHAVE_DIREITA {printf("} do principal");}
;
*/
Tipo:
	TIPO IDENTIFICADOR PONTO_E_VIRGULA
	{			
		cout << dicionario[$1] << " " << $2 <<";"; 
	} 
//	| REAL IDENTIFICADOR PONTO_E_VIRGULA{ printf("float %c;", $2); } 
//	| CARACTERE IDENTIFICADOR PONTO_E_VIRGULA{ printf("char %c;", $2); } 
	//| IDENTIFICADOR ATRIBUICAO Expressao PONTO_E_VIRGULA{ printf("%s = %.2f;", buffer, $3);}
;

/*
Expressao:
	NUMERO_REAL { $$=$1; }
;*/
/*
LeituraEscrita:
//	ESCREVA Expressao PONTO_E_VIRGULA{ printf("printf(%.2f);", $2); }
//	| ESCREVA PARENTESIS_ESQUERDO Expressao PARENTESIS_DIREITO PONTO_E_VIRGULA{ printf("printf(%.2f);", $2); }

	ESCREVA IDENTIFICADOR PONTO_E_VIRGULA{ printf("printf(\"%s \\n\");", buffer); }
//	| ESCREVA PARENTESIS_ESQUERDO FRASE PARENTESIS_DIREITO PONTO_E_VIRGULA{ printf("printf(\"%s\");", buffer); }

//	| LEIA PARENTESIS_ESQUERDO Expressao PARENTESIS_DIREITO PONTO_E_VIRGULA { printf("scanf(%%d, &x);\n", $3); }
	| LEIA IDENTIFICADOR PONTO_E_VIRGULA { printf("scanf(\"%%d\", &%s);", buffer); }

;

Condicional:
	SE PARENTESIS_ESQUERDO Expressao MAIOR Expressao PARENTESIS_DIREITO { printf("if(%.2f > %.2f)",$3, $5); }
	| SE PARENTESIS_ESQUERDO Expressao MAIOR_IGUAL Expressao PARENTESIS_DIREITO { printf("if(%.2f >= %.2f)",$3, $5); }
	| SE PARENTESIS_ESQUERDO Expressao MENOR Expressao PARENTESIS_DIREITO{ printf("if(%.2f < %.2f)",$3, $5); }
	| SE PARENTESIS_ESQUERDO Expressao MENOR_IGUAL Expressao PARENTESIS_DIREITO{ printf("if(%.2f <= %.2f)",$3, $5); }
/*	SENAO CHAVE_ESQUERDA Expressao CHAVE_DIREITA { printf("if(%.2f > %.2f) else {%.2f}",$3, $5, $9); }
	SENAO CHAVE_ESQUERDA Expressao CHAVE_DIREITA { printf("if(%.2f >= %.2f) else {%.2f}",$3, $5, $9); }
	| SE PARENTESIS_ESQUERDO Expressao MAIOR Expressao PARENTESIS_DIREITO CHAVE_ESQUERDA CHAVE_DIREITA
	SENAO CHAVE_ESQUERDA Expressao CHAVE_DIREITA { printf("if(%.2f > %.2f) else {%.2f}",$3, $5, $11); }
	| SE PARENTESIS_ESQUERDO Expressao MAIOR_IGUAL Expressao PARENTESIS_DIREITO CHAVE_ESQUERDA CHAVE_DIREITA 
	SENAO CHAVE_ESQUERDA Expressao CHAVE_DIREITA { printf("if(%.2f >= %.2f) else {%.2f}",$3, $5, $11); }*/

//	| SE Expressao IGUAL Expressao { printf("if(%.2f == %.2f)\n",$2, $4); }
//	| SE PARENTESIS_ESQUERDO Expressao IGUAL Expressao PARENTESIS_DIREITO{ printf("if(%.2f == %.2f)",$3, $5); }
//;

/*
Retorno:
	RETORNE Expressao PONTO_E_VIRGULA { 
		int aux=0, aux1=0;
		aux = $2;
		aux1 = ceil($2);
		if(aux == aux1){
			printf("return %d;", $2); 
		}else{
			printf("return %.2f;", $2); 
		}
	}
	| RETORNE IDENTIFICADOR PONTO_E_VIRGULA { printf("return %s;", buffer); }
;
 */

%%

void yyerror(const char *s) {
    printf("%s\n",s);
}

int main(int argc, char *argv[]) 
{	
	dicionario["inteiro"] = "int";

	string arquivoEntrada;

	if(argc == 1)
		arquivoEntrada = "codigo.prg";
	else
		arquivoEntrada = argv[1];

	// open a file handle to a particular file:
	FILE *myfile = fopen(arquivoEntrada.c_str(), "r");

/*	string arquivoSaida;

	if(argc > 2)
		arquivoSaida = argv[argc-1];*/

	// make sure it is valid:
	if (!myfile) {
		printf("Desculpe-nos!! Não conseguimos abrir o arquivo: %s! \n", arquivoEntrada.c_str());
		return -1;
	}
	// set flex to read from it instead of defaulting to STDIN:
	yyin = myfile;
	
	// parse through the input until there is no more:
	do {
		yyparse();
	} while (!feof(yyin));

	return 0;
}
