import gleam/io
import token
import error


pub fn scan_file(file: String) -> Result(Nil,error.RunError){
  io.println(file)
  Ok(Nil)
}

pub fn scan(_raw_text: String) -> Result(List(token.Token), error.RunError) {
  let token = token.Token(token.Equal,"=",0)
  Ok([token])
}
