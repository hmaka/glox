
pub type Token{
  Token(token_type: TokenType, lexeme:String, line:Int)
}

pub type TokenType {
  // Single-character tokens.
  LeftParen
  RightParen
  LeftBrace
  RightBrace

  Comma
  Dot
  Minus
  Plus
  SemiColon
  Slash
  Star

  // One or two character tokens.
  Bang
  BangEqual
  Equal
  EqualEqual
  Greater
  GreaterEqual
  Less
  LessEqual

  // Literals.
  Identifier
  String
  Number

  // Keywords.
  And
  Class
  Else
  FALSE
  Fun
  For
  If
  Nil
  Or

  Print
  Return
  Super
  This
  TRUE
  Var
  While

  Eof
}
