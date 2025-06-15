import gleeunit
import gleeunit/should
import lexer
import token

pub fn main() {
  gleeunit.main()
}

pub fn scan_basic_test() {
  let input = "!= == >= <= ! = > < ( ) [ ] , . - + ; / *"
  lexer.scan(input)
  |> should.be_ok
  |> should.be_ok
  |> should.equal([
    token.Token(token.BangEqual, "!=", 0),
    token.Token(token.EqualEqual, "==", 0),
    token.Token(token.GreaterEqual, ">=", 0),
    token.Token(token.LessEqual, "<=", 0),
    token.Token(token.Bang, "!", 0),
    token.Token(token.Equal, "=", 0),
    token.Token(token.Greater, ">", 0),
    token.Token(token.Less, "<", 0),
    token.Token(token.LeftParen, "(", 0),
    token.Token(token.RightParen, ")", 0),
    token.Token(token.LeftBrace, "[", 0),
    token.Token(token.RightBrace, "]", 0),
    token.Token(token.Comma, ",", 0),
    token.Token(token.Dot, ".", 0),
    token.Token(token.Minus, "-", 0),
    token.Token(token.Plus, "+", 0),
    token.Token(token.SemiColon, ";", 0),
    token.Token(token.Slash, "/", 0),
    token.Token(token.Star, "*", 0),
    token.Token(token.Eof, "", 0),
  ])
}

pub fn scan_line_test() {
  let input = "! . \n ."
  lexer.scan(input)
  |> should.be_ok
  |> should.be_ok
  |> should.equal([
    token.Token(token.Bang, "!", 0),
    token.Token(token.Dot, ".", 0),
    token.Token(token.Dot, ".", 1),
    token.Token(token.Eof, "", 1),
  ])
}

pub fn scan_string_test() {
  let input = "! \"hi!\""
  lexer.scan(input)
  |> should.be_ok
  |> should.be_ok
  |> should.equal([
    token.Token(token.Bang, "!", 0),
    token.Token(token.String, "hi!", 0),
    token.Token(token.Eof, "", 0),
  ])
}

pub fn scan_unclosed_string_test() {
  let input = "! \"hi!"
  lexer.scan(input)
  |> should.be_ok
  |> should.be_error
  |> should.equal([lexer.LexicalError(0, "unclosed string")])
}

pub fn scan_number_test() {
  let input = "123 12.3"
  lexer.scan(input)
  |> should.be_ok
  |> should.be_ok
  |> should.equal([
    token.NumberToken(token.Number, 123.0, 0),
    token.NumberToken(token.Number, 12.3, 0),
    token.Token(token.Eof, "", 0),
  ])
}

// This is not a valid number but shouldn't error here. 
// It should error at the next stage when we try to "method call" 
// on this on a number Token.
pub fn scan_invalid_number_test() {
  let input = "123."
  lexer.scan(input)
  |> should.be_ok
  |> should.be_ok
  |> should.equal([
    token.NumberToken(token.Number, 123.0, 0),
    token.Token(token.Dot, ".", 0),
    token.Token(token.Eof, "", 0),
  ])
}

// This is not a valid number but shouldn't error here. 
// It should error at the next stage when we try to "method call" 
// on this on a nonexistent Token.
pub fn scan_invalid_number_2_test() {
  let input = ".123"
  lexer.scan(input)
  |> should.be_ok
  |> should.be_ok
  |> should.equal([
    token.Token(token.Dot, ".", 0),
    token.NumberToken(token.Number, 123.0, 0),
    token.Token(token.Eof, "", 0),
  ])
}

pub fn scan_reserved_words_test() {
  let input =
    "and
    class
    else 
    false 
    for 
    fun 
    if 
    nil 
    or 
    print 
    return 
    super 
    this 
    true 
    var 
    while
    "
  lexer.scan(input)
  |> should.be_ok
  |> should.be_ok
  |> should.equal([
    token.Token(token.And, "and", 0),
    token.Token(token.Class, "class", 1),
    token.Token(token.Else, "else", 2),
    token.Token(token.FALSE, "false", 3),
    token.Token(token.For, "for", 4),
    token.Token(token.Fun, "fun", 5),
    token.Token(token.If, "if", 6),
    token.Token(token.Nil, "nil", 7),
    token.Token(token.Or, "or", 8),
    token.Token(token.Print, "print", 9),
    token.Token(token.Return, "return", 10),
    token.Token(token.Super, "super", 11),
    token.Token(token.This, "this", 12),
    token.Token(token.TRUE, "true", 13),
    token.Token(token.Var, "var", 14),
    token.Token(token.While, "while", 15),
    token.Token(token.Eof, "", 16),
  ])
}

pub fn scan_identifer_test() {
  let input = "variable_name"
  lexer.scan(input)
  |> should.be_ok
  |> should.be_ok
  |> should.equal([
    token.Token(token.Identifier, "variable_name", 0),
    token.Token(token.Eof, "", 0),
  ])
}

pub fn scan_identifer_maximal_munch_test() {
  let input = "returnn"
  lexer.scan(input)
  |> should.be_ok
  |> should.be_ok
  |> should.equal([
    token.Token(token.Identifier, "returnn", 0),
    token.Token(token.Eof, "", 0),
  ])
}
