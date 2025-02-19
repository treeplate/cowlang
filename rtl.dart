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
    stackTrace.add('print (./rtl.dart:14:1)');
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
  'intToStr': (List<Object?> args, List<String> stackTrace) {
    // maybe implement in .cow file?
    stackTrace.add('intToStr (./rtl.dart:35:1)');
    if (args.length != 1) {
      throwRuntimeException(
        'error: intToStr expects 1 argument, got ${args.length}',
        stackTrace,
      );
    }
    Object? arg = args.single;
    if (arg is! int) {
      throwRuntimeException(
        'error: intToStr expects int, got $arg',
        stackTrace,
      );
    }
    stackTrace.removeLast();
    return arg.toString().runes.toList();
  },
  'random': (List<Object?> args, List<String> stackTrace) {
    stackTrace.add('random (./rtl.dart:54:1)');
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
    stackTrace.add('input (./rtl.dart:69:1)');
    if (args.length != 0) {
      throwRuntimeException(
        'error: input expects 0 arguments, got ${args.length}',
        stackTrace,
      );
    }
    stackTrace.removeLast();
    return stdin.readLineSync()!.runes.toList();
  },
  'strToInt': (List<Object?> args, List<String> stackTrace) {
    // maybe implement in .cow file?
    stackTrace.add('strToInt (./rtl.dart:80:1)');
    if (args.length != 1) {
      throwRuntimeException(
        'error: strToInt expects 1 argument, got ${args.length}',
        stackTrace,
      );
    }
    Object? arg = args.single;
    if (arg is! List) {
      throwRuntimeException(
        'error: strToInt expects list, got $arg',
        stackTrace,
      );
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
  'positive': (List<Object?> args, List<String> stackTrace) {
    // maybe implement in .cow file?
    stackTrace.add('positive (./rtl.dart:105:1)');
    if (args.length != 1) {
      throwRuntimeException(
        'error: positive expects 1 argument, got ${args.length}',
        stackTrace,
      );
    }
    Object? arg = args.single;
    if (arg is! int) {
      throwRuntimeException(
        'error: positive expects int, got $arg',
        stackTrace,
      );
    }
    stackTrace.removeLast();
    return arg > 0 ? 0 : 1;
  },
  'readFile': (List<Object?> args, List<String> stackTrace) {
    stackTrace.add('readFile (./rtl.dart:124:1)');
    if (args.length != 1) {
      throwRuntimeException(
        'error: readFile expects 1 argument, got ${args.length}',
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
    stackTrace.removeLast();
    return File(String.fromCharCodes(arg.cast())).readAsStringSync().runes.toList();
  },
  'split': (List<Object?> args, List<String> stackTrace) {
    stackTrace.add('split ./rtl.dart:145:1)');
    if (args.length != 2) {
      throwRuntimeException(
        'error: split expects 2 arguments, got ${args.length}',
        stackTrace,
      );
    }
    Object? arg = args.first;
    if (arg is! List) {
      throwRuntimeException('error: print expects list, got $arg', stackTrace);
    }
    Object? arg2 = args.last;
    List<List<Object?>> result = [];
    List<Object?> list = [];
    for (Object? element in arg) {
      if (element == arg2) {
        result.add(list);
        list = [];
      } else {
        list.add(element);
      }
    }
    result.add(list);
    stackTrace.removeLast();
    return result;
  },
};
