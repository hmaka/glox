pub type Literal {
  Number
  String
  True
  False
  Nil
}

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

pub type Expression {
  Literal
  Binary
}

pub type Binary {
  Left(Expression)
  Right(Expression)
  Operator(Operation)
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
