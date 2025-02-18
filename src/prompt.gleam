import lexer
import error
import gleam/erlang
import gleam/io
import gleam/result
import run

pub fn run_prompt() {
  io.println("running interactive shell")
  prompt_loop()
}

fn prompt_loop() -> Result(Nil, error.RunError) {
  let run_result = erlang.get_line("> ")
  |> result.map_error(error.GetLineError)
  |> result.try(lexer.scan)
  |> result.try(run.run)

  case run_result{
    Ok(_) -> prompt_loop()
    e -> e
  }

}
