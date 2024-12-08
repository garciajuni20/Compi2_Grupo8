start
    // Define el inicio de la gramática.
    = (rule (whitespace ";" whitespace rule)* ";"? whitespace)* !. { return "Gramatica Aceptada"; }

identifier
    // Define un identificador válido.
    = [_a-zA-Z][_a-zA-Z0-9]* { return text(); }

text
    // Define cadenas de texto entre comillas simples o dobles.
    = '"' [^"]* '"' { return text(); }
    / "'" [^']* "'" { return text(); }

whitespace
    // Define espacios en blanco.
    = [ \t\r\n]*

number
    // Define un número compuesto de dígitos.
    = [0-9]+ { return parseInt(text(), 10); }

instances
    // Define los operadores "*", "+" y "?".
    = "*" { return "*"; }
    / "+" { return "+"; }
    / "?" { return "?"; }

open_bracket
    // Define el carácter "[".
    = "[" { return "["; }

close_bracket
    // Define el carácter "]".
    = "]" { return "]"; }

class
    // Define una clase de caracteres entre corchetes.
    = open_bracket range+ close_bracket { return text(); }

range
    // Define un rango de caracteres o conjunto de caracteres.
    = [^[\]-] "-" [^[\]-] { return text(); }
    / [^[\]]+ { return text(); }

rule
    // Define una regla que incluye un identificador, un "=" y alternativas de expresiones.
    = whitespace identifier whitespace "=" whitespace alternative whitespace { return text(); }

alternative
    // Define una alternativa de expresiones separadas por "/".
    = expression_list (whitespace "/" whitespace expression_list)* { return text(); }

expression_list
    // Define un listado de expresiones opcionales.
    = expression whitespace instances? (whitespace expression whitespace instances?)* { return text(); }

expression
    // Define una expresión: texto, identificador, grupo, clase o número.
    = text
    / identifier
    / group
    / class
    / number

group
    // Define un grupo de alternativas.
    = "[" whitespace alternative whitespace "-" whitespace alternative whitespace "]" { return text(); }
    / "[" whitespace alternative whitespace "]" { return text(); }
    / "(" whitespace alternative whitespace ")" { return text(); }
