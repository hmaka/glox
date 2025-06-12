import error
import gleam/float
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
    ["\n", ..rest] ->
      number(
        rest,
        tokens,
        ScanState(..scan_state, line: scan_state.line + 1),
        dots,
        str,
      )
    [".", "0", ..]
      | [".", "1", ..]
      | [".", "2", ..]
      | [".", "3", ..]
      | [".", "4", ..]
      | [".", "5", ..]
      | [".", "6", ..]
      | [".", "7", ..]
      | [".", "8", ..]
      | [".", "9", ..]
      if dots == 0
    ->
      number(
        list.drop(graphemes, 1),
        tokens,
        scan_state,
        dots + 1,
        string.append(str, "."),
      )
    ["0", ..rest] ->
      number(rest, tokens, scan_state, dots, string.append(str, "0"))
    ["1", ..rest] ->
      number(rest, tokens, scan_state, dots, string.append(str, "1"))
    ["2", ..rest] ->
      number(rest, tokens, scan_state, dots, string.append(str, "2"))
    ["3", ..rest] ->
      number(rest, tokens, scan_state, dots, string.append(str, "3"))
    ["4", ..rest] ->
      number(rest, tokens, scan_state, dots, string.append(str, "4"))
    ["5", ..rest] ->
      number(rest, tokens, scan_state, dots, string.append(str, "5"))
    ["6", ..rest] ->
      number(rest, tokens, scan_state, dots, string.append(str, "6"))
    ["7", ..rest] ->
      number(rest, tokens, scan_state, dots, string.append(str, "7"))
    ["8", ..rest] ->
      number(rest, tokens, scan_state, dots, string.append(str, "8"))
    ["9", ..rest] ->
      number(rest, tokens, scan_state, dots, string.append(str, "9"))
    _ -> {
      let str = case string.contains(str, ".") {
        True -> str
        False -> string.append(str, ".0")
      }
      let num = float.parse(str)

      case num {
        Ok(n) ->
          tokenizer(
            graphemes,
            [token.NumberToken(token.Number, n, scan_state.line), ..tokens],
            scan_state,
          )
        Error(Nil) ->
          tokenizer(
            graphemes,
            tokens,
            ScanState(
              ..scan_state,
              scan_error_list: [
                LexicalError(
                  scan_state.line,
                  string.append("Could not parse number: ", str),
                ),
                ..scan_state.scan_error_list
              ],
            ),
          )
      }
    }
  }
}

pub fn identifier_or_reserved_word(
  graphemes: List(String),
  tokens: List(token.Token),
  scan_state: ScanState,
  word: String,
) -> Result(Result(List(token.Token), List(LexicalError)), error.RunError) {
  case graphemes {
    ["a", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "a"),
      )
    ["b", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "b"),
      )
    ["c", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "c"),
      )
    ["d", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "d"),
      )
    ["e", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "e"),
      )
    ["f", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "f"),
      )
    ["g", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "g"),
      )
    ["h", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "h"),
      )
    ["i", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "i"),
      )
    ["j", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "j"),
      )
    ["k", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "k"),
      )
    ["l", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "l"),
      )
    ["m", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "m"),
      )
    ["n", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "n"),
      )
    ["o", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "o"),
      )
    ["p", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "p"),
      )
    ["q", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "q"),
      )
    ["r", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "r"),
      )
    ["s", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "s"),
      )
    ["t", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "t"),
      )
    ["u", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "u"),
      )
    ["v", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "v"),
      )
    ["w", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "w"),
      )
    ["x", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "x"),
      )
    ["y", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "y"),
      )
    ["z", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "z"),
      )
    ["A", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "A"),
      )
    ["B", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "B"),
      )
    ["C", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "C"),
      )
    ["D", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "D"),
      )
    ["E", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "E"),
      )
    ["F", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "F"),
      )
    ["G", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "G"),
      )
    ["H", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "H"),
      )
    ["I", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "I"),
      )
    ["J", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "J"),
      )
    ["K", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "K"),
      )
    ["L", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "L"),
      )
    ["M", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "M"),
      )
    ["N", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "N"),
      )
    ["O", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "O"),
      )
    ["P", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "P"),
      )
    ["Q", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "Q"),
      )
    ["R", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "R"),
      )
    ["S", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "S"),
      )
    ["T", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "T"),
      )
    ["U", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "U"),
      )
    ["V", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "V"),
      )
    ["W", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "W"),
      )
    ["X", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "X"),
      )
    ["Y", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "Y"),
      )
    ["Z", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "Z"),
      )
    ["_", ..rest] ->
      identifier_or_reserved_word(
        rest,
        tokens,
        scan_state,
        string.append(word, "_"),
      )
    _ -> {
      case word {
        "and" ->
          tokenizer(
            graphemes,
            [token.Token(token.And, "and", scan_state.line), ..tokens],
            scan_state,
          )
        "class" ->
          tokenizer(
            graphemes,
            [token.Token(token.Class, "class", scan_state.line), ..tokens],
            scan_state,
          )
        "else" ->
          tokenizer(
            graphemes,
            [token.Token(token.Else, "else", scan_state.line), ..tokens],
            scan_state,
          )
        "false" ->
          tokenizer(
            graphemes,
            [token.Token(token.FALSE, "false", scan_state.line), ..tokens],
            scan_state,
          )
        "for" ->
          tokenizer(
            graphemes,
            [token.Token(token.For, "for", scan_state.line), ..tokens],
            scan_state,
          )
        "fun" ->
          tokenizer(
            graphemes,
            [token.Token(token.Fun, "fun", scan_state.line), ..tokens],
            scan_state,
          )
        "if" ->
          tokenizer(
            graphemes,
            [token.Token(token.If, "if", scan_state.line), ..tokens],
            scan_state,
          )
        "nil" ->
          tokenizer(
            graphemes,
            [token.Token(token.Nil, "nil", scan_state.line), ..tokens],
            scan_state,
          )
        "or" ->
          tokenizer(
            graphemes,
            [token.Token(token.Or, "or", scan_state.line), ..tokens],
            scan_state,
          )
        "print" ->
          tokenizer(
            graphemes,
            [token.Token(token.Print, "print", scan_state.line), ..tokens],
            scan_state,
          )
        "return" ->
          tokenizer(
            graphemes,
            [token.Token(token.Return, "return", scan_state.line), ..tokens],
            scan_state,
          )
        "super" ->
          tokenizer(
            graphemes,
            [token.Token(token.Super, "super", scan_state.line), ..tokens],
            scan_state,
          )
        "this" ->
          tokenizer(
            graphemes,
            [token.Token(token.This, "this", scan_state.line), ..tokens],
            scan_state,
          )
        "true" ->
          tokenizer(
            graphemes,
            [token.Token(token.TRUE, "true", scan_state.line), ..tokens],
            scan_state,
          )
        "var" ->
          tokenizer(
            graphemes,
            [token.Token(token.Var, "var", scan_state.line), ..tokens],
            scan_state,
          )
        "while" ->
          tokenizer(
            graphemes,
            [token.Token(token.While, "while", scan_state.line), ..tokens],
            scan_state,
          )
        _ ->
          tokenizer(
            graphemes,
            [token.Token(token.Identifier, word, scan_state.line), ..tokens],
            scan_state,
          )
      }
    }
  }
}

fn tokenizer(
  graphemes: List(String),
  tokens: List(token.Token),
  scan_state: ScanState,
) -> Result(Result(List(token.Token), List(LexicalError)), error.RunError) {
  case graphemes {
    [] ->
      case scan_state.scan_error_list {
        [] ->
          Ok(
            Ok(
              list.reverse([
                token.Token(token.Eof, "", scan_state.line),
                ..tokens
              ]),
            ),
          )
        _ -> Ok(Error(scan_state.scan_error_list))
      }

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
      number(graphemes, tokens, scan_state, 0, "")
    }
    ["a", ..]
    | ["a", ..]
    | ["b", ..]
    | ["c", ..]
    | ["d", ..]
    | ["e", ..]
    | ["f", ..]
    | ["g", ..]
    | ["h", ..]
    | ["i", ..]
    | ["j", ..]
    | ["k", ..]
    | ["l", ..]
    | ["m", ..]
    | ["n", ..]
    | ["o", ..]
    | ["p", ..]
    | ["q", ..]
    | ["r", ..]
    | ["s", ..]
    | ["t", ..]
    | ["u", ..]
    | ["v", ..]
    | ["w", ..]
    | ["x", ..]
    | ["y", ..]
    | ["z", ..]
    | ["A", ..]
    | ["B", ..]
    | ["C", ..]
    | ["D", ..]
    | ["E", ..]
    | ["F", ..]
    | ["G", ..]
    | ["H", ..]
    | ["I", ..]
    | ["J", ..]
    | ["K", ..]
    | ["L", ..]
    | ["M", ..]
    | ["N", ..]
    | ["O", ..]
    | ["P", ..]
    | ["Q", ..]
    | ["R", ..]
    | ["S", ..]
    | ["T", ..]
    | ["U", ..]
    | ["V", ..]
    | ["W", ..]
    | ["X", ..]
    | ["Y", ..]
    | ["Z", ..]
    | ["_", ..] -> {
      identifier_or_reserved_word(graphemes, tokens, scan_state, "")
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
