import error
import token

pub fn run(tokens: List(token.Token)) -> Result(Nil, error.RunError) {
  case tokens {
    [] -> Ok(Nil)
    [t, ..rest] -> {
      echo t
      run(rest)
    }
  }
}
