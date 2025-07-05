import error
import gleam/io
import gleam/result
import input
import lexer
import run

pub fn run_prompt() {
  io.println("running interactive shell")
  prompt_loop()
}

fn prompt_loop() -> Result(Nil, error.RunError) {
  let scan_result =
    input.input("> ")
    |> result.map_error(error.EmptyErr)
    |> result.try(lexer.scan)

  case scan_result {
    Ok(Ok(tokens)) -> run.run(tokens)
    Ok(Error(lex_errors)) -> {
      io.print("There was a syntax error in your code")
      echo lex_errors
      prompt_loop()
    }
    Error(e) -> Error(e)
  }
}
