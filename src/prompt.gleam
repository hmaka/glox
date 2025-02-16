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
  use line: String <- result.try(
    erlang.get_line(">") |> result.map_error(error.GetLineError),
  )
  use _ <- result.try(
    run.run(line)
    |> result.map_error(error.EmptyError),
  )
  prompt_loop()
}
