#include <iostream>
#include <stdexcept>
#include "tokens.h"

extern Expr::Parser::token_type yylex(Expr::Parser::semantic_type * yylval);
extern char * yytext;

using Token = Expr::Parser::token;

std::string TokenToString(Expr::Parser::token::yytokentype tk) {
    switch(tk){
        case Token::Kw_Abrir:           return "abrir";
        case Token::Kw_Archivo:         return "archivo";
        case Token::Kw_Arreglo:         return "arreglo";
        case Token::Kw_Booleano:        return "booleano";
        case Token::Kw_Cadena:          return "cadena";
        case Token::Kw_Caracter:        return "caracter";
        case Token::Kw_Caso:            return "caso";
        case Token::Kw_Cerrar:          return "cerrar";
        case Token::Kw_Como:            return "como";
        case Token::Kw_De:              return "de";
        case Token::Kw_Div:             return "div";
        case Token::Kw_Entero:          return "entero";
        case Token::Kw_Entonces:        return "entonces";
        case Token::Kw_Es:              return "es";
        case Token::Kw_Escriba:         return "escriba";
        case Token::Kw_Escribir:        return "escribir";
        case Token::Kw_Escritura:       return "escritura";
        case Token::Kw_Falso:           return "falso";
        case Token::Kw_Fin:             return "fin";
        case Token::Kw_Final:           return "final";
        case Token::Kw_Funcion:         return "funcion";
        case Token::Kw_Haga:            return "haga";
        case Token::Kw_Hasta:           return "hasta";
        case Token::Kw_Inicio:          return "inicio";
        case Token::Kw_Lea:             return "lea";
        case Token::Kw_Lectura:         return "lectura";
        case Token::Kw_Leer:            return "leer";
        case Token::Kw_Llamar:          return "llamar";
        case Token::Kw_Mientras:        return "mientras";
        case Token::Kw_Mod:             return "mod";
        case Token::Kw_No:              return "no";
        case Token::Kw_O:               return "o";
        case Token::Kw_Para:            return "para";
        case Token::Kw_Procedimiento:   return "procedimiento";
        case Token::Kw_Real:            return "real";
        case Token::Kw_Registro:        return "registro";
        case Token::Kw_Repita:          return "repita";
        case Token::Kw_Retorne:         return "retorne";
        case Token::Kw_Secuencial:      return "secuencial";
        case Token::Kw_Si:              return "si";
        case Token::Kw_Sino:            return "sino";
        case Token::Kw_Tipo:            return "tipo";
        case Token::Kw_Var:             return "var";
        case Token::Kw_Verdadero:       return "verdadero";
        case Token::Kw_Y:               return "y";
        case Token::Tk_OpenBracket:     return "[";
        case Token::Tk_CloseBracket:    return "]";
        case Token::Tk_OpenPar:         return "(";
        case Token::Tk_ClosePar:        return ")";
        case Token::Tk_Comma:           return ",";
        case Token::Tk_Colon:           return ":";
        case Token::Op_Assign:          return "<-";
        case Token::Op_Equal:           return "=";
        case Token::Op_NotEqual:        return "<>";
        case Token::Op_LessThanEq:      return "<=";
        case Token::Op_GreaterThanEq:   return ">=";
        case Token::Op_Add:             return "+";
        case Token::Op_Sub:             return "-";
        case Token::Op_Pow:             return "^";
        case Token::Op_Mul:             return "*";
        case Token::Op_LessThan:        return "<";
        case Token::Op_GreaterThan:     return ">";
        case Token::Tk_CharConstant:    return "CharConstant";
        case Token::Tk_ID:              return "ID";
        case Token::Tk_StringConstant:  return "StringConstant";
        case Token::Tk_IntConstant:     return "IntConstant";
        case Token::Tk_EOF:             return "EOF";
        case Token::Tk_Unknown:         return "Unknown";
        case Token::Tk_EOL:             return "EOL";
        
        default: return "Token does not exist";  
    } 
}

void ExecuteLexer() {
    Expr::Parser::semantic_type yylval;
    Expr::Parser::token_type tk;

    tk= yylex(&yylval);

    while(tk!= Expr::Parser::token::Tk_EOF){
        std::cout<<"Lexeme: " << yytext << "; Token: " << TokenToString(tk)<< std::endl;
        tk = yylex(&yylval);
    }
}

void ExecuteParser() {
    try {
        Expr::Parser parser;
        parser();
    } catch(std::runtime_error&  ex) {
        std::cout << ex.what() << std::endl;
    }
}

int main() {
    // ExecuteLexer();
    ExecuteParser();

    return 0;
}