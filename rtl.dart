import 'dart:convert';

import 'ast.dart';
import 'lexer.dart';

Scope rtl = Scope(null, 'rtl', IdentifierToken('import', 0, 0, 'rtl.dart'), [
  'rtl (./rtl.dart:1:1)',
])..variables.addAll(rtlVariables);

final Map<String, Object?> rtlVariables = {
  'print': (List<Object?> args, List<String> stackTrace) {
    stackTrace.add('print (./rtl.dart:6:1)');
    if (args.length != 1) {
      throwRuntimeException(
        'error: print expects 1 argument, got ${args.length}',
        stackTrace,
      );
    }
    Object? arg = args.single;
    if (arg is! List) {
      throwRuntimeException(
        'error: print expects list, got $arg',
        stackTrace,
      );
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
};
