import gleam/result
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
  let input = "!="
  let res = lexer.scan(input)

  res |> should.be_ok
  let res = result.unwrap(res, [])
  res
  |> should.equal([
    token.Token(token.BangEqual, "!=", 0),
    token.Token(token.Eof, "", 0),
  ])
}
