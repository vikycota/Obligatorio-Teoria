import java_cup.runtime.*;
%%
%unicode
%cup
%line
%column
%{
private Symbol sym(int type) {
return new Symbol(type, yyline, yycolumn);
}
private Symbol sym(int type, Object value) {
return new Symbol(type, yyline, yycolumn, value);}
%}

/* TOKEN1 regular expression */
plan = "PLAN" 
palabrasEntreComillas=\" ~ \" #Las barras son para reconocer literal el " y no como abrir un comentario

%%

{plan} {
    return sym(sym.PLAN);
}

{palabrasEntreComillas} {
    return sym(sym.TextoComillas, yytext());
}