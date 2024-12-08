start
  // Regla inicial: reconoce una serie de declaraciones separadas por espacios en blanco.

  = _ declarations:Declaration* _ { return JSON.stringify(declarations, null, 2); };

Declaration
  // Regla para declarar un identificador asignado a un valor.

  = identifier:Identifier _ "=" _ value:Value _ { 
      return { type: "Declaration", name: identifier, value: value }; 
    }

  // Alternativa: una declaración donde el identificador hace referencia a otro identificador.

  / identifier:Identifier _ "=" _ reference:Identifier _ {
      return { type: "Declaration", name: identifier, reference: reference };
    };

Value
  // Regla que define los valores que puede tomar una declaración.
  // Puede ser una cadena literal.

  = '"' text:LiteralContent '"' { return text; }
  / "'" text:LiteralContent "'" { return text; }

  // Puede ser un conjunto de caracteres.
  / set:CharacterSet { return set; }

  // Puede ser una secuencia repetida.
  / repeated:RepeatedSequence { return repeated; }

  // Puede ser una expresión más compleja.
  / expr:Expression { return expr; };

RepeatedSequence

  // Secuencia repetida definida por un literal seguido de "*".
  = text:Literal _ "*" { 
      return { type: "RepeatedSequence", value: text }; 
    }
  
  // Alternativa: solo un literal sin repetición explícita.
  / text:Literal { 
      return { type: "RepeatedSequence", value: text }; 
    };

Literal

  // Reconoce cadenas literales encerradas en comillas dobles.
  = '"' text:[a-zA-Z0-9]+ '"' { return text.join(""); }

  // Alternativa: cadenas literales encerradas en comillas simples.
  / "'" text:[a-zA-Z0-9]+ "'" { return text.join(""); };

CharacterSet

  // Reconoce un conjunto de caracteres definido entre corchetes.
  = "[" content:(Range / Character+)+ "]" { 
      return { type: "CharacterSet", values: content.flat() }; 
    };

Range

  // Reconoce un rango de caracteres, como "a-z".
  = start:Character "-" end:Character { 
      if (start.charCodeAt(0) > end.charCodeAt(0)) {
        throw new Error("Rango Invalido"); // Verifica que el rango sea válido.
      }
      const values = [];
      for (let i = start.charCodeAt(0); i <= end.charCodeAt(0); i++) {
        values.push(String.fromCharCode(i)); // Genera todos los caracteres dentro del rango.
      }
      return values;
    };

Character

  // Reconoce un solo carácter alfanumérico.
  = [a-zA-Z0-9] { return text(); };

Expression

  // Reconoce una expresión entre paréntesis y la evalúa como "additive".
  = "(" _ expr:additive _ ")" { return expr; }

  // Alternativa: evalúa un valor entre paréntesis.
  / "(" _ expr:Value _ ")" { return expr; }

  // Alternativa: directamente una expresión "additive".
  / additive;

additive

  // Reconoce una operación de suma con dos términos.
  = left:multiplicative _ "+" _ right:additive { return left + right; }

  // Alternativa: una expresión multiplicativa.
  / multiplicative;

multiplicative

  // Reconoce una operación de multiplicación con dos términos.
  = left:primary _ "*" _ right:multiplicative { return left * right; }

  // Alternativa: un término primario.
  / primary;

primary

  // Reconoce un número entero.
  = integer

  // Alternativa: una expresión additive entre paréntesis.
  / "(" _ expr:additive _ ")" { return expr; };

integer

  // Reconoce un número entero formado por dígitos.
  = [0-9]+ { return parseInt(text(), 10); };

Identifier

  // Reconoce un identificador formado por letras y números, insensible a mayúsculas/minúsculas.
  = [a-zA-Z][a-zA-Z0-9]* { return text().toLowerCase(); };

LiteralContent

  // Reconoce el contenido literal dentro de comillas, excluyendo las comillas mismas.
  = [^"']+;

_ 
  // Reconoce espacios en blanco y comentarios, que se ignoran.
  = ([ \t\n\r] / Comments)*;

Comments

  // Reconoce comentarios de una línea (que comienzan con "//").
  = "//" (![\n] .)* 
  
  // Alternativa: comentarios multilínea (entre "/*" y "*/").
  / "/*" (!"*/" .)* "*/";
