import error
import gleam/erlang
import gleam/io
import gleam/result
import lexer
import run

pub fn run_prompt() {
  io.println("running interactive shell")
  prompt_loop()
}

fn prompt_loop() -> Result(Nil, error.RunError) {
  let scan_result =
    erlang.get_line("> ")
    |> result.map_error(error.GetLineError)
    |> result.try(lexer.scan)

  case scan_result{
    Ok(Ok(tokens)) -> run.run(tokens)
    Ok(Error(lex_errors)) -> {
          io.print("There was a syntax error in your code")
          io.debug(lex_errors)
      prompt_loop() 
    }
    Error(e) -> Error(e)
  }

}
