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
    assert(!variables.containsKey(variable));
    variables[variable] = value;
  }

  void assign(String variable, Object? value) {
    assert(parent != null || variables.containsKey(variable));
    if (variables.containsKey(variable)) {
      variables[variable] = value;
    } else {
      parent?.assign(variable, value);
    }
  }

  Scope child(String name, Token start) => Scope(this, name, start, stackTrace);

  void end() => stackTrace.removeLast();

  void setStackTracePosition(Token position) {
    stackTrace.last.replaceAll(RegExp('\\(.*\\)'), '(${position.position})');
  }
}

typedef CowFunction = Object? Function(List<Object?>, List<String> stackTrace);

Never throwRuntimeException(
  String message,
  List<String> stackTrace,
  Token? token,
) =>
    throw Exception(
      '$message${token == null ? '' : ' (./${token.position})'}\n${stackTrace.reversed.join('\n')}',
    );

abstract class Statement {
  final Token start;

  void run(Scope scope);
  Statement(this.start);
}

abstract class Expression extends Statement {
  bool get isAssignable;
  void run(Scope scope) => eval(scope);
  Object? eval(Scope scope);
  void assignTo(Expression value, Scope scope) {
    if (isAssignable) {
      throw UnimplementedError('${runtimeType}.assignTo');
    } else {
      throw UnsupportedError(
        '${runtimeType}.assignTo ($runtimeType is not assignable)',
      );
    }
  }

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
        lhs.start,
      );
    }
    if (rhsValue is! int) {
      throwRuntimeException(
        'rhs of or is not integer (is $rhsValue)',
        scope.stackTrace,
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
      throwRuntimeException(
        'lhs of xor is not integer (is $lhsValue)',
        scope.stackTrace,
        lhs.start,
      );
    }
    if (rhsValue is! int) {
      throwRuntimeException(
        'rhs of xor is not integer (is $rhsValue)',
        scope.stackTrace,
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
      throwRuntimeException(
        'lhs of and is not integer (is $lhsValue)',
        scope.stackTrace,
        lhs.start,
      );
    }
    if (rhsValue is! int) {
      throwRuntimeException(
        'rhs of and is not integer (is $rhsValue)',
        scope.stackTrace,
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
      throwRuntimeException(
        'lhs of multiply is not integer (is $lhsValue)',
        scope.stackTrace,
        lhs.start,
      );
    }
    if (rhsValue is! int) {
      throwRuntimeException(
        'rhs of multiply is not integer (is $rhsValue)',
        scope.stackTrace,
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
      throwRuntimeException(
        'lhs of divide is not integer (is $lhsValue)',
        scope.stackTrace,
        lhs.start,
      );
    }
    if (rhsValue is! int) {
      throwRuntimeException(
        'rhs of divide is not integer (is $rhsValue)',
        scope.stackTrace,
        rhs.start,
      );
    }
    return lhsValue ~/ rhsValue;
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
        lhs.start,
      );
    }
    if (rhsValue is! int) {
      throwRuntimeException(
        'rhs of modulus is not integer (is $rhsValue)',
        scope.stackTrace,
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
      throwRuntimeException(
        'lhs of add is not integer (is $lhsValue)',
        scope.stackTrace,
        lhs.start,
      );
    }
    if (rhsValue is! int) {
      throwRuntimeException(
        'rhs of add is not integer (is $rhsValue)',
        scope.stackTrace,
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
      throwRuntimeException(
        'lhs of subtract is not integer (is $lhsValue)',
        scope.stackTrace,
        lhs.start,
      );
    }
    if (rhsValue is! int) {
      throwRuntimeException(
        'rhs of subtract is not integer (is $rhsValue)',
        scope.stackTrace,
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
      throwRuntimeException(
        'lhs of index is not list (is $lhsValue)',
        scope.stackTrace,
        lhs.start,
      );
    }
    if (rhsValue is! int) {
      throwRuntimeException(
        'rhs of index is not integer (is $rhsValue)',
        scope.stackTrace,
        rhs.start,
      );
    }
    try {
      return lhsValue[rhsValue];
    } catch (error) {
      throwRuntimeException(error.toString(), scope.stackTrace, rhs.start);
    }
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
        lhs.start,
      );
    }
    scope.setStackTracePosition(start);
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

  void assignTo(Expression value, Scope scope) {
    scope.assign(token.value, value.eval(scope));
  }
}

class StringExpression extends Expression {
  final StringToken token;
  String toString() => '\'${token.value}\'';

  StringExpression(this.token) : super(token);

  Object? eval(Scope scope) => token.value.runes.toList();

  @override
  bool get isAssignable => false;
}

class IntegerExpression extends Expression {
  final IntegerToken token;
  String toString() => token.value.toString();

  IntegerExpression(this.token) : super(token);

  Object? eval(Scope scope) => token.value;

  @override
  bool get isAssignable => false;
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

class AssignmentStatement extends Statement {
  final Expression lhs;
  final Expression rhs;

  AssignmentStatement(this.lhs, this.rhs) : super(lhs.start) {
    assert(lhs.isAssignable);
  }
  @override
  void run(Scope scope) {
    lhs.assignTo(rhs, scope);
  }
}

class FunctionStatement extends Statement {
  final String name;
  final List<String> params;
  final List<Statement> body;

  FunctionStatement(this.name, this.params, this.body, super.start);

  @override
  void run(Scope scope) {
    scope.declareVariable(name, (List<Object?> args, List<String> stack) {
      Scope funcScope = scope.child('$name', start);
      if (args.length < params.length) {
        throwRuntimeException(
          'Not enough arguments provided to $name',
          funcScope.stackTrace,
          start,
        );
      }
      if (args.length > params.length) {
        throwRuntimeException(
          'Too many arguments provided to $name',
          funcScope.stackTrace,
          start,
        );
      }
      int i = 0;
      while (i < params.length) {
        funcScope.declareVariable(params[i], args[i]);
        i++;
      }
      funcScope.declareVariable('result', null);
      for (Statement statement in body) {
        statement.run(funcScope);
      }
      funcScope.end();
      return funcScope.getVariable('result');
    });
  }
}

class IfStatement extends Statement {
  final Expression condition;
  final List<Statement> body;

  IfStatement(this.condition, this.body, super.start);

  @override
  void run(Scope scope) {
    if (condition.eval(scope) == 0) {
      Scope ifScope = scope.child('if statement', start);
      for (Statement statement in body) {
        statement.run(ifScope);
      }
      ifScope.end();
    }
  }
}

class LoopStatement extends Statement {
  final Expression condition;
  final List<Statement> body;

  LoopStatement(this.condition, this.body, super.start);

  @override
  void run(Scope scope) {
    while (condition.eval(scope) == 0) {
      Scope whileScope = scope.child('while statement', start);
      for (Statement statement in body) {
        statement.run(whileScope);
      }
      whileScope.end();
    }
  }
}
