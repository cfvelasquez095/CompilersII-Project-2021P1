%option noyywrap
%option nodefault
%option caseless

%{
  #include <iostream>
  #include <cstdio>
  #include <cstring>
  #include "tokens.h"
  #define YY_DECL int yylex(Expr::Parser::semantic_type *yylval)
  #define yyterminate() return Expr::Parser::token::Tk_EOF

  using Token = Expr::Parser::token;
%}

%x LINE_COMMENT
%x BLOCK_COMMENT

%%

[ \t]     { /* Skip Whitespaces */ }
[\r?\n]   { yylineno++; return Token::Tk_EOL;}
"//"      { BEGIN(LINE_COMMENT); }
"/*"      { BEGIN(BLOCK_COMMENT); }

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
"es"            return Token::Kw_Es;
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

"\["  return Token::Tk_OpenBracket;
"\]"  return Token::Tk_CloseBracket;
"("   return Token::Tk_OpenPar;
")"   return Token::Tk_ClosePar;
","   return Token::Tk_Comma;
":"   return Token::Tk_Colon;

"<-"  return Token::Op_Assign;
"<>"  return Token::Op_NotEqual;
"<="  return Token::Op_LessThanEq;
">="  return Token::Op_GreaterThanEq;
"="   return Token::Op_Equal;
"+"   return Token::Op_Add;
"-"   return Token::Op_Sub;
"\^"  return Token::Op_Pow;
"*"   return Token::Op_Mul;
"<"   return Token::Op_LessThan;
">"   return Token::Op_GreaterThan;

[_a-zA-Z][_a-zA-Z0-9]*              return Token::Tk_ID;
[0-9]+|"0x"[0-9A-Fa-f]+|"0b"[0-1]+  return Token::Tk_IntConstant;
\"[^"(\r?\n)]*\"                    return Token::Tk_StringConstant;
\'[^"(\r?\n')]*\'                   return Token::Tk_CharConstant;

.     return Token::Tk_Unknown;

<LINE_COMMENT>.           { /* Nothing */}
<LINE_COMMENT>\r?\n       { BEGIN(INITIAL); return Token::Tk_EOL;}
<LINE_COMMENT><<EOF>>     yyterminate();

<BLOCK_COMMENT>"*/"       { BEGIN(INITIAL); }
<BLOCK_COMMENT>(.|\r?\n)  { /* Nothing */}
<BLOCK_COMMENT><<EOF>>    { std::cout << "Unclosed block comment." << std::endl; yyterminate();}

<<EOF>> yyterminate();

%%