pub type Operation {
  Equal
  NotEqual
  Less
  LessOrEqual
  Greater
  GreaterOrEqual
  Add
  Subtract
  Multiply
  Divide
}

pub fn to_string(operation: Operation) -> String {
  case operation {
    Equal -> "=="
    NotEqual -> "!="
    Less -> "<"
    LessOrEqual -> "<="
    Greater -> ">"
    GreaterOrEqual -> ">="
    Add -> "+"
    Subtract -> "-"
    Multiply -> "*"
    Divide -> "/"
  }
}
