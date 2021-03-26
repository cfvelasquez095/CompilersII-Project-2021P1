%language "c++"
%define parse.error verbose
%define api.value.type variant
%define api.parser.class {Parser}
%define api.namespace {Expr}
%parse-param {list &expr_list}

%code requires {
    #include <string>
    #include <unordered_map>
    #include "ast.h"
}

%{
    #include <iostream>
    #include <stdexcept>
    #include <string>
    #include <unordered_map>
    #include <vector>
    #include "ast.h"
    #include "tokens.h"

    extern int yylineno;

    namespace Expr {
        void Parser::error(const std::string &msg) {
            std::cout<<"linea:" << yylineno << " " << msg << std::endl;
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

%token<std::string> Tk_CharConstant
%token<std::string> Tk_ID
%token<std::string> Tk_StringConstant
%token<int> Tk_IntConstant

%token Tk_Unknown
%token Tk_EOL
%token Tk_EOF 0 "end of file"

%type <Ast::Expr*> ARG ARGS ASSIGN BOOL EXPR FACTOR LVALUE MORE_ARGS RVALUE STATEMENT STATEMENTS STATEMENT_1 TERM TERM2 TERM3 TERM4 TYPE VARIABLE_SEC VARIABLE_DECL
%type <id_list*> ID_1

%right "<-"
%left '=' "<>" '<' '>' "<=" ">="
%left '+' '-'
%left '*' '/'
%nonassoc '|' UMINUS

%%

PROGRAM: SUBTYPES_SEC OPT_EOL VARIABLE_SEC_OPT OPT_EOL SUBPROGRAM_DECL "inicio" OPT_EOL STATEMENTS OPT_EOL FIN OPT_EOL
    ;

SUBTYPES_SEC: SUBTYPE_DECL
    ;

SUBTYPE_DECL: SUBTYPE_DECL "tipo" Tk_ID "es" TYPE Tk_EOL
    |
    ;

TYPE: "entero" { $$ = new Ast::IntType(); }
    | "booleano" { $$ = new Ast::BoolType(); }
    | "caracter" { $$ = new Ast::CharType(); }
    | ARRAY_TYPE
    ;

ARRAY_TYPE: "arreglo" "[" Tk_IntConstant "]" "de" TYPE
    ;

VARIABLE_SEC_OPT: VARIABLE_SEC OPT_EOL
    |
    ;

VARIABLE_SEC: VARIABLE_SEC OPT_EOL VARIABLE_DECL {
            $$ = $1;
            reinterpret_cast<Ast::VarSection*>($$)->varDeclarations.push_back($3);
            expr_list.push_back($3);
        }
    | VARIABLE_DECL {
            list temp;
            temp.push_back($1);
            $$ = new Ast::VarSection(temp);
            expr_list.push_back($1);
        }
    ;

VARIABLE_DECL: TYPE ID_1 Tk_EOL { $$ = new Ast::VarDeclaration($1,$2);}
    ;

ID_1: ID_1 "," Tk_ID {
            $$ = $1;
            reinterpret_cast<std::vector<std::string>*>($$)->push_back($3);
        }
    | Tk_ID {
            id_list *temp= new std::vector<std::string>();
            temp->push_back($1);
            $$= temp;
        }
    | { $$ = nullptr; }
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

STATEMENTS: STATEMENTS OPT_EOL STATEMENT {
            $$ = $1;
            expr_list.push_back($3);
        }
    | STATEMENT {
            $$ = $1;
            expr_list.push_back($1);
        }
    ;

STATEMENT: ASSIGN { $$ = $1; }
    | "llamar" Tk_ID OPT_FUNC
    | "escriba" ARGS { $$ = new Ast::PrintExpr($2); }
    | "lea" LVALUE
    | "retorne" OPT_EXPR
    | SI_STMT
    | "mientras" EXPR OPT_EOL "haga" Tk_EOL STATEMENT_1 "fin" "mientras" { $$ = new Ast::WhileStmt($2, $6); }
    | "repita" Tk_EOL STATEMENT_1 "hasta" EXPR
    | "para" LVALUE "<-" EXPR "hasta" EXPR "haga" Tk_EOL STATEMENT_1 "fin" "para"
    ;

STATEMENT_1: STATEMENT_1 OPT_EOL STATEMENT {
            $$ = $1;
            reinterpret_cast<Ast::ExprList*>($$)->exprList.push_back($3);
        }
    | STATEMENT {
            mult_expr_list e;
            e.push_back($1);
            $$ = new Ast::ExprList(e);
        }
    ;

SI_STMT: "si" EXPR OPT_EOL "entonces" OPT_EOL STATEMENT_1 OPT_SINOSI "fin" "si"
    ;

OPT_SINOSI: "sino" OPT_SINOSI2
    |
    ;

OPT_SINOSI2: "si" EXPR OPT_EOL "entonces" OPT_EOL STATEMENT_1 OPT_SINOSI
    | OPT_EOL STATEMENT_1
    ;

ASSIGN: Tk_ID "<-" EXPR { $$ = new Ast::AssignExpr($1,$3); }

LVALUE: Tk_ID LVALUE_p { $$ = new Ast::IdentExpr($1); }
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

ARGS: ARG MORE_ARGS { $$ = $1; }
    ;

MORE_ARGS: "," ARG MORE_ARGS
    | { $$ = nullptr; }
    ;

ARG: Tk_StringConstant { $$= new Ast::StringConst($1); }
    | EXPR
    ;

OPT_EXPR: EXPR
    |
    ;

EXPR: TERM "=" EXPR { $$ = new Ast::EqualsExpr($1,$3); }
    | TERM "<>" EXPR { $$ = new Ast::NotEqualsExpr($1,$3); }
    | TERM "<=" EXPR { $$ = new Ast::LessThanEqExpr($1,$3); }
    | TERM ">=" EXPR { $$ = new Ast::GreaterThanEqExpr($1,$3); }
    | TERM "<" EXPR { $$ = new Ast::LessThanExpr($1,$3); }
    | TERM ">" EXPR { $$ = new Ast::GreaterThanExpr($1,$3); }
    | TERM { $$ = $1; }
    ;

TERM: TERM "+" TERM2 { $$ = new Ast::AddExpr($1,$3); }
    | TERM "-" TERM2 { $$ = new Ast::SubExpr($1,$3); }
    | TERM "o" TERM2 { $$ = new Ast::OrExpr($1,$3); }
    | TERM2 { $$ = $1; }
    ;

TERM2: TERM2 "*" TERM3 { $$ = new Ast::MultExpr($1,$3); }
    | TERM2 "div" TERM3 { $$ = new Ast::DivExpr($1,$3); }
    | TERM2 "mod" TERM3 { $$ = new Ast::ModExpr($1,$3); }
    | TERM2 "y" TERM3 { $$ = new Ast::AndExpr($1,$3); }
    | TERM3 { $$ = $1; }
    ;

TERM3: TERM3 "^" TERM4 { $$ = new Ast::PowExpr($1,$3); }
    | TERM4 { $$ = $1; }
    ;

TERM4: "no" FACTOR {$$ = new Ast::UnaryExpr($2); }
    | "-" FACTOR %prec UMINUS { $$ = new Ast::NotExpr($2); }
    | FACTOR { $$ = $1; }
    ;

FACTOR: Tk_IntConstant { $$ = new Ast::NumberExpr($1); }
    | Tk_CharConstant { $$ = new Ast::CharConst($1); }
    | BOOL
    | "(" EXPR ")" { $$ = $2; }
    | RVALUE { $$ = $1; }
    ;

RVALUE: Tk_ID RVALUE2 { $$ = new Ast::IdentExpr($1); }
    ;

RVALUE2: "[" Tk_IntConstant "]"
    | OPT_FUNC
    ;

OPT_EOL: OPT_EOL Tk_EOL
    |
    ;

BOOL: "verdadero" { $$ = new Ast::TrueExpr(); }
    | "falso" { $$ = new Ast::FalseExpr(); }
    ;

FIN: "fin" OPT_EOL
    |"final" OPT_EOL
    ;

%%