%option noyywrap
%option nodefault
%option caseless

%{
  #include <iostream>
  #include <cstdio>
  #include <cstring>
  #include "tokens.h"
  #define YY_DECL int yylex(Expr::Parser::semantic_type *yylval)

  using Token = Expr::Parser::token;
%}

%x bcomment

%%

[ \t\r\n] { /* Skip Whitespaces */ }
"//"[^\n]*\n { /* Line Comment */ }
"/*" {BEGIN(bcomment);}

"abrir"         return Token::Kw_Abrir;
"archivo"       return Token::Kw_Archivo;
"arreglo"       return Token::Kw_Arreglo;
"booleano"      return Token::Kw_Booleano;
"cadena"        return Token::Kw_Cadena;
"caracter"      return Token::Kw_Caracter;
"caso"          return Token::Kw_Caso;
"cerrar"        return Token::Kw_Cerrar;
"como"          return Token::Kw_Como;
"de"            return Token::Kw_De;
"div"           return Token::Kw_Div;
"entero"        return Token::Kw_Entero;
"entonces"      return Token::Kw_Entonces;
"escriba"       return Token::Kw_Escriba;
"escribir"      return Token::Kw_Escribir;
"escritura"     return Token::Kw_Escritura;
"falso"         return Token::Kw_Falso;
"fin"           return Token::Kw_Fin;
"final"         return Token::Kw_Final;
"funcion"       return Token::Kw_Funcion;
"haga"          return Token::Kw_Haga;
"hasta"         return Token::Kw_Hasta;
"inicio"        return Token::Kw_Inicio;
"lea"           return Token::Kw_Lea;
"lectura"       return Token::Kw_Lectura;
"leer"          return Token::Kw_Leer;
"llamar"        return Token::Kw_Llamar;
"mientras"      return Token::Kw_Mientras;
"mod"           return Token::Kw_Mod;
"no"            return Token::Kw_No;
"o"             return Token::Kw_O;
"para"          return Token::Kw_Para;
"procedimiento" return Token::Kw_Procedimiento;
"real"          return Token::Kw_Real;
"registro"      return Token::Kw_Registro;
"repita"        return Token::Kw_Repita;
"retorne"       return Token::Kw_Retorne;
"secuencial"    return Token::Kw_Secuencial;
"si"            return Token::Kw_Si;
"sino"          return Token::Kw_Sino;
"tipo"          return Token::Kw_Tipo;
"var"           return Token::Kw_Var;
"verdadero"     return Token::Kw_Verdadero;
"y"             return Token::Kw_Y;

[\[]  return Token::Tk_OpenBracket;
[\]]  return Token::Tk_CloseBracket;
[(]   return Token::Tk_OpenPar;
[)]   return Token::Tk_ClosePar;
[,]   return Token::Tk_Comma;
[:]   return Token::Tk_Colon;

[<-]  return Token::Op_Assign;
[==]  return Token::Op_Equal;
[<>]  return Token::Op_NotEqual;
[<=]  return Token::Op_LessThanEq;
[>=]  return Token::Op_GreaterThanEq;
[+]   return Token::Op_Add;
[-]   return Token::Op_Sub;
[\^]  return Token::Op_Pow;
[*]   return Token::Op_Mul;
[<]   return Token::Op_LessThan;
[>]   return Token::Op_GreaterThan;

[_a-zA-Z][_a-zA-Z0-9]*  { yylval->emplace<std::string>(yytext, yyleng); return Token::Tk_ID; }
[0-9]+                  { yylval->emplace<int>(atoi(yytext)); return Token::Tk_IntConstant; }
"0x"[0-9A-Fa-f]+        { yylval.emplace<int>(std::stol(yytext, nullptr, 0)); return token::Tk_HexConstant; }
"0b"[0-1]+              { yylval.emplace<int>(std::stol(yytext, nullptr, 0)); return token::Tk_BinConstant; }
\"[^\n]+\"              { yylval->emplace<std::string>(yytext, yyleng);return Token::Tk_StringConstant; }
"'"[^\n]"'"|"'"[\\n]"'"|"'"[\\t]"'"|"'"[\\r]"'"|"'"[\\]"'"|"'"[\\"]"'"  { 
                          yylval.emplace<char>(yytext, yyleng); return token::Tk_CharConstant; }
. std::cout << "Invalid symbol " << yytext << std::endl;

<bcomment>"*/" { BEGIN(INITIAL); }
<bcomment>.|\n { /* Nothing */}
<bcomment><<EOF>> { std::cout << "Error no cerró comentario" << '\n'; }

%%