import java_cup.runtime.*;
%%
%class Lexer
%unicode
%cup
%line
%column
%{
  private Symbol symbol(int type) { return new Symbol(type, yyline+1, yycolumn+1); }
  private Symbol symbol(int type, Object val) { return new Symbol(type, yyline+1, yycolumn+1, val); }
%}
ESPACIO = [ \t\r\n]+
ENTERO  = [0-9]+
CADENA  = \"[^\"\n]*\"
%%
"PLAN"      { return symbol(sym.PLAN); }
"Semanas:"  { return symbol(sym.SEMANAS); }
{ENTERO}    { return symbol(sym.ENTERO, Integer.parseInt(yytext())); }
{CADENA}    { return symbol(sym.CADENA, yytext().substring(1, yytext().length()-1)); }
{ESPACIO}   { /* ignorar */ }
[^]         { System.err.println("Error léxico, línea " + (yyline+1) + ": '" + yytext() + "'"); }