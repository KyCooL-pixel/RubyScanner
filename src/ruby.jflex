%%
// Regular expression rules
%class RubyLexer
%unicode
%public
%type Token
%debug


%eofval{
  return new Token(TokenType.EOF, "");
%eofval}

%{
  StringBuffer string = new StringBuffer();
%}


// Whitespace
LineTerminator = \r|\n|\r\n
WS = {LineTerminator} | [ \t\f]

// Identifiers
ID = [_a-zA-Z][_a-zA-Z0-9]*

// Number literals
NUMBER = 0 | [1-9]([0-9])*(.[0-9]+)?

// operator
OPERATOR = "+" | "-" | "*" | "/" | "=" | "==" | "!=" | "<" | ">" | "<=" | ">=" | "&&" | "||" | "!" | "<<" | ">>" | "&" | "|" | "^" | "~" | "+=" | "-=" | "*=" | "/=" | "%=" | "<<=" | ">>=" | "&=" | "^=" | "|=" | "&&=" | "||=" | "**" | "**=" | "%"

// ...
%state STRING


// Initial state rules
%%
<YYINITIAL> "BEGIN" { return new Token(TokenType.KEYWORD, yytext()); }
<YYINITIAL> "END" { return new Token(TokenType.KEYWORD, yytext()); }
<YYINITIAL> "alias" { return new Token(TokenType.KEYWORD, yytext()); }
<YYINITIAL> "and" { return new Token(TokenType.KEYWORD, yytext()); }
<YYINITIAL> "begin" { return new Token(TokenType.KEYWORD, yytext()); }
<YYINITIAL> "break" { return new Token(TokenType.KEYWORD, yytext()); }
<YYINITIAL> "case" { return new Token(TokenType.KEYWORD, yytext()); }
<YYINITIAL> "class" { return new Token(TokenType.KEYWORD, yytext()); }
<YYINITIAL> "def" { return new Token(TokenType.KEYWORD, yytext()); }
<YYINITIAL> "defined?" { return new Token(TokenType.KEYWORD, yytext()); }
<YYINITIAL> "do" { return new Token(TokenType.KEYWORD, yytext()); }
<YYINITIAL> "else" { return new Token(TokenType.KEYWORD, yytext()); }
<YYINITIAL> "elsif" { return new Token(TokenType.KEYWORD, yytext()); }
<YYINITIAL> "end" { return new Token(TokenType.KEYWORD, yytext()); }
<YYINITIAL> "false" { return new Token(TokenType.KEYWORD, yytext()); }
<YYINITIAL> "ensure" { return new Token(TokenType.KEYWORD, yytext()); }
<YYINITIAL> "for" { return new Token(TokenType.KEYWORD, yytext()); }
<YYINITIAL> "if" { return new Token(TokenType.KEYWORD, yytext()); }
<YYINITIAL> "in" { return new Token(TokenType.KEYWORD, yytext()); }
<YYINITIAL> "module" { return new Token(TokenType.KEYWORD, yytext()); }
<YYINITIAL> "next" { return new Token(TokenType.KEYWORD, yytext()); }
<YYINITIAL> "nil" { return new Token(TokenType.KEYWORD, yytext()); }
<YYINITIAL> "not" { return new Token(TokenType.KEYWORD, yytext()); }
<YYINITIAL> "or" { return new Token(TokenType.KEYWORD, yytext()); }
<YYINITIAL> "redo" { return new Token(TokenType.KEYWORD, yytext()); }
<YYINITIAL> "rescue" { return new Token(TokenType.KEYWORD, yytext()); }
<YYINITIAL> "retry" { return new Token(TokenType.KEYWORD, yytext()); }
<YYINITIAL> "return" { return new Token(TokenType.KEYWORD, yytext()); }
<YYINITIAL> "self" { return new Token(TokenType.KEYWORD, yytext()); }
<YYINITIAL> "super" { return new Token(TokenType.KEYWORD, yytext()); }
<YYINITIAL> "then" { return new Token(TokenType.KEYWORD, yytext()); }
<YYINITIAL> "true" { return new Token(TokenType.KEYWORD, yytext()); }
<YYINITIAL> "undef" { return new Token(TokenType.KEYWORD, yytext()); }
<YYINITIAL> "unless" { return new Token(TokenType.KEYWORD, yytext()); }
<YYINITIAL> "until" { return new Token(TokenType.KEYWORD, yytext()); }
<YYINITIAL> "when" { return new Token(TokenType.KEYWORD, yytext()); }
<YYINITIAL> "while" { return new Token(TokenType.KEYWORD, yytext()); }
<YYINITIAL> "yield" { return new Token(TokenType.KEYWORD, yytext()); }
<YYINITIAL> "_ENCODING_" { return new Token(TokenType.KEYWORD, yytext()); }
<YYINITIAL> "_LINE_" { return new Token(TokenType.KEYWORD, yytext()); }
<YYINITIAL> "_FILE_" { return new Token(TokenType.KEYWORD, yytext()); }


<YYINITIAL> {
  \"     { string.setLength(0); yybegin(STRING); } 
 {WS}    { /* Skip whitespace */ }

 {ID}    { return new Token(TokenType.IDENTIFIER, yytext()); }

 {NUMBER}  { return new Token(TokenType.NUMBER, yytext()); }

  // Handle other patterns and tokens
  // ...
 {OPERATOR}  { return new Token(TokenType.OPERATOR, yytext()); }
  // ...
}

// String state rules
<STRING> {
  \"     { yybegin(YYINITIAL);
            return new Token(TokenType.STRINGLITERAL, string.toString()); }
  [^\n\r\"\\]+  {  string.append( yytext() ); }
  \\t     { string.append('\t'); }
  \\n         { string.append('\n'); }

  \\r    { string.append('\r'); }  
  \\\"     { string.append('\"'); }
  \\      { string.append('\\'); }
}

// Other rules and actions
// ...
/* error fallback */
[^]                              { throw new Error("Illegal character <"+ yytext()+">"); }

// Additional helper methods and classes
// ...
