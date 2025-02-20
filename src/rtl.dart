import 'dart:math';
import 'dart:io';

import 'ast.dart';
import 'lexer.dart';

Scope rtl = Scope(null, 'rtl', IdentifierToken('import', 0, 0, 'rtl.dart'), [
  'rtl (./src/rtl.dart:1:1)',
])..variables.addAll(rtlVariables);

final Random random = Random();

final Map<String, Object?> rtlVariables = {
  'print': (List<Object?> args, List<String> stackTrace) {
    stackTrace.add('print (./src/rtl.dart:14:1)');
    if (args.length != 1) {
      throwRuntimeException(
        'error: print expects 1 argument, got ${args.length}',
        stackTrace,
        null,
      );
    }
    Object? arg = args.single;
    if (arg is! List) {
      throwRuntimeException(
        'error: print expects list, got $arg',
        stackTrace,
        null,
      );
    }
    if (arg.any((e) => e is! int)) {
      throwRuntimeException(
        'error: print expects list of numbers, got $arg (containing a non-number)',
        stackTrace,
        null,
      );
    }
    print(String.fromCharCodes(arg.cast()));
    stackTrace.removeLast();
  },
  'intToStr': (List<Object?> args, List<String> stackTrace) {
    // maybe implement in .cow file?
    stackTrace.add('intToStr (./src/rtl.dart:41:1)');
    if (args.length != 1) {
      throwRuntimeException(
        'error: intToStr expects 1 argument, got ${args.length}',
        stackTrace,
        null,
      );
    }
    Object? arg = args.single;
    if (arg is! int) {
      throwRuntimeException(
        'error: intToStr expects int, got $arg',
        stackTrace,
        null,
      );
    }
    stackTrace.removeLast();
    return arg.toString().runes.toList();
  },
  'random': (List<Object?> args, List<String> stackTrace) {
    stackTrace.add('random (./src/rtl.dart:62:1)');
    if (args.length != 1) {
      throwRuntimeException(
        'error: intToStr expects 1 argument, got ${args.length}',
        stackTrace,
        null,
      );
    }
    Object? arg = args.single;
    if (arg is! int) {
      throwRuntimeException(
        'error: random expects int, got $arg',
        stackTrace,
        null,
      );
    }
    stackTrace.removeLast();
    return random.nextInt(arg);
  },
  'input': (List<Object?> args, List<String> stackTrace) {
    stackTrace.add('input (./src/rtl.dart:82:1)');
    if (args.length != 0) {
      throwRuntimeException(
        'error: input expects 0 arguments, got ${args.length}',
        stackTrace,
        null,
      );
    }
    stackTrace.removeLast();
    return stdin.readLineSync()!.runes.toList();
  },
  'strToInt': (List<Object?> args, List<String> stackTrace) {
    // maybe implement in .cow file?
    stackTrace.add('strToInt (./src/rtl.dart:94:1)');
    if (args.length != 1) {
      throwRuntimeException(
        'error: strToInt expects 1 argument, got ${args.length}',
        stackTrace,
        null,
      );
    }
    Object? arg = args.single;
    if (arg is! List) {
      throwRuntimeException(
        'error: strToInt expects list, got $arg',
        stackTrace,
        null,
      );
    }
    if (arg.any((e) => e is! int)) {
      throwRuntimeException(
        'error: strToInt expects list of numbers, got $arg (containing a non-number)',
        stackTrace,
        null,
      );
    }
    stackTrace.removeLast();
    return int.parse(String.fromCharCodes(arg.cast()));
  },
  'positive': (List<Object?> args, List<String> stackTrace) {
    // maybe implement in .cow file?
    stackTrace.add('positive (./src/rtl.dart:122:1)');
    if (args.length != 1) {
      throwRuntimeException(
        'error: positive expects 1 argument, got ${args.length}',
        stackTrace,
        null,
      );
    }
    Object? arg = args.single;
    if (arg is! int) {
      throwRuntimeException(
        'error: positive expects int, got $arg',
        stackTrace,
        null,
      );
    }
    stackTrace.removeLast();
    return arg > 0 ? 0 : 1;
  },
  'readFile': (List<Object?> args, List<String> stackTrace) {
    stackTrace.add('readFile (./src/rtl.dart:143:1)');
    if (args.length != 1) {
      throwRuntimeException(
        'error: readFile expects 1 argument, got ${args.length}',
        stackTrace,
        null,
      );
    }
    Object? arg = args.single;
    if (arg is! List) {
      throwRuntimeException(
        'error: print expects list, got $arg',
        stackTrace,
        null,
      );
    }
    if (arg.any((e) => e is! int)) {
      throwRuntimeException(
        'error: print expects list of numbers, got $arg (containing a non-number)',
        stackTrace,
        null,
      );
    }
    stackTrace.removeLast();
    return File(
      String.fromCharCodes(arg.cast()),
    ).readAsStringSync().runes.toList();
  },
  'split': (List<Object?> args, List<String> stackTrace) {
    // maybe implement in .cow file?
    stackTrace.add('split (./src/rtl.dart:172:1)');
    if (args.length != 2) {
      throwRuntimeException(
        'error: split expects 2 arguments, got ${args.length}',
        stackTrace,
        null,
      );
    }
    Object? arg = args.first;
    if (arg is! List) {
      throwRuntimeException(
        'error: split expects list, got $arg',
        stackTrace,
        null,
      );
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
  'length': (List<Object?> args, List<String> stackTrace) {
    stackTrace.add('length (./src/rtl.dart:205:1)');
    if (args.length != 1) {
      throwRuntimeException(
        'error: length expects 1 argument, got ${args.length}',
        stackTrace,
        null,
      );
    }
    Object? arg = args.first;
    if (arg is! List) {
      throwRuntimeException(
        'error: length expects list, got $arg',
        stackTrace,
        null,
      );
    }
    stackTrace.removeLast();
    return arg.length;
  },
  'list': (List<Object?> args, List<String> stackTrace) {
    stackTrace.add('list (./src/rtl.dart:225:1)');
    if (args.length != 1) {
      throwRuntimeException(
        'error: list expects 1 argument, got ${args.length}',
        stackTrace,
        null,
      );
    }
    Object? arg = args.first;
    if (arg is! int) {
      throwRuntimeException(
        'error: list expects int, got $arg',
        stackTrace,
        null,
      );
    }
    stackTrace.removeLast();
    return List<Object?>.filled(arg, 0);
  },
  'addTo': (List<Object?> args, List<String> stackTrace) {
    stackTrace.add('addTo (./src/rtl.dart:245:1)');
    if (args.length != 2) {
      throwRuntimeException(
        'error: addTo expects 2 arguments, got ${args.length}',
        stackTrace,
        null,
      );
    }
    Object? arg = args.first;
    if (arg is! List) {
      throwRuntimeException(
        'error: addTo expects list, got $arg',
        stackTrace,
        null,
      );
    }
    Object? arg2= args.last;
    arg.add(arg2);
    stackTrace.removeLast();
  },
  'addToAt': (List<Object?> args, List<String> stackTrace) {
    stackTrace.add('addToAt (./src/rtl.dart:266:1)');
    if (args.length != 3) {
      throwRuntimeException(
        'error: addToAt expects 3 arguments, got ${args.length}',
        stackTrace,
        null,
      );
    }
    Object? arg = args.first;
    if (arg is! List) {
      throwRuntimeException(
        'error: addToAt expects list, got $arg',
        stackTrace,
        null,
      );
    }
    final Object? arg2 = args[1];
    if (arg2 is! int) {
      throwRuntimeException(
        'error: addToAt expects int, got $arg',
        stackTrace,
        null,
      );
    }
    Object? arg3= args.last;
    arg.insert(arg2, arg3);
    stackTrace.removeLast();
  },
  'popFrom': (List<Object?> args, List<String> stackTrace) {
    stackTrace.add('popFrom (./src/rtl.dart:245:1)');
    if (args.length != 1) {
      throwRuntimeException(
        'error: popFrom expects 1 argument, got ${args.length}',
        stackTrace,
        null,
      );
    }
    Object? arg = args.first;
    if (arg is! List) {
      throwRuntimeException(
        'error: popFrom expects list, got $arg',
        stackTrace,
        null,
      );
    }
    stackTrace.removeLast();
    return arg.removeLast();
  },
  'popFromAt': (List<Object?> args, List<String> stackTrace) {
    stackTrace.add('popFromAt (./src/rtl.dart:266:1)');
    if (args.length != 2) {
      throwRuntimeException(
        'error: popFromAt expects 2 arguments, got ${args.length}',
        stackTrace,
        null,
      );
    }
    Object? arg = args.first;
    if (arg is! List) {
      throwRuntimeException(
        'error: popFromAt expects list, got $arg',
        stackTrace,
        null,
      );
    }
    final Object? arg2 = args[1];
    if (arg2 is! int) {
      throwRuntimeException(
        'error: popFromAt expects int, got $arg',
        stackTrace,
        null,
      );
    }
    stackTrace.removeLast();
    return arg.removeAt(arg2);
  },
};
