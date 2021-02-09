%require "3.0"
%language "c++"
%define parse.error verbose
%define api.value.type variant
%define api.parser.class {Parser}
%define api.namespace {Expr}
%parse-param { std::unordered_map<std::string, double>& vars }

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
%token Op_Equal         "=="
%token Op_NotEqual      "<>"
%token Op_LessThanEq    "<="
%token Op_GreaterThanEq ">="
%token Op_Add           "+"
%token Op_Sub           "-"
%token Op_Pow           "^"
%token Op_Mul           "*"
%token Op_LessThan      "<"
%token Op_GreaterThan   ">"

%token<char> Tk_CharConstant
%token<std::string> Tk_ID
%token<std::string> Tk_StringConstant
%token<int> Tk_BinConstant
%token<int> Tk_HexConstant
%token<int> Tk_IntConstant

%type<int> expr term factor

%%

%%