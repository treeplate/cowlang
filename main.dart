import 'dart:io';

import 'ast.dart';
import 'lexer.dart';
import 'parser.dart' hide Scope;
import 'rtl.dart';

void main(List<String> args) {
  if (args.isEmpty) {
    args = ['main.cow'];
  }
  String filename = args.first;
  Iterable<Token> tokens = tokenize(File(filename).readAsStringSync(), filename);
  rtl.declareVariable('args', args.skip(1).map((e) => e.runes.toList()));
  Scope scope = Scope(rtl, '$filename', tokens.first, ['$filename (./$filename:1:1)']);
  for (Statement statement in parseTokens(tokens, rtl.variables.keys.toSet())) {
    statement.run(scope);
  }
}
