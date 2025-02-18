<!--notes: [Cowlang notes](https://docs.google.com/document/d/1jBb2ohLs_encwlUkp4AyLOV3C_OK5gZgwTSZnoHcvDs/edit?usp=sharing)-->
# Tokens
There are 4 types of tokens.
## String
Strings are `'`-delimeted with no escapes.
## Integers
Integers are sequences of the following characters: `0123456789`. This is required to fit in 63 bits.
## Symbols
Symbols are the following characters: `[](),+-*/%&|^<`.
## Comments
`//` denotes the start of a comment, which ends at the first newline (0xa) that isn't preceded by a `\`.
## Whitespace
Spaces (0x20), tabs (0x9), carriage returns (0xd), and newlines (0xa) are ignored
## Identifiers
Any other character marks the start of an identifier, which ends at a space, tab, carriage return, newline, or any of the following characters: `[](),+-*/%&|^<`.
# Parsing
## Statements
These tokens are parsed into a set of statements, which are parsed the following way:
### Starting with identifier `def`
Parse an identifier (the name).
#### Next token is `(`
Parse identifiers until you get to a `)` (the parameters).
Parse statements until you get to an identifier `end` (the body).
The statement is declaring a function.
#### Next token is `<`
Parse an expression.
The statement is evaluating the expression and assigning it to a new variable.
### Starting with identifier `if`
First, parse an expression (the condition).
Then, parse statements until there is an identifier `end`. (the block).
The statement is executing the block only if the condition evaluates to 0.
### Other
First, parse an expression.
If that expression is assignable (indexing or variable) and the next token is `<`, parse another expression. The statement is assigning the second expression to the first expression.
Otherwise, the statement is evaluating the expression.
## Expressions
The following table lists the precedence of expressions. Expressions are listed top to bottom, in descending precedence. In case of precedence tie, expressions are right-associative. a, b and c are operands.
- `a | b` (bitwise or)
- `a ^ b` (bitwise xor)
- `a & b` (bitwise and)
- `a * b` (multiply), `a / b` (divide and floor), `a % b` (modulus)
- `a + b` (add), `a - b` (subtract)
- `a[b]` (indexing into a list), `a(b c)` (function call)
- identifiers (variable), strings, and integerss