import error
import gleam/io

pub fn scan(file: String) -> Result(Nil,error.RunError) {
  io.println(file)
  Ok(Nil)
}
