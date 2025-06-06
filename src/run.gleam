import error
import gleam/io
import token

pub fn run(tokens: List(token.Token)) -> Result(Nil, error.RunError) {
  case tokens {
    [] -> Ok(Nil)
    [t, ..rest] -> {
      io.debug(t)
      run(rest)
    }
  }
}
