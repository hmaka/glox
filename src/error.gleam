import gleam/erlang

pub type RunError {
  EmptyErr(Nil)
  GetLineError(erlang.GetLineError)
  StringError(String)
}
