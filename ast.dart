import 'lexer.dart';

class Scope {
  final Scope? parent;

  final String name;
  final Token start;
  final List<String> stackTrace;

  Scope(this.parent, this.name, this.start, List<String> stackTrace)
    : stackTrace = stackTrace..add('$name (./${start.position})');

  final Map<String, Object?> variables = {};

  Object? getVariable(String variable) {
    assert(parent != null || variables.containsKey(variable));
    return variables.containsKey(variable)
        ? variables[variable]
        : parent?.getVariable(variable);
  }

  void declareVariable(String variable, Object? value) {
    assert (!variables.containsKey(variable));
    variables[variable] = value;
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
      throwRuntimeException(
        'lhs of or is not integer (is $lhsValue)',
        scope.stackTrace,
      );
    }
    if (rhsValue is! int) {
      throwRuntimeException(
        'rhs of or is not integer (is $rhsValue)',
        scope.stackTrace,
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
      throwRuntimeException(
        'lhs of xor is not integer (is $lhsValue)',
        scope.stackTrace,
      );
    }
    if (rhsValue is! int) {
      throwRuntimeException(
        'rhs of xor is not integer (is $rhsValue)',
        scope.stackTrace,
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
      throwRuntimeException(
        'lhs of and is not integer (is $lhsValue)',
        scope.stackTrace,
      );
    }
    if (rhsValue is! int) {
      throwRuntimeException(
        'rhs of and is not integer (is $rhsValue)',
        scope.stackTrace,
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
      throwRuntimeException(
        'lhs of multiply is not integer (is $lhsValue)',
        scope.stackTrace,
      );
    }
    if (rhsValue is! int) {
      throwRuntimeException(
        'rhs of multiply is not integer (is $rhsValue)',
        scope.stackTrace,
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
      throwRuntimeException(
        'lhs of divide is not integer (is $lhsValue)',
        scope.stackTrace,
      );
    }
    if (rhsValue is! int) {
      throwRuntimeException(
        'rhs of divide is not integer (is $rhsValue)',
        scope.stackTrace,
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
      throwRuntimeException(
        'lhs of modulus is not integer (is $lhsValue)',
        scope.stackTrace,
      );
    }
    if (rhsValue is! int) {
      throwRuntimeException(
        'rhs of modulus is not integer (is $rhsValue)',
        scope.stackTrace,
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
      throwRuntimeException(
        'lhs of add is not integer (is $lhsValue)',
        scope.stackTrace,
      );
    }
    if (rhsValue is! int) {
      throwRuntimeException(
        'rhs of add is not integer (is $rhsValue)',
        scope.stackTrace,
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
      throwRuntimeException(
        'lhs of subtract is not integer (is $lhsValue)',
        scope.stackTrace,
      );
    }
    if (rhsValue is! int) {
      throwRuntimeException(
        'rhs of subtract is not integer (is $rhsValue)',
        scope.stackTrace,
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
      throwRuntimeException(
        'lhs of index is not list (is $lhsValue)',
        scope.stackTrace,
      );
    }
    if (rhsValue is! int) {
      throwRuntimeException(
        'rhs of index is not integer (is $rhsValue)',
        scope.stackTrace,
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
      throwRuntimeException(
        'lhs of call is not function (is $lhsValue) at ./${lhs.start.position}',
        scope.stackTrace,
      );
    }
    return lhsValue(args.map((e) => e.eval(scope)).toList(), scope.stackTrace);
  }
}

class VariableExpression extends Expression {
  final IdentifierToken token;
  String toString() => token.value;

  VariableExpression(this.token) : super(token);

  Object? eval(Scope scope) => scope.getVariable(token.value);

  @override
  bool get isAssignable => true;
}

class StringExpression extends Expression {
  final StringToken token;
  String toString() => '\'${token.value}\'';

  StringExpression(this.token) : super(token);

  Object? eval(Scope scope) => token.value.runes.toList();

  @override
  bool get isAssignable => true;
}

class VariableDeclarationStatement extends Statement {
  final String name;
  final Expression value;

  VariableDeclarationStatement(super.start, this.name, this.value);
  @override
  void run(Scope scope) {
    scope.declareVariable(name, value.eval(scope));
  }
}
