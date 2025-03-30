import gleeunit
import gleeunit/should
import lexer
import token

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn hello_world_test() {
  1
  |> should.equal(1)
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

pub fn scan_number_test() {
  let input = "123 12.3"
  lexer.scan(input)
  |> should.be_ok
  |> should.be_ok
  |> should.equal([
    token.Token(token.Number, "123", 0),
    token.Token(token.Number, "12.3", 0),
    token.Token(token.Eof, "", 0),
  ])
}

// Don't know how this test should behave yet.
// pub fn scan_invalid_number_test() {
//   let input = ".123 123."
//   lexer.scan(input)
//   |> should.be_ok
//   |> should.be_error
//   |> should.equal([])
// }
