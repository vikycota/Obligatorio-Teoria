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
palabrasEntreComillas=\" ~ \" 
//Las barras son para reconocer literal el " y no como abrir un comentario
nivel = "Nivel:"
palabrasSinComillas=[a-zA-ZáéíóúÁÉÍÓÚñÑ]+ 
//reconoce basicamente toda palabra
objetivo = "Objetivos:"
semanas="Semanas:"
numeros=[0-9][0-9]*
profe="Profesor:"
fecha="Fecha:"

%%

{plan} {
    return sym(sym.PLAN);
}
{nivel} {
    return sym(sym.NIVEL);
}

{palabrasEntreComillas} {return sym(sym.TextoComillas, yytext());}
{palabrasSinComillas} {return sym(sym.TextoSinComillas, yytext());}
{objetivo} {return sym(sym.Objetivos);}

"[" { return sym(sym.CorcheteAbre);}
"]" { return sym(sym.CorcheteCierra);}
"," {return sym(sym.Coma);}

{numeros} {return sym(sym.NUMERO, Integer.valueOf(yytext()));}
{semanas} {return sym(sym.Semanas);}

{profe} {return sym(sym.Profe);}

{fecha} {return sym(sym.Fecha);}
"/" {return sym(sym.Barra);}



//Dejar al final 
[ \t\r\n]+ { /* Ignorar espacios */ }
//consume el caracter y no hace nada, lo de adentro es un comentario

. { throw new Error("Carácter ilegal: " + yytext()); }
//cualquier caracter individual como esta al final coincide con otro antes si si servia