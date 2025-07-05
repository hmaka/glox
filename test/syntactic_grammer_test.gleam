import gleeunit
import syntactic_grammer

// import gleeunit/should
// import lexer
// import token

pub fn main() {
  gleeunit.main()
}

pub fn binary_print_test() {
  let exp =
    syntactic_grammer.BinaryExp(syntactic_grammer.Binary(
      left: syntactic_grammer.LiteralExp(literal: syntactic_grammer.True),
      right: syntactic_grammer.LiteralExp(literal: syntactic_grammer.False),
      operator: syntactic_grammer.Equal,
    ))
  echo exp
}
