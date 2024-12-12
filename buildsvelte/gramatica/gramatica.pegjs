// Inicio de la gramática: la regla principal
start 
    = newline first:rule rest:(newline rule)* newline 
    { 
        // Si se parsea correctamente, devuelve un mensaje indicando que la gramática es aceptada
        return "Gramatica Aceptada"; 
    }

// Regla para definir las "rules" o las partes principales de la gramática
rule 
    = name:identifier newline string? newline "=" _ expression:choices newline? (_ ";" _)?
    { 
        // Cada regla tiene un nombre (identifier), una expresión (choices) y puede tener una cadena opcional
        return { name: name, expression: expression }; 
    }

// Manejo de opciones (choices), es decir, varias posibles combinaciones para una misma regla
choices 
    = first:concat rest:(newline "/" newline concat)* { 
        // Combina la primera opción con el resto, que pueden venir después de un "/"
        return [first, ...rest.map(r => r[2])];
    }

// Concatenación de elementos dentro de una opción
concat 
    = pluck (_ pluck )*

// "Pluck" representa un elemento de la concatenación, puede tener un operador especial "@" antes
pluck 
    = "@"? label

// Etiqueta que combina un identificador opcional con una expresión
label
    = (identifier ":")? expression

// Define una expresión que puede tener varias formas y combinaciones
expression
    = par:parserexpression l:locks? 
    / "$"? _ parserexpression _ locks?
    / "&"? _ parserexpression _ locks?
    / "!"? _ parserexpression _ locks?
    / ":"? _ parserexpression _ locks?
    / "?"? _ parserexpression _ locks?
    / "+"? _ parserexpression _ locks?

// Expresión específica que puede ser un identificador, un rango, un grupo o un string
parserexpression
    = identifier
    / range "i"?
    / groups
    / string "i"?
    / (_ "." _)+ _ (newline)? _
    / (_"!."_)+ _ (newline)? _

// Define un grupo de elecciones, encerrado entre paréntesis
groups
    = "(" _ choices _ ")"

// Locks para definir restricciones o repeticiones (e.g., "?" para opcional, "*" para 0 o más)
locks
    = [?+*]
    / "|" _ (number / identifier) _ "|"
    / "|" _ (number / identifier)? _ ".." _ (number / identifier)? _ "|"
    / "|" _ (number / identifier)? _ "," _ choices _ "|"
    / "|" _ (number / identifier)? _ ".." _ (number / identifier)? _ "," _ choices _ "|"

// Identificadores (nombre de reglas, variables, etc.)
identifier 
    = name:[_a-z]i[_a-z0-9]i* { 
        // Devuelve el texto capturado como identificador
        return text(); 
    }

// Definición de cadenas de texto
string
    = ["] [^"]* ["] // Cadena delimitada por comillas dobles
    / ['] [^']* ['] // Cadena delimitada por comillas simples

// Definición de rangos de caracteres
range 
    = "[" input_range+ "]"

// Define números
number
    = [0-9]+

// Define los rangos posibles dentro de un rango de caracteres
input_range 
    = [^[\]-] "-" [^[\]-] // Rango (e.g., a-z)
    / [^[\]]+            // Un conjunto de caracteres individuales

// Ignorar espacios y tabs
_ 
    = [ \t]*

// Manejo de saltos de línea
newline 
    = ([ \t\n\r] / coms)* // Ignora espacios y permite comentarios como líneas nuevas

// Comentarios: permite "//" para comentarios de una línea y "/* */" para bloques
coms 
    = "//" (![\n] .)* // Comentario de una línea
    / "/*" (!("*/") .)* "*/" // Comentario de bloque
