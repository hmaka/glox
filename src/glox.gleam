import error
import argv
import gleam/io
import lexer
import prompt

pub fn main() {
  let exec_result = case argv.load().arguments {
    [file] -> lexer.scan(file)
    [] -> prompt.run_prompt()
    _ -> Error(error.StringError("Usage: glox <script>"))
  }
  io.debug(exec_result)
}
