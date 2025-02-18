import 'dart:math';
import 'dart:io';

import 'ast.dart';
import 'lexer.dart';

Scope rtl = Scope(null, 'rtl', IdentifierToken('import', 0, 0, 'rtl.dart'), [
  'rtl (./rtl.dart:1:1)',
])..variables.addAll(rtlVariables);

final Random random = Random();

final Map<String, Object?> rtlVariables = {
  'print': (List<Object?> args, List<String> stackTrace) {
    stackTrace.add('print (./rtl.dart:15:1)');
    if (args.length != 1) {
      throwRuntimeException(
        'error: print expects 1 argument, got ${args.length}',
        stackTrace,
      );
    }
    Object? arg = args.single;
    if (arg is! List) {
      throwRuntimeException('error: print expects list, got $arg', stackTrace);
    }
    if (arg.any((e) => e is! int)) {
      throwRuntimeException(
        'error: print expects list of numbers, got $arg (containing a non-number)',
        stackTrace,
      );
    }
    print(String.fromCharCodes(arg.cast()));
    stackTrace.removeLast();
  },
  'intToStr': (List<Object?> args, List<String> stackTrace) { // maybe implement in .cow file?
    stackTrace.add('intToStr (./rtl.dart:36:1)');
    if (args.length != 1) {
      throwRuntimeException(
        'error: intToStr expects 1 argument, got ${args.length}',
        stackTrace,
      );
    }
    Object? arg = args.single;
    if (arg is! int) {
      throwRuntimeException('error: intToStr expects int, got $arg', stackTrace);
    }
    stackTrace.removeLast();
    return arg.toString().runes.toList();
  },
  'random': (List<Object?> args, List<String> stackTrace) {
    stackTrace.add('random (./rtl.dart:51:1)');
    if (args.length != 1) {
      throwRuntimeException(
        'error: intToStr expects 1 argument, got ${args.length}',
        stackTrace,
      );
    }
    Object? arg = args.single;
    if (arg is! int) {
      throwRuntimeException('error: random expects int, got $arg', stackTrace);
    }
    stackTrace.removeLast();
    return random.nextInt(arg);
  },
  'input': (List<Object?> args, List<String> stackTrace) {
    stackTrace.add('input (./rtl.dart:66:1)');
    if (args.length != 0) {
      throwRuntimeException(
        'error: input expects 0 arguments, got ${args.length}',
        stackTrace,
      );
    }
    stackTrace.removeLast();
    return stdin.readLineSync()!.runes.toList();
  },
  'strToInt': (List<Object?> args, List<String> stackTrace) { // maybe implement in .cow file?
    stackTrace.add('strToInt (./rtl.dart:77:1)');
    if (args.length != 1) {
      throwRuntimeException(
        'error: strToInt expects 1 argument, got ${args.length}',
        stackTrace,
      );
    }
    Object? arg = args.single;
    if (arg is! List) {
      throwRuntimeException('error: strToInt expects list, got $arg', stackTrace);
    }
    if (arg.any((e) => e is! int)) {
      throwRuntimeException(
        'error: strToInt expects list of numbers, got $arg (containing a non-number)',
        stackTrace,
      );
    }
    stackTrace.removeLast();
    return int.parse(String.fromCharCodes(arg.cast()));
  },
  'positive': (List<Object?> args, List<String> stackTrace) { // maybe implement in .cow file?
    stackTrace.add('positive (./rtl.dart:98:1)');
    if (args.length != 1) {
      throwRuntimeException(
        'error: positive expects 1 argument, got ${args.length}',
        stackTrace,
      );
    }
    Object? arg = args.single;
    if (arg is! int) {
      throwRuntimeException('error: positive expects int, got $arg', stackTrace);
    }
    stackTrace.removeLast();
    return arg > 0 ? 0 : 1;
  },
};
