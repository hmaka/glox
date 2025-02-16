import gleam/erlang

pub type RunError {
  EmptyError(Nil)
  GetLineError(erlang.GetLineError)
  StringError(String)
}
