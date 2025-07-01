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
  LiteralExp(literal: Literal)
  BinaryExp(binary: Binary)
}

pub type Binary {
  Binary(left: Expression, right: Expression, operator: Operation)
}

pub type Grouping {
  Expression(expression: Expression)
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
