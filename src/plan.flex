/* =====================================================================
   plan.flex  -  Analizador léxico del plan de entrenamiento
   Solo reconoce tokens. Los valores (día válido, fecha real, rangos...)
   se validan en plan.cup.
   ===================================================================== */
import java_cup.runtime.*;

%%

%class Lexer
%unicode
%cup
%line
%column

%{
  // Todos los tokens llevan su texto como valor, así los mensajes de
  // error sintáctico pueden mostrar qué token apareció.
  private Symbol symbol(int type) {
    return new Symbol(type, yyline + 1, yycolumn + 1, yytext());
  }
  private Symbol symbol(int type, Object val) {
    return new Symbol(type, yyline + 1, yycolumn + 1, val);
  }
  private void errorLexico(String msg) {
    parser.reportar(yyline + 1, "léxico", msg);
  }
%}

ESPACIO  = [ \t\r\n\f]+
DIGITO   = [0-9]
ENTERO   = {DIGITO}+
DECIMAL  = {DIGITO}+(\.{DIGITO}+)?
LETRA    = [a-zA-ZáéíóúÁÉÍÓÚñÑüÜ]
PALABRA  = {LETRA}+
CADENA   = \"[^\"\n]*\"

/* Se reconoce cualquier n/n/n como fecha y cualquier n/n como fracción;
   si el formato o los rangos están mal se avisa en el parser, con un
   mensaje más claro que un error léxico. */
FECHA    = {ENTERO}"/"{ENTERO}"/"{ENTERO}
FRACCION = {ENTERO}"/"{ENTERO}

%%

/* ---------- Encabezado (Persona 1) ---------- */
"PLAN"                          { return symbol(sym.PLAN); }
"Nivel:"                        { return symbol(sym.NIVEL); }
"Objetivos:"                    { return symbol(sym.OBJETIVOS); }
"Semanas:"                      { return symbol(sym.SEMANAS); }
"Profesor:"                     { return symbol(sym.PROFESOR); }
"Fecha:"                        { return symbol(sym.FECHA_KW); }

/* ---------- Campos de rutina (Persona 1) ---------- */
"RUTINA"                        { return symbol(sym.RUTINA); }
"Día:" | "Dia:"                 { return symbol(sym.DIA); }
"Calentamiento:"                { return symbol(sym.CALENTAMIENTO); }
"Intensidad:"                   { return symbol(sym.INTENSIDAD); }
"Duración:" | "Duracion:"       { return symbol(sym.DURACION); }
"Músculos:" | "Musculos:"       { return symbol(sym.MUSCULOS); }
"Equipamiento:"                 { return symbol(sym.EQUIPAMIENTO); }
"Variantes:"                    { return symbol(sym.VARIANTES); }
"Extra:"                        { return symbol(sym.EXTRA); }
"Obs:" | "Observaciones:"       { return symbol(sym.OBS); }
"EJERCICIOS:"                   { return symbol(sym.EJERCICIOS); }

/* ---------- Ejercicios (Persona 2, provisorio) ---------- */
[Ss][Uu][Pp][Ee][Rr][Ss][Ee][Rr][Ii][Ee]  { return symbol(sym.SUPERSERIE); }
[Ff][Ii][Nn]                    { return symbol(sym.FIN); }
"descanso"                      { return symbol(sym.DESCANSO); }
"reps"                          { return symbol(sym.REPS); }
"vuelta" | "vueltas"            { return symbol(sym.VUELTA); }
{ENTERO}"x"{ENTERO}             { return symbol(sym.SERIES_REPS); }
{ENTERO}"xMAX"                  { return symbol(sym.SERIES_MAX); }
{ENTERO}"x"{ENTERO}(h|m|s)      { return symbol(sym.SERIES_TIEMPO); }
{DECIMAL}(kg|lb|"%1RM")         { return symbol(sym.CARGA); }
{DECIMAL}"km/h"                 { return symbol(sym.VELOCIDAD); }
"@"                             { return symbol(sym.ARROBA); }

/* ---------- Igual a (Persona 3, provisorio) ---------- */
"Igual"{ESPACIO}"a"             { return symbol(sym.IGUAL_A); }
"EXCEPTO"                       { return symbol(sym.EXCEPTO); }
"x"                             { return symbol(sym.POR); }
"vez" | "veces"                 { return symbol(sym.VEZ); }
{ENTERO}"%"                     { return symbol(sym.PORCENTAJE); }

/* ---------- Valores compartidos ---------- */
{FECHA}                         { return symbol(sym.FECHA); }
{FRACCION}                      { return symbol(sym.FRACCION); }
{ENTERO}(h|m|s)                 { return symbol(sym.TIEMPO); }
\*+                             { return symbol(sym.ESTRELLAS); }
{ENTERO}                        { return symbol(sym.ENTERO, Integer.parseInt(yytext())); }
{CADENA}                        { return symbol(sym.CADENA, yytext().substring(1, yytext().length() - 1)); }
{PALABRA}                       { return symbol(sym.PALABRA); }

":"                             { return symbol(sym.DOSPUNTOS); }
","                             { return symbol(sym.COMA); }
"["                             { return symbol(sym.CORCH_A); }
"]"                             { return symbol(sym.CORCH_C); }
"="                             { return symbol(sym.IGUAL); }

{ESPACIO}                       { /* ignorar */ }

/* ---------- Errores léxicos ---------- */
\"[^\"\n]*                      { errorLexico("texto entre comillas sin cerrar: " + yytext()); }
{ENTERO}{LETRA}+                { errorLexico("número pegado a letras o unidad desconocida: '" + yytext() + "'"); }
[^]                             { errorLexico("carácter inválido '" + yytext() + "'"); }
