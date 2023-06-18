%%
// Regular expression rules
%class RubyLexer
%unicode
%public
// returns token
%type Token
%eofval{
  return new Token(TokenType.EOF, "");
%eofval}
%{
  // to store the string literal
  StringBuffer string = new StringBuffer();
%}
// Whitespace
LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WS = {LineTerminator} | [ \t\f]+

// Identifiers
ID = [_a-zA-Z][_a-zA-Z0-9]*

// Number literals
NUMBER = 0 | [1-9]([0-9])*(.[0-9]+)?

// operator
OPERATOR = "." |"+" | "-" | "*" | "/" | "=" | "==" | "!=" | "<" | ">" | "<=" | ">=" | "&&" | "||" | "!" | "<<" | ">>" | "&" | "|" | "^" | "~" | "+=" | "-=" | "*=" | "/=" | "%=" | "<<=" | ">>=" | "&=" | "^=" | "|=" | "&&=" | "||=" | "**" | "**=" | "%"| "?"
GLOBAL = "$" 

// comments single line
COMMENT = "#" {InputCharacter}* {LineTerminator}?

%state STRING

// Initial state rules
%%
// keywords
<YYINITIAL>{ 
 "BEGIN" |
 "END" |
 "alias" |
 "and" |
 "begin" |
 "break" |
 "case" |
 "class" |
 "def" |
 "defined?" |
 "do" |
 "else" |
 "elsif" |
 "end" |
 "ensure" |
 "for" |
 "if" |
 "in" |
 "module" |
 "next" |
 "not" |
 "or" |
 "redo" |
 "rescue" |
 "retry" |
 "return" |
 "super" |
 "then" |
 "undef" |
 "unless" |
 "until" |
 "when" |
 "while" |
 "yield"  { return new Token(TokenType.KEYWORD, yytext()); }
 }

// types
<YYINITIAL>{ 
  "_ENCODING_" |
  "_LINE_" |
  "_FILE_" |
  "true" |
  "nil" |
  "self" |
  "false" { return new Token(TokenType.TYPE, yytext()); }
}


<YYINITIAL> {
  // String literal starts
  \"          { string.setLength(0); yybegin(STRING); } 
 {GLOBAL}     { return new Token(TokenType.GLOBAL, yytext());}
  // whitespace
 {WS}         { /* Skip whitespace */ }
  // Identifiers
 {ID}         { return new Token(TokenType.IDENTIFIER, yytext()); }
  // Number literals
 {NUMBER}     { return new Token(TokenType.NUMBER, yytext()); }
  // Operators
 {OPERATOR}   { return new Token(TokenType.OPERATOR, yytext()); }
  // Comment
 {COMMENT}    {/* ignore comments*/}
  // Delimiters
 "("          { return new Token(TokenType.LEFT_PAREN); }
 ")"          { return new Token(TokenType.RIGHT_PAREN); }
  "{"         { return new Token(TokenType.LEFT_BRACE); }
  "}"         { return new Token(TokenType.RIGHT_BRACE); }
  "["         { return new Token(TokenType.LEFT_BRACKET); }
  "]"         { return new Token(TokenType.RIGHT_BRACKET); }
  ","         { return new Token(TokenType.COMMA); }
  ";"         { return new Token(TokenType.SEMICOLON); }
}
// String state rules
<STRING> {
  // String literal ends
  \"            { yybegin(YYINITIAL);return new Token(TokenType.STRINGLITERAL, string.toString()); }
  // String content
  [^\n\r\"\\]+  {  string.append( yytext() ); }
  \\t           { string.append('\t'); }
  \\n           { string.append('\n'); }

  \\r           { string.append('\r'); }  
  \\\"          { string.append('\"'); }
  \\            { string.append('\\'); }
}
// Other rules and actions
// ...
/* error fallback */
[^]    { throw new Error("Illegal character <"+ yytext()+">"); }

// Additional helper methods and classes

// ...
