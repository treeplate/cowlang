import 'dart:io';

import 'lexer.dart';

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
  print(tokens.toList());
}
