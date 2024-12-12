// Define el inicio de la gramática.
start
    = (rule (whitespace ";"? whitespace rule)* whitespace "!"?) { return "Gramatica Aceptada"; }

// Identificadores válidos.
identifier
    = [_a-zA-Z][_a-zA-Z0-9]* { return text(); }

// Literales de texto, sensibles o no a mayúsculas.
text
    = '"' [^"]* '"' "i"? { return text(); }
    / "'" [^']* "'" "i"? { return text(); }

// Espacios en blanco y comentarios.
whitespace
    = ([ \t\r\n] / comment)*
comment
    = "//" [^\n]*
    / "/*" [^]* "*/"

// Números enteros.
number
    = [0-9]+ { return parseInt(text(), 10); }

// Operadores de repetición y rangos.
instances
    = "*" { return "*"; }
    / "+" { return "+"; }
    / "?" { return "?"; }
    / "|" range "|" { return text(); }
range
    = min:number ".." max:number? { return { min, max }; }
    / ".." max:number { return { min: 0, max }; }
    / min:number ".." { return { min, max: Infinity }; }

// Clases de caracteres, sensibles o no a mayúsculas.
class
    = "[" [^\]]* "]" "i"? { return text(); }

// Grupos de alternativas.
group
    = "(" whitespace alternative whitespace ")" { return text(); }
    / "[" whitespace alternative whitespace "]" { return text(); }

// Rango de caracteres o conjunto dentro de clases.
range
    = [^[\]-] "-" [^[\]-] { return text(); }
    / [^[\]]+ { return text(); }

// Reglas.
rule
    = identifier whitespace "=" whitespace alternative whitespace { return text(); }

// Alternativas separadas por "/".
alternative
    = expression_list (whitespace "/" whitespace expression_list)* { return text(); }

// Lista de expresiones.
expression_list
    = expression whitespace instances? (whitespace expression whitespace instances?)* { return text(); }

// Expresiones: literales, identificadores, grupos, clases, números o aserciones.
expression
    = text
    / identifier
    / group
    / class
    / number
    / assertion
assertion
    = "&" expression { return { type: "positive", expression }; }
    / "!" expression { return { type: "negative", expression }; }

// Etiquetas y operadores adicionales.
labeled_expression
    = label:identifier ":" expression { return { label, expression }; }
    / "@" (label:identifier ":")? expression { return { pluck: true, label, expression }; }

// Concatenación de expresiones.
concatenation
    = expression (whitespace expression)* { return text(); }

// Expresiones con delimitadores.
repetition_with_delimiter
    = expression "|" min:number? ".." max:number? ("," delimiter:expression)? "|" { return { expression, min, max, delimiter }; }