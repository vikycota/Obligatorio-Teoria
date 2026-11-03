import java_cup.runtime.*;
%%
/* Opciones de JFlex:
   %class  nombre de la clase Java generada (Lexer.java)
   %unicode acepta tildes y ñ
   %cup    se integra con CUP: yylex() devuelve objetos Symbol
   %line / %column  habilitan yyline / yycolumn (cuentan desde 0) */
%class Lexer
%unicode
%cup
%line
%column
%{
  // Crea el token con su línea y columna (+1 porque JFlex cuenta desde 0).
  // La segunda versión además guarda un valor (el texto o número leído).
  private Symbol symbol(int type) { return new Symbol(type, yyline+1, yycolumn+1); }
  private Symbol symbol(int type, Object val) { return new Symbol(type, yyline+1, yycolumn+1, val); }
%}

/* Macros: nombres para expresiones regulares reutilizables.
   ESPACIO: espacios, tabs y saltos de línea
   ENTERO:  número entero sin signo
   CADENA:  texto entre comillas, en una sola línea
   LETRA:   una letra (con tildes)
   PALABRA: una o más letras, ej. "Lunes", "INTERMEDIO" */
ESPACIO = [ \t\r\n]+
ENTERO  = [0-9]+
CADENA  = \"[^\"\n]*\"
LETRA   = [a-zA-ZáéíóúÁÉÍÓÚñÑüÜ]
PALABRA = {LETRA}+
%%

/* Reglas. JFlex toma el match más largo; si empatan, gana la que aparece primero.
   Por eso las palabras clave van ANTES de {PALABRA}. */
"PLAN"      { return symbol(sym.PLAN); }
"Semanas:"  { return symbol(sym.SEMANAS); }
"Día:" | "Dia:" { return symbol(sym.DIA); }
"Nivel:"    { return symbol(sym.NIVEL); }
{PALABRA}   { return symbol(sym.PALABRA, yytext()); /* genérica: el valor se valida en el parser */ }
{ENTERO}    { return symbol(sym.ENTERO, Integer.parseInt(yytext())); }
{CADENA}    { return symbol(sym.CADENA, yytext().substring(1, yytext().length()-1)); /* quita las comillas */ }
{ESPACIO}   { /* ignorar */ }
/* Cualquier otro carácter no reconocido es error léxico. Debe ir última. */
[^]         { System.err.println("Error léxico, línea " + (yyline+1) + ": '" + yytext() + "'"); }
