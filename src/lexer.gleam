import error
import gleam/io
import gleam/list
import gleam/string
import token

pub type LexicalError {
  LexicalError(line: Int, message: String)
}

pub type ScanState {
  ScanState(current: Int, line: Int, scan_error_list: List(LexicalError))
}

pub fn scan_file(file: String) -> Result(Nil, error.RunError) {
  io.println(file)
  Ok(Nil)
}

pub fn scan(
  raw_text: String,
) -> Result(Result(List(token.Token), List(LexicalError)), error.RunError) {
  let scan_state = ScanState(current: 0, line: 0, scan_error_list: [])
  tokenizer(string.to_graphemes(raw_text), [], scan_state)
}

fn comment(
  graphemes: List(String),
  tokens: List(token.Token),
  scan_state: ScanState,
) -> Result(Result(List(token.Token), List(LexicalError)), error.RunError) {
  case graphemes {
    [] -> tokenizer(graphemes, tokens, scan_state)
    ["\n", ..rest] ->
      tokenizer(
        rest,
        tokens,
        ScanState(..scan_state, line: scan_state.line + 1),
      )
    [_, ..rest] ->
      comment(
        rest,
        tokens,
        ScanState(..scan_state, current: scan_state.current + 1),
      )
  }
}

fn string(
  graphemes: List(String),
  tokens: List(token.Token),
  scan_state: ScanState,
  str: String,
) -> Result(Result(List(token.Token), List(LexicalError)), error.RunError) {
  case graphemes {
    [] ->
      tokenizer(
        graphemes,
        tokens,
        ScanState(
          ..scan_state,
          scan_error_list: [
            LexicalError(scan_state.line, "unclosed string"),
            ..scan_state.scan_error_list
          ],
        ),
      )
    ["\"", ..rest] ->
      tokenizer(
        rest,
        [token.Token(token.String, str, scan_state.line), ..tokens],
        scan_state,
      )
    ["\n", ..rest] ->
      string(
        rest,
        tokens,
        ScanState(..scan_state, line: scan_state.line + 1),
        str,
      )
    [x, ..rest] -> string(rest, tokens, scan_state, string.append(str, x))
  }
}

fn number(
  graphemes: List(String),
  tokens: List(token.Token),
  scan_state: ScanState,
  dots: Int,
  str: String,
) -> Result(Result(List(token.Token), List(LexicalError)), error.RunError) {
  case graphemes {
    [] ->
      tokenizer(
        graphemes,
        [token.Token(token.Number, str, scan_state.line), ..tokens],
        scan_state,
      )
    ["\n", ..rest] ->
      number(
        rest,
        tokens,
        ScanState(..scan_state, line: scan_state.line + 1),
        dots,
        str,
      )
    ["0", ..rest] -> number(rest, tokens, scan_state, dots, string.append(str, "0"))
    ["1", ..rest] -> number(rest, tokens, scan_state, dots, string.append(str, "1"))
    ["2", ..rest] -> number(rest, tokens, scan_state, dots, string.append(str, "2"))
    ["3", ..rest] -> number(rest, tokens, scan_state, dots, string.append(str, "3"))
    ["4", ..rest] -> number(rest, tokens, scan_state, dots, string.append(str, "4"))
    ["5", ..rest] -> number(rest, tokens, scan_state, dots, string.append(str, "5"))
    ["6", ..rest] -> number(rest, tokens, scan_state, dots, string.append(str, "6"))
    ["7", ..rest] -> number(rest, tokens, scan_state, dots, string.append(str, "7"))
    ["8", ..rest] -> number(rest, tokens, scan_state, dots, string.append(str, "8"))
    ["9", ..rest] -> number(rest, tokens, scan_state, dots, string.append(str, "9"))
    
  }
}

fn tokenizer(
  graphemes: List(String),
  tokens: List(token.Token),
  scan_state: ScanState,
) -> Result(Result(List(token.Token), List(LexicalError)), error.RunError) {
  case graphemes {
    [] ->
      Ok(
        Ok(
          list.reverse([token.Token(token.Eof, "", scan_state.line), ..tokens]),
        ),
      )

    ["!", "=", ..rest] ->
      tokenizer(
        rest,
        [token.Token(token.BangEqual, "!=", scan_state.line), ..tokens],
        ScanState(..scan_state, current: scan_state.current + 2),
      )
    ["=", "=", ..rest] ->
      tokenizer(
        rest,
        [token.Token(token.EqualEqual, "==", scan_state.line), ..tokens],
        ScanState(..scan_state, current: scan_state.current + 2),
      )
    [">", "=", ..rest] ->
      tokenizer(
        rest,
        [token.Token(token.GreaterEqual, ">=", scan_state.line), ..tokens],
        ScanState(..scan_state, current: scan_state.current + 2),
      )
    ["<", "=", ..rest] ->
      tokenizer(
        rest,
        [token.Token(token.LessEqual, "<=", scan_state.line), ..tokens],
        ScanState(..scan_state, current: scan_state.current + 2),
      )
    ["/", "/", ..rest] ->
      comment(
        rest,
        tokens,
        ScanState(..scan_state, current: scan_state.current + 1),
      )
    ["\"", ..rest] -> string(rest, tokens, scan_state, "")
    ["!", ..rest] ->
      tokenizer(
        rest,
        [token.Token(token.Bang, "!", scan_state.line), ..tokens],
        ScanState(..scan_state, current: scan_state.current + 1),
      )
    ["=", ..rest] ->
      tokenizer(
        rest,
        [token.Token(token.Equal, "=", scan_state.line), ..tokens],
        ScanState(..scan_state, current: scan_state.current + 1),
      )
    [">", ..rest] ->
      tokenizer(
        rest,
        [token.Token(token.Greater, ">", scan_state.line), ..tokens],
        ScanState(..scan_state, current: scan_state.current + 1),
      )
    ["<", ..rest] ->
      tokenizer(
        rest,
        [token.Token(token.Less, "<", scan_state.line), ..tokens],
        ScanState(..scan_state, current: scan_state.current + 1),
      )
    ["(", ..rest] ->
      tokenizer(
        rest,
        [token.Token(token.LeftParen, "(", scan_state.line), ..tokens],
        ScanState(..scan_state, current: scan_state.current + 1),
      )
    [")", ..rest] ->
      tokenizer(
        rest,
        [token.Token(token.RightParen, ")", scan_state.line), ..tokens],
        ScanState(..scan_state, current: scan_state.current + 1),
      )
    ["[", ..rest] ->
      tokenizer(
        rest,
        [token.Token(token.LeftBrace, "[", scan_state.line), ..tokens],
        ScanState(..scan_state, current: scan_state.current + 1),
      )
    ["]", ..rest] ->
      tokenizer(
        rest,
        [token.Token(token.RightBrace, "]", scan_state.line), ..tokens],
        ScanState(..scan_state, current: scan_state.current + 1),
      )
    [",", ..rest] ->
      tokenizer(
        rest,
        [token.Token(token.Comma, ",", scan_state.line), ..tokens],
        ScanState(..scan_state, current: scan_state.current + 1),
      )
    [".", ..rest] ->
      tokenizer(
        rest,
        [token.Token(token.Dot, ".", scan_state.line), ..tokens],
        ScanState(..scan_state, current: scan_state.current + 1),
      )
    ["-", ..rest] ->
      tokenizer(
        rest,
        [token.Token(token.Minus, "-", scan_state.line), ..tokens],
        ScanState(..scan_state, current: scan_state.current + 1),
      )
    ["+", ..rest] ->
      tokenizer(
        rest,
        [token.Token(token.Plus, "+", scan_state.line), ..tokens],
        ScanState(..scan_state, current: scan_state.current + 1),
      )
    [";", ..rest] ->
      tokenizer(
        rest,
        [token.Token(token.SemiColon, ";", scan_state.line), ..tokens],
        ScanState(..scan_state, current: scan_state.current + 1),
      )
    ["/", ..rest] ->
      tokenizer(
        rest,
        [token.Token(token.Slash, "/", scan_state.line), ..tokens],
        ScanState(..scan_state, current: scan_state.current + 1),
      )
    ["*", ..rest] ->
      tokenizer(
        rest,
        [token.Token(token.Star, "*", scan_state.line), ..tokens],
        ScanState(..scan_state, current: scan_state.current + 1),
      )
    ["\n", ..rest] ->
      tokenizer(
        rest,
        tokens,
        ScanState(..scan_state, line: scan_state.line + 1),
      )
    ["\r", ..rest] | ["\t", ..rest] | [" ", ..rest] ->
      tokenizer(
        rest,
        tokens,
        ScanState(..scan_state, current: scan_state.current + 1),
      )
    ["0", ..]
    | ["1", ..]
    | ["2", ..]
    | ["3", ..]
    | ["4", ..]
    | ["5", ..]
    | ["6", ..]
    | ["7", ..]
    | ["8", ..]
    | ["9", ..] -> {
      number(graphemes, tokens, scan_state,0,"")
    }
    [u, ..rest] -> {
      let err =
        LexicalError(
          scan_state.current,
          string.append("unkown token encountered:", u),
        )
      tokenizer(
        rest,
        tokens,
        ScanState(
          ..scan_state,
          scan_error_list: [err, ..scan_state.scan_error_list],
        ),
      )
    }
  }
}
