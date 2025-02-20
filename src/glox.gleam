import argv
import error
import gleam/io
import lexer
import prompt

pub fn main() {
  let exec_result = case argv.load().arguments {
    [file] -> lexer.scan_file(file)
    [] -> prompt.run_prompt()
    _ -> Error(error.StringError("Usage: glox <script>"))
  }
  io.debug(exec_result)
}
