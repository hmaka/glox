import lexer
import prompt
import gleam/io
import argv

pub fn main() {
  case argv.load().arguments{
    [file] -> lexer.scan(file)
    [] -> prompt.run_prompt()  
    _ -> io.println_error("Usage: glox <script>")
  }
}



