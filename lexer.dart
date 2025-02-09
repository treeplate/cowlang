import 'package:characters/characters.dart';

sealed class Token {
  final int line;
  final int column;
  final String file;

  String get position => '$file:$line:$column';

  Token(this.line, this.column, this.file);
}

class StringToken extends Token {
  final String value;

  StringToken(this.value, super.line, super.column, super.file);
  String toString() {
    return '\'$value\'';
  }
}

class IdentifierToken extends Token {
  final String value;

  IdentifierToken(this.value, super.line, super.column, super.file);

  String toString() {
    return value;
  }
}

class IntegerToken extends Token {
  final int value;

  IntegerToken(this.value, super.line, super.column, super.file);
}

enum SymbolType {
  opensquare,
  closesquare,
  openparen,
  closeparen,

  octothorpe,

  comma,

  plus,
  minus,
  star,
  slash,
  percentSign,
  and,
  verticalBar,
  caret,
  lessThan,
}

class SymbolToken extends Token {
  final SymbolType type;

  SymbolToken(this.type, super.line, super.column, super.file);
  String toString() {
    switch (type) {
      case SymbolType.opensquare:
        return '[';
      case SymbolType.closesquare:
        return ']';
      case SymbolType.openparen:
        return '(';
      case SymbolType.closeparen:
        return ')';
      case SymbolType.octothorpe:
        return '#';
      case SymbolType.comma:
        return ',';
      case SymbolType.plus:
        return '+';
      case SymbolType.minus:
        return '-';
      case SymbolType.star:
        return '*';
      case SymbolType.slash:
        return '/';
      case SymbolType.percentSign:
        return '%';
      case SymbolType.and:
        return '&';
      case SymbolType.verticalBar:
        return '|';
      case SymbolType.caret:
        return '^';
      case SymbolType.lessThan:
        return '<';
    }
  }
}

class EofToken extends Token {
  EofToken(super.line, super.column, super.file);
  String toString() => '<eof>';
}

enum _LexerState { top, string, integer, identifier }

Characters identifierEndings = "\t\r\n [](),+-*/%&|^<\x00".characters;
Iterable<Token> tokenize(String file, String filename) sync* {
  int line = 1;
  int column = 1;
  CharacterRange chars = (file + '\x00').characters.iterator..moveNext();
  _LexerState state = _LexerState.top;
  StringBuffer buffer = StringBuffer();
  void next() {
    chars.moveNext();
    if (chars.current == '\n') {
      line++;
      column = 1;
    } else {
      column++;
    }
  }

  while (chars.isNotEmpty) {
    switch (state) {
      case _LexerState.top:
        switch (chars.current) {
          case '\x00':
            yield EofToken(line, column, filename);
            next();
          case '[':
            yield SymbolToken(SymbolType.opensquare, line, column, filename);
            next();
          case ']':
            yield SymbolToken(SymbolType.closesquare, line, column, filename);
            next();
          case '(':
            yield SymbolToken(SymbolType.openparen, line, column, filename);
            next();
          case ')':
            yield SymbolToken(SymbolType.closeparen, line, column, filename);
            next();
          case '#':
            yield SymbolToken(SymbolType.octothorpe, line, column, filename);
            next();
          case ',':
            yield SymbolToken(SymbolType.comma, line, column, filename);
            next();
          case '+':
            yield SymbolToken(SymbolType.plus, line, column, filename);
            next();
          case '-':
            yield SymbolToken(SymbolType.minus, line, column, filename);
            next();
          case '*':
            yield SymbolToken(SymbolType.star, line, column, filename);
            next();
          case '/':
            yield SymbolToken(SymbolType.slash, line, column, filename);
            next();
          case '%':
            yield SymbolToken(SymbolType.percentSign, line, column, filename);
            next();
          case '&':
            yield SymbolToken(SymbolType.and, line, column, filename);
            next();
          case '|':
            yield SymbolToken(SymbolType.verticalBar, line, column, filename);
            next();
          case '^':
            yield SymbolToken(SymbolType.caret, line, column, filename);
            next();
          case '<':
            yield SymbolToken(SymbolType.lessThan, line, column, filename);
            next();
          case '\'':
            state = _LexerState.string;
            next();
          default:
            assert(!identifierEndings.contains(chars.current));
            state = _LexerState.identifier;
        }
      case _LexerState.string:
        if (chars.current == '\'') {
          yield StringToken(buffer.toString(), line, column, filename);
          buffer.clear();
          state = _LexerState.top;
        } else {
          buffer.write(chars.current);
        }
        next();
      case _LexerState.integer:
        // TODO: Handle this case.
        throw UnimplementedError();
      case _LexerState.identifier:
        if (identifierEndings.contains(chars.current)) {
          yield IdentifierToken(buffer.toString(), line, column, filename);
          buffer.clear();
          state = _LexerState.top;
        } else {
          buffer.write(chars.current);
          next();
        }
    }
  }
}
