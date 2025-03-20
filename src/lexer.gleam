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

pub fn scan(raw_text: String) -> Result(List(token.Token), error.RunError) {
  let scan_state = ScanState(current: 0, line: 0, scan_error_list: [])
  tokenizer(string.to_graphemes(raw_text), [], scan_state)
}

fn comment(
  graphemes: List(String),
  tokens: List(token.Token),
  scan_state: ScanState,
) -> Result(List(token.Token), error.RunError) {
  case graphemes {
    [] -> tokenizer(graphemes, tokens, scan_state)
    ["\n", ..rest] ->
      tokenizer(
        rest,
        tokens,
        ScanState(..scan_state, line: scan_state.line + 1),
      )
    [_, ..rest] -> comment(rest, tokens, ScanState(..scan_state, current: scan_state.current + 1))
  }
}

fn tokenizer(
  graphemes: List(String),
  tokens: List(token.Token),
  scan_state: ScanState,
) -> Result(List(token.Token), error.RunError) {
  let _ = case graphemes {
    [] ->
      Ok(list.reverse([token.Token(token.Eof, "", scan_state.line), ..tokens]))
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
        [token.Token(token.RightParen, "(", scan_state.line), ..tokens],
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
    [u, ..rest] -> {
      let err = LexicalError(scan_state.current, u)
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

  Ok([])
}
