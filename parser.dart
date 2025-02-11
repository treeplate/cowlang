import 'ast.dart';
import 'lexer.dart';

class TokenIterator implements Iterator<Token> {
  final Iterator<Token> _base;

  TokenIterator(this._base) {
    _base.moveNext();
  }

  @override
  Token get current => _base.current;

  @override
  bool moveNext() => _base.moveNext();
  T? getT<T extends Token>() {
    if (current is T) {
      T result = current as T;
      moveNext();
      return result;
    } else {
      return null;
    }
  }

  String? getIdentifier() {
    return getT<IdentifierToken>()?.value;
  }

  String? getString() {
    return getT<StringToken>()?.value;
  }

  int? getInteger() {
    return getT<IntegerToken>()?.value;
  }

  bool getEof() {
    return getT<EofToken>() == null ? false : true;
  }

  bool getSymbol(SymbolType type) {
    if (current is SymbolToken && (current as SymbolToken).type == type) {
      moveNext();
      return true;
    } else {
      return false;
    }
  }
}

class Scope {
  final Scope? parent;
  final List<String> declarations = [];

  bool declare(String name) {
    if (declarations.contains(name)) {
      return false;
    }
    declarations.add(name);
    return true;
  }

  bool exists(String name) {
    return declarations.contains(name) ? true : parent?.exists(name) ?? false;
  }

  Scope child() => Scope(parent);

  Scope(this.parent);
}

List<Statement> parseTokens(Iterable<Token> tokens, List<String> rtl) {
  TokenIterator tokenIterator = TokenIterator(tokens.iterator);
  Scope rtlScope = Scope(null)..declarations.addAll(rtl);
  Scope rootScope = Scope(rtlScope);
  List<Statement> result = [];
  while (!tokenIterator.getEof()) {
    result.add(parseStatement(tokenIterator, rootScope));
  }
  return result;
}

Statement parseStatement(TokenIterator tokens, Scope scope) {
  Token startToken = tokens.current;
  String? identifier = tokens.getIdentifier();
  switch (identifier) {
    case 'def':
      return parseDeclaration(tokens, scope, startToken);
    default:
      return parseNonKeywordStatement(
        tokens,
        scope,
        identifier == null ? null : startToken,
      );
  }
}

Statement parseDeclaration(TokenIterator tokens, Scope scope, Token startToken) {
  String? name = tokens.getIdentifier();
  if (name == null) {
    throwCompileTimeException('expected identifier, but got ${tokens.current}', tokens.current);
  }
  if(!
  scope.declare(name)) {
    throwCompileTimeException('duplicate variable $name', tokens.current);
  }
  if (tokens.getSymbol(SymbolType.openparen)) {
    throw UnimplementedError('functions');
  }
  if (!tokens.getSymbol(SymbolType.lessThan)) {
    throwCompileTimeException('expected ( or < after "def $name", but got ${tokens.current}', tokens.current);
  }
  Expression value = parseExpression(tokens, scope);
  return VariableDeclarationStatement(startToken, name, value);
}

Statement parseNonKeywordStatement(
  TokenIterator tokens,
  Scope scope, [
  Token? startToken = null,
]) {
  Expression lhs = parseExpression(tokens, scope, startToken);
  if (!lhs.isAssignable) {
    return lhs;
  }
  throw UnimplementedError('assigning to expressions');
}

Expression parseExpression(
  TokenIterator tokens,
  Scope scope, [
  Token? startToken = null,
]) {
  Token _startToken = startToken ?? tokens.current;
  Expression lhs = parseXor(tokens, scope, startToken);
  if (tokens.getSymbol(SymbolType.verticalBar)) {
    Expression rhs = parseExpression(tokens, scope, null);
    return OrExpression(_startToken, lhs, rhs);
  }
  return lhs;
}

Expression parseXor(
  TokenIterator tokens,
  Scope scope, [
  Token? startToken = null,
]) {
  Token _startToken = startToken ?? tokens.current;
  Expression lhs = parseAnd(tokens, scope, startToken);
  if (tokens.getSymbol(SymbolType.caret)) {
    Expression rhs = parseXor(tokens, scope, null);
    return XorExpression(_startToken, lhs, rhs);
  }
  return lhs;
}

Expression parseAnd(
  TokenIterator tokens,
  Scope scope, [
  Token? startToken = null,
]) {
  Token _startToken = startToken ?? tokens.current;
  Expression lhs = parseMulDivMod(tokens, scope, startToken);
  if (tokens.getSymbol(SymbolType.caret)) {
    Expression rhs = parseAnd(tokens, scope, null);
    return AndExpression(_startToken, lhs, rhs);
  }
  return lhs;
}

Expression parseMulDivMod(
  TokenIterator tokens,
  Scope scope, [
  Token? startToken = null,
]) {
  Token _startToken = startToken ?? tokens.current;
  Expression lhs = parseAddSub(tokens, scope, startToken);
  if (tokens.getSymbol(SymbolType.star)) {
    Expression rhs = parseMulDivMod(tokens, scope, null);
    return MultiplyExpression(_startToken, lhs, rhs);
  }
  if (tokens.getSymbol(SymbolType.slash)) {
    Expression rhs = parseMulDivMod(tokens, scope, null);
    return DivideExpression(_startToken, lhs, rhs);
  }
  if (tokens.getSymbol(SymbolType.percentSign)) {
    Expression rhs = parseMulDivMod(tokens, scope, null);
    return ModulusExpression(_startToken, lhs, rhs);
  }
  return lhs;
}

Expression parseAddSub(
  TokenIterator tokens,
  Scope scope, [
  Token? startToken = null,
]) {
  Token _startToken = startToken ?? tokens.current;
  Expression lhs = parseIndexCall(tokens, scope, startToken);
  if (tokens.getSymbol(SymbolType.plus)) {
    Expression rhs = parseAddSub(tokens, scope, null);
    return AddExpression(_startToken, lhs, rhs);
  }
  if (tokens.getSymbol(SymbolType.minus)) {
    Expression rhs = parseAddSub(tokens, scope, null);
    return SubtractExpression(_startToken, lhs, rhs);
  }
  return lhs;
}

Expression parseIndexCall(
  TokenIterator tokens,
  Scope scope, [
  Token? startToken = null,
]) {
  Token _startToken = startToken ?? tokens.current;
  Expression lhs = parseBasicExpression(tokens, scope, startToken);
  if (tokens.getSymbol(SymbolType.opensquare)) {
    Expression rhs = parseExpression(tokens, scope, null);
    if (!tokens.getSymbol(SymbolType.closesquare)) {
      throw UnimplementedError('error message for no closesquare');
    }
    return IndexExpression(_startToken, lhs, rhs);
  }
  if (tokens.getSymbol(SymbolType.openparen)) {
    List<Expression> args = [];
    args.add(parseExpression(tokens, scope, null));
    while (!tokens.getSymbol(SymbolType.closeparen)) {
      args.add(parseExpression(tokens, scope, null));
    }
    return CallExpression(_startToken, lhs, args);
  }
  return lhs;
}

Expression parseBasicExpression(
  TokenIterator tokens,
  Scope scope, [
  Token? startToken = null,
]) {
  Token token = startToken ?? tokens.getT<Token>()!;
  switch (token) {
    case IdentifierToken():
      if (!scope.exists(token.value)) {
        throwCompileTimeException('unknown variable $token', token);
      }
      return VariableExpression(token);
    case StringToken():
      return StringExpression(token);
    default:
      throw UnimplementedError('basic $token');
  }
}
