grammar FunctionCraft;

// Lexer rules
// The lexer rules define patterns for recognizing tokens like numbers, booleans, strings,
// comments, keywords, identifiers, and operators in the input text. These rules are used
// by the lexer to break the input into a token stream.

// TODO

// Parser rules
// The parser rules start with the program rule, which defines the overall structure of a
// valid program. They then specify how tokens can be combined to form declarations, control
// structures, expressions, assignments, function calls, and other constructs within a program.
// The parser rules collectively define the syntax of the language.

// TODO



//grammar test
//    ;

program: stat_block+ EOF;

stat_block: OBRACE block CBRACE;

block: (stat (stat ';')*)?;

stat: expr ';'?;

expr
    : expr ('*' | '/') expr
    | expr ('+' | '-') expr
    | expr ('<' | '<=' | '>=' | '>' | '=') expr
    | expr ( '&&' | '||') expr
    | expr '(' exprList? ')'
    | IF condition_block (ELSE stat_block)?
    | ID
    | INT
    ;

exprList: expr (',' expr)*;

condition_block: OPAR expr CPAR stat_block;

IF:      'IF';
ELSE:    'ELSE';
OPAR:    '(';
CPAR:    ')';
OBRACE:  '{';
CBRACE:  '}';
ID:      [a-zA-Z]+;
INT:     [0-9]+;
NEWLINE: '\r'? '\n' -> skip;
WS:      [ \t]+     -> skip;
