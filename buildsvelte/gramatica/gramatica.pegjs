start
    // Define el inicio de la gramática.
    = (rule (whitespace ";"? whitespace rule)* ";"? whitespace)* !. { return "Gramatica Aceptada"; }

identifier
    // Define un identificador válido.
    = [_a-zA-Z][_a-zA-Z0-9]* { return text(); }

text
    // Define cadenas de texto entre comillas simples o dobles, opcionalmente insensibles a mayúsculas/minúsculas.
    = '"' [^"]* '"' [i]? { return text(); }
    / "'" [^']* "'" [i]? { return text(); }

whitespace
    // Define espacios en blanco.
    = [ \t\r\n]*

number
    // Define un número compuesto por dígitos.
    = [0-9]+ { return parseInt(text(), 10); }

instances
    // Define los operadores "*", "+", "?" y repeticiones específicas.
    = "" { return ""; }
    / "+" { return "+"; }
    / "?" { return "?"; }
    / "|" number ".." number? ","? whitespace* { return text(); }
    / "|" number { return text(); }

open_bracket
    // Define el carácter "[".
    = "[" { return "["; }

close_bracket
    // Define el carácter "]".
    = "]" { return "]"; }

class
    // Define una clase de caracteres entre corchetes, incluyendo soporte para case-insensitive.
    = "[" [^]]* "]" [i]? { return text(); }

range
    // Define un rango de caracteres o un conjunto de caracteres.
    = [^[\]-] "-" [^[\]-] { return text(); }
    / [^[\]]+ { return text(); }

rule
    // Define una regla con un identificador, un "=" y alternativas de expresiones.
    = identifier whitespace "=" whitespace alternative whitespace ";"? { return text(); }

alternative
    // Define una lista de expresiones separadas por "/".
    = expression_list (whitespace "/" whitespace expression_list)* { return text(); }

expression_list
    // Define una lista de expresiones opcionales.
    = expression whitespace instances? (whitespace expression whitespace instances?)* { return text(); }

expression
    // Define una expresión que puede ser texto, identificador, grupo, clase o número.
    = text
    / identifier
    / group
    / class
    / number

group
    // Define un grupo de alternativas entre paréntesis o corchetes.
    = "(" whitespace alternative whitespace ")" { return text(); }
    / "[" whitespace alternative whitespace "]" { return text(); }