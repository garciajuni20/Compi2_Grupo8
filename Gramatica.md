# Gramática Libre De Contexto: FortranPEG
```html
<!-- DEFINE EL INICIO DE LA GRAMÁTICA -->
<start>
    = (<rule> (<whitespace> ";" <whitespace> <rule>)* ";"? <whitespace>)* !.

<!-- PRODUCCION PARA RECONOCER IDENTIFICADORES -->
<identifier>
    = [_a-zA-Z][_a-zA-Z0-9]*

<!-- PRODUCCION QUE DEFINE LA ESTRUCTURA PARA RECONOCER CADENAS ENTRE COMILLAS DOBLES O SIMPLES -->
<text>
    = '"' [^"]* '"'
    / "'" [^']* "'"

<!-- PRODUCCION PARA RECONOCIMIENTO DE ESPACIOS EN BLANCO, SALTOS DE LÍNEA O TABULACIONES -->
<whitespace>
    = [ \t\r\n]*

<!-- PRODUCCION PARA RECONOCIMIENTO DE NÚMEROS (UNO O MÁS DÍGITOS) -->
<number>
    = [0-9]+

<!-- PRODUCCIÓN PARA RECONOCIMIENTO DE OPERADORES "*", "+" y "?". -->
<instances>
    = "*"
    / "+"
    / "?"

<!-- RECONOCE EL CARACTER "[". -->
<open_bracket>
    = "["

<!-- RECONOCE EL CARACTER "]". -->
<close_bracket>
    = "]"

<!-- PRODUCCION QUE DEFINE UNA CLASE DE CARACTERES ENTRE CORCHETES (CONJUNTOS O RANGOS PARA EXPRESIONES REGULARES) -->
<class>
    = <open_bracket> <range>+ <close_bracket>

<!-- RECONOCE UN RANGO O UN CONJUNTO DE CARACTERES PARA CONSTRUCCION DE LA ESTRUCTURA DE EXPRESIONES REGULARES -->
<range>
    = [^[\]-] "-" [^[\]-]
    / [^[\]]+

<!-- DEFINE Y RECONOCE LA ESTRUCTURA DE UNA PRODUCCIÓN O REGLA DEL LENGUAJE PEG -->
<!-- SEPARA EL NO TERMINAL QUE PRODUCE DEL RESTO DE LA PRODUCCIÓN CON UN SIGNO IGUAL ("=") -->
<rule>
    = <whitespace> <identifier> <whitespace> "=" <whitespace> <alternative> <whitespace>

<!-- DEFINE EL OPERADOR OR ("/") PARA PRODUCCIONES DISTINTAS DE UN MISMO NO TERMINAL QUE PRODUCE -->
<alternative>
    = <expression_list> (<whitespace> "/" <whitespace> <expression_list>)*

<!-- DEFINE EL OPERADOR AND PARA PRODUCCIONES CON VARIOS TERMINALES Y NO TERMINALES -->
<!-- LOS TERMINALES O NO TERMINALES PUEDEN O NO UTILIZAR LOS OPERADORES "+", "*" Ó "?" -->
<expression_list>
    = <expression> <whitespace> <instances>? (<whitespace> <expression> <whitespace> <instances>?)*

<!-- DEFINE LOS VALORES QUE TOMAN LAS EXPRESIONES DE LOS TERMINALES O NO TERMINALES DE LAS PRODUCCIONES -->
<expression>
    = <text>
    / <identifier>
    / <group>
    / <class>
    / <number>

<!-- DEFINE Y RECONOCE GRUPOS DE TERMINALES Y NO TERMINALES DENTRO SIGNOS DE AGRUPACIÓN []() -->
<!-- PERMITE EL RECONOCIMIENTO DE OPERACIONES ANIDADAS DENTRO DE LAS PRODUCCIONES -->
<group>
    = "[" <whitespace> <alternative> <whitespace> "-" <whitespace> <alternative> <whitespace> "]"
    / "[" <whitespace> <alternative> <whitespace> "]"
    / "(" <whitespace> <alternative> <whitespace> ")"
```