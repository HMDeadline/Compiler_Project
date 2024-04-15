grammar test
    ;

prog: stat_block+ EOF;

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
