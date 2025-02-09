import 'lexer.dart';

class Scope {
  final Scope? parent;

  final String name;
  final Token start;
  final List<String> stackTrace;

  Scope(this.parent, this.name, this.start, List<String> stackTrace) : stackTrace = stackTrace..add('$name (./${start.position})');

  final Map<String, Object?> variables = {};

  Object? getVariable(String variable) {
    return variables.containsKey(variable)
        ? variables[variable]
        : parent?.getVariable(variable);
  }
}

typedef CowFunction = Object? Function(List<Object?>, List<String> stackTrace);

Never throwCompileTimeException(String message, Token token) =>
    throw Exception('$message (./${token.position})');
Never throwRuntimeException(String message, List<String> stackTrace) =>
    throw Exception('$message\n${stackTrace.reversed.join('\n')}');

abstract class Statement {
  final Token start;

  void run(Scope scope);

  Statement(this.start);
}

abstract class Expression extends Statement {
  bool get isAssignable;
  void run(Scope scope) => eval(scope);
  Object? eval(Scope scope);

  Expression(super.start);
}

class OrExpression extends Expression {
  bool get isAssignable => false;
  final Expression lhs;
  final Expression rhs;
  String toString() => '$lhs | $rhs';

  OrExpression(super.start, this.lhs, this.rhs);

  @override
  Object? eval(Scope scope) {
    final Object? lhsValue = lhs.eval(scope);
    final Object? rhsValue = rhs.eval(scope);
    if (lhsValue is! int) {
      throwCompileTimeException(
        'lhs of or is not integer (is $lhsValue)',
        lhs.start,
      );
    }
    if (rhsValue is! int) {
      throwCompileTimeException(
        'rhs of or is not integer (is $rhsValue)',
        rhs.start,
      );
    }
    return lhsValue | rhsValue;
  }
}

class XorExpression extends Expression {
  bool get isAssignable => false;
  final Expression lhs;
  final Expression rhs;
  String toString() => '$lhs ^ $rhs';

  XorExpression(super.start, this.lhs, this.rhs);

  @override
  Object? eval(Scope scope) {
    final Object? lhsValue = lhs.eval(scope);
    final Object? rhsValue = rhs.eval(scope);
    if (lhsValue is! int) {
      throwCompileTimeException(
        'lhs of xor is not integer (is $lhsValue)',
        lhs.start,
      );
    }
    if (rhsValue is! int) {
      throwCompileTimeException(
        'rhs of xor is not integer (is $rhsValue)',
        rhs.start,
      );
    }
    return lhsValue ^ rhsValue;
  }
}

class AndExpression extends Expression {
  bool get isAssignable => false;
  final Expression lhs;
  final Expression rhs;
  String toString() => '$lhs & $rhs';

  AndExpression(super.start, this.lhs, this.rhs);

  @override
  Object? eval(Scope scope) {
    final Object? lhsValue = lhs.eval(scope);
    final Object? rhsValue = rhs.eval(scope);
    if (lhsValue is! int) {
      throwCompileTimeException(
        'lhs of and is not integer (is $lhsValue)',
        lhs.start,
      );
    }
    if (rhsValue is! int) {
      throwCompileTimeException(
        'rhs of and is not integer (is $rhsValue)',
        rhs.start,
      );
    }
    return lhsValue & rhsValue;
  }
}

class MultiplyExpression extends Expression {
  bool get isAssignable => false;
  final Expression lhs;
  final Expression rhs;
  String toString() => '$lhs * $rhs';

  MultiplyExpression(super.start, this.lhs, this.rhs);

  @override
  Object? eval(Scope scope) {
    final Object? lhsValue = lhs.eval(scope);
    final Object? rhsValue = rhs.eval(scope);
    if (lhsValue is! int) {
      throwCompileTimeException(
        'lhs of multiply is not integer (is $lhsValue)',
        lhs.start,
      );
    }
    if (rhsValue is! int) {
      throwCompileTimeException(
        'rhs of multiply is not integer (is $rhsValue)',
        rhs.start,
      );
    }
    return lhsValue * rhsValue;
  }
}

class DivideExpression extends Expression {
  bool get isAssignable => false;
  final Expression lhs;
  final Expression rhs;
  String toString() => '$lhs / $rhs';

  DivideExpression(super.start, this.lhs, this.rhs);
  @override
  Object? eval(Scope scope) {
    final Object? lhsValue = lhs.eval(scope);
    final Object? rhsValue = rhs.eval(scope);
    if (lhsValue is! int) {
      throwCompileTimeException(
        'lhs of divide is not integer (is $lhsValue)',
        lhs.start,
      );
    }
    if (rhsValue is! int) {
      throwCompileTimeException(
        'rhs of divide is not integer (is $rhsValue)',
        rhs.start,
      );
    }
    return lhsValue / rhsValue;
  }
}

class ModulusExpression extends Expression {
  bool get isAssignable => false;
  final Expression lhs;
  final Expression rhs;
  String toString() => '$lhs % $rhs';

  ModulusExpression(super.start, this.lhs, this.rhs);
  @override
  Object? eval(Scope scope) {
    final Object? lhsValue = lhs.eval(scope);
    final Object? rhsValue = rhs.eval(scope);
    if (lhsValue is! int) {
      throwCompileTimeException(
        'lhs of modulus is not integer (is $lhsValue)',
        lhs.start,
      );
    }
    if (rhsValue is! int) {
      throwCompileTimeException(
        'rhs of modulus is not integer (is $rhsValue)',
        rhs.start,
      );
    }
    return lhsValue % rhsValue;
  }
}

class AddExpression extends Expression {
  bool get isAssignable => false;
  final Expression lhs;
  final Expression rhs;
  String toString() => '$lhs + $rhs';

  AddExpression(super.start, this.lhs, this.rhs);
  @override
  Object? eval(Scope scope) {
    final Object? lhsValue = lhs.eval(scope);
    final Object? rhsValue = rhs.eval(scope);
    if (lhsValue is! int) {
      throwCompileTimeException(
        'lhs of add is not integer (is $lhsValue)',
        lhs.start,
      );
    }
    if (rhsValue is! int) {
      throwCompileTimeException(
        'rhs of add is not integer (is $rhsValue)',
        rhs.start,
      );
    }
    return lhsValue + rhsValue;
  }
}

class SubtractExpression extends Expression {
  bool get isAssignable => false;
  final Expression lhs;
  final Expression rhs;
  String toString() => '$lhs - $rhs';

  SubtractExpression(super.start, this.lhs, this.rhs);
  @override
  Object? eval(Scope scope) {
    final Object? lhsValue = lhs.eval(scope);
    final Object? rhsValue = rhs.eval(scope);
    if (lhsValue is! int) {
      throwCompileTimeException(
        'lhs of subtract is not integer (is $lhsValue)',
        lhs.start,
      );
    }
    if (rhsValue is! int) {
      throwCompileTimeException(
        'rhs of subtract is not integer (is $rhsValue)',
        rhs.start,
      );
    }
    return lhsValue - rhsValue;
  }
}

class IndexExpression extends Expression {
  bool get isAssignable => true;
  final Expression lhs;
  final Expression rhs;
  String toString() => '$lhs[$rhs]';

  IndexExpression(super.start, this.lhs, this.rhs);
  @override
  Object? eval(Scope scope) {
    final Object? lhsValue = lhs.eval(scope);
    final Object? rhsValue = rhs.eval(scope);
    if (lhsValue is! List) {
      throwCompileTimeException(
        'lhs of index is not list (is $lhsValue)',
        lhs.start,
      );
    }
    if (rhsValue is! int) {
      throwCompileTimeException(
        'rhs of index is not integer (is $rhsValue)',
        rhs.start,
      );
    }
    return lhsValue[rhsValue];
  }
}

class CallExpression extends Expression {
  bool get isAssignable => false;
  final Expression lhs;
  final List<Expression> args;
  String toString() => '$lhs(${args.join(', ')})';

  CallExpression(super.start, this.lhs, this.args);
  @override
  Object? eval(Scope scope) {
    final Object? lhsValue = lhs.eval(scope);
    if (lhsValue is! CowFunction) {
      throwCompileTimeException(
        'lhs of call is not function (is $lhsValue)',
        lhs.start,
      );
    }
    return lhsValue(args.map((e) => e.eval(scope)).toList(), scope.stackTrace);
  }
}

class VariableExpression extends Expression {
  final IdentifierToken token;
  String get variable => token.value;
  String toString() => variable;

  VariableExpression(this.token) : super(token);

  Object? eval(Scope scope) => scope.getVariable(variable);

  @override
  bool get isAssignable => true;
}

class StringExpression extends Expression {
  final StringToken token;
  String get string => token.value;
  String toString() => '\'variable\'';

  StringExpression(this.token) : super(token);

  Object? eval(Scope scope) => string.runes.toList();

  @override
  bool get isAssignable => true;
}
