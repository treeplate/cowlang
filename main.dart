import 'dart:io';

import 'ast.dart';
import 'lexer.dart';
import 'parser.dart' hide Scope;
import 'rtl.dart';

void main(List<String> args) {
  if (args.isEmpty) {
    args = ['main.cow'];
  }
  if (args.length > 1) {
    print('Give this program 1 argument: the file name.');
    exit(1);
  }
  String filename = args.single;
  Iterable<Token> tokens = tokenize(File(filename).readAsStringSync(), filename);
  Scope scope = Scope(rtl, '$filename', tokens.first, ['$filename (./$filename:1:1)']);
  for (Statement statement in parseTokens(tokens, rtl.variables.keys.toList())) {
    statement.run(scope);
  }
}
