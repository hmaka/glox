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
