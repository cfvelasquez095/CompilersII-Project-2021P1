%require "3.0"
%language "c++"
%define parse.error verbose
%define api.value.type variant
%define api.parser.class {Parser}
%define api.namespace {Expr}

%code requires {

#include <string>
#include <unordered_map>

}

%{
#include <iostream>
#include <stdexcept>
#include <string>
#include <unordered_map>
#include "tokens.h"

namespace Expr {
    void Parser::error(const std::string &msg) {
        throw std::runtime_error(msg);
    }
}

int yylex(Expr::Parser::semantic_type *yylval);

%}

%token Kw_Abrir         "abrir"
%token Kw_Archivo       "archivo"
%token Kw_Arreglo       "arreglo"
%token Kw_Booleano      "booleano"
%token Kw_Cadena        "cadena"
%token Kw_Caracter      "caracter"
%token Kw_Caso          "caso"
%token Kw_Cerrar        "cerrar"
%token Kw_Como          "como"
%token Kw_De            "de"
%token Kw_Div           "div"
%token Kw_Entero        "entero"
%token Kw_Entonces      "entonces"
%token Kw_Es            "es"
%token Kw_Escriba       "escriba"
%token Kw_Escribir      "escribir"
%token Kw_Escritura     "escritura"
%token Kw_Falso         "falso"
%token Kw_Fin           "fin"
%token Kw_Final         "final"
%token Kw_Funcion       "funcion"
%token Kw_Haga          "haga"
%token Kw_Hasta         "hasta"
%token Kw_Inicio        "inicio"
%token Kw_Lea           "lea"
%token Kw_Lectura       "lectura"
%token Kw_Leer          "leer"
%token Kw_Llamar        "llamar"
%token Kw_Mientras      "mientras"
%token Kw_Mod           "mod"
%token Kw_No            "no"
%token Kw_O             "o"
%token Kw_Para          "para"
%token Kw_Procedimiento "procedimiento"
%token Kw_Real          "real"
%token Kw_Registro      "registro"
%token Kw_Repita        "repita"
%token Kw_Retorne       "retorne"
%token Kw_Secuencial    "secuencial"
%token Kw_Si            "si"
%token Kw_Sino          "sino"
%token Kw_Tipo          "tipo"
%token Kw_Var           "var"
%token Kw_Verdadero     "verdadero"
%token Kw_Y             "y"

%token Tk_OpenBracket   "["
%token Tk_CloseBracket  "]"
%token Tk_OpenPar       "("
%token Tk_ClosePar      ")"
%token Tk_Comma         ","
%token Tk_Colon         ":"

%token Op_Assign        "<-"
%token Op_NotEqual      "<>"
%token Op_LessThanEq    "<="
%token Op_GreaterThanEq ">="
%token Op_Equal         "="
%token Op_Add           "+"
%token Op_Sub           "-"
%token Op_Pow           "^"
%token Op_Mul           "*"
%token Op_LessThan      "<"
%token Op_GreaterThan   ">"

%token<char> Tk_CharConstant
%token<std::string> Tk_ID
%token<std::string> Tk_StringConstant
%token<int> Tk_IntConstant

%token Tk_Unknown
%token Tk_EOL
%token Tk_EOF

%%

PROGRAM: SUBTYPES_SEC OPT_EOL VARIABLE_SEC OPT_EOL SUBPROGRAM_DECL "inicio" OPT_EOL STATEMENTS OPT_EOL FIN OPT_EOL { std::cout << "Excellent grammar!" << std::endl; }
    ;

SUBTYPES_SEC: SUBTYPE_DECL
    ;

SUBTYPE_DECL: SUBTYPE_DECL "tipo" Tk_ID "es" TYPE Tk_EOL
    |
    ;

TYPE: "entero"
    | "booleano"
    | "caracter"
    | ARRAY_TYPE
    ;

ARRAY_TYPE: "arreglo" "[" Tk_IntConstant "]" "de" TYPE
    ;

VARIABLE_SEC: VARIABLE_DECL
    ;

VARIABLE_DECL: VARIABLE_DECL TYPE ID_1 Tk_EOL
    |
    ;

ID_1: Tk_ID IDS
    ;

IDS: IDS "," Tk_ID
    |
    ;

SUBPROGRAM_DECL: SUBPROGRAM_DECL SUBPROGRAM_HEADER Tk_EOL VARIABLE_SEC "inicio" OPT_EOL STATEMENTS "fin" OPT_EOL
    |
    ;

SUBPROGRAM_HEADER: FUNC_HEADER
    | PROC_HEADER
    ;

FUNC_HEADER: "funcion" Tk_ID ARGUMENT_DECLS ":" TYPE
    ;

PROC_HEADER: "procedimiento" Tk_ID ARGUMENT_DECLS
    ;

ARGUMENT_DECLS: "(" ARGUMENT_DECL ")"
    |
    ;

ARGUMENT_DECL: "var" TYPE Tk_ID MORE_ARGUMENT
    | TYPE Tk_ID MORE_ARGUMENT
    ;

MORE_ARGUMENT:  "," "var" TYPE Tk_ID MORE_ARGUMENT
    | "," TYPE Tk_ID MORE_ARGUMENT
    |
    ;

STATEMENTS: STATEMENTS STATEMENT OPT_EOL
        |
    ;

STATEMENT: LVALUE "<-" EXPR
    | "llamar" Tk_ID OPT_FUNC
    | "escriba" ARGS
    | "lea" LVALUE
    | "retorne" OPT_EXPR
    | SI_STMT
    | "mientras" EXPR OPT_EOL "haga" Tk_EOL STATEMENT_1 "fin" "mientras"
    | "repita" Tk_EOL STATEMENT_1 "hasta" EXPR
    | "para" LVALUE "<-" EXPR "hasta" EXPR "haga" Tk_EOL STATEMENT_1 "fin" "para"
    ;

STATEMENT_1: STATEMENT Tk_EOL STATEMENTS
    ;

SI_STMT: "si" EXPR OPT_EOL "entonces" OPT_EOL STATEMENT_1 OPT_SINOSI "fin" "si"
    ;

OPT_SINOSI: "sino" OPT_SINOSI2
    |
    ;

OPT_SINOSI2: "si" EXPR OPT_EOL "entonces" OPT_EOL STATEMENT_1 OPT_SINOSI
    | OPT_EOL STATEMENT_1
    ;

LVALUE: Tk_ID LVALUE_p
    ;

LVALUE_p: "[" EXPR "]"
    |
    ;

OPT_FUNC: "(" OPT_EXPRS ")"
    |
    ;

OPT_EXPRS: OPT_EXPRS EXPR ","
    | OPT_EXPRS EXPR
    |
    ;

ARGS: ARG MORE_ARGS
    ;

MORE_ARGS: "," ARG MORE_ARGS
    |
    ;

ARG: Tk_StringConstant
    | EXPR
    ;

OPT_EXPR: EXPR
    |
    ;

EXPR: TERM "=" EXPR
    | TERM "<>" EXPR
    | TERM "<=" EXPR
    | TERM ">=" EXPR
    | TERM "<" EXPR 
    | TERM ">" EXPR 
    | TERM
    ;

TERM: TERM "+" TERM2
    | TERM "-" TERM2
    | TERM "o" TERM2
    | TERM2
    ;

TERM2: TERM2 "*" TERM3
    | TERM2 "div" TERM3
    | TERM2 "mod" TERM3
    | TERM2 "y" TERM3
    | TERM3
    ;

TERM3: TERM3 "^" TERM4
    | TERM4
    ;

TERM4: "no" FACTOR
    | "-" FACTOR
    | FACTOR
    ;

FACTOR: Tk_IntConstant
    | Tk_CharConstant
    | BOOL
    | "(" EXPR ")"
    | RVALUE
    ;

RVALUE: Tk_ID RVALUE2
    ;

RVALUE2: "[" Tk_IntConstant "]"
    | OPT_FUNC
    ;

OPT_EOL: OPT_EOL Tk_EOL
    |
    ;

BOOL: "verdadero"
    | "falso"
    ;

FIN: "fin" OPT_EOL
    |"final" OPT_EOL
    ;

%%