grammar FunctionCraft;

// Lexer rules
// The lexer rules define patterns for recognizing tokens like numbers, booleans, strings,
// comments, keywords, identifiers, and operators in the input text. These rules are used
// by the lexer to break the input into a token stream.

// TODO

program: (func | ptrn)* main;

func: DEF name = ID LP param RP {System.out.println("FuncDec: " + $name.text);}func_body END;

ptrn: PATTERN name = ID LP param1 RP {System.out.println("PatternDec " + $name.text);} patrn_line* SEMI;

patrn_line: MID LP expr RP EQ expr;

param:
    | param1
    | LB param_opt RB
    | param1 COM LB param_opt RB
    ;

param1: ID COM param1
    | ID
    ;

param_opt: ID EQ expr COM param_opt
    | ID EQ expr
    ;

main: DEF MAIN LP RP {System.out.println("MAIN");} func_body END;

func_body: line* (RETURN expr? SEMI {System.out.println("RETRUN");})?;

line: name = ID EQ expr SEMI {System.out.println("Assignment: " + $name.text);}
    |expr SEMI
    | if
    | for
    | loop
    ;

if: IF {System.out.println("Decision: IF");} condition line+ (ELSEIF {System.out.println("Decision: ELSE IF");} condition line+)* (ELSE {System.out.println("Decision: ELSE");} line+)? END;

condition: LP expr RP;

for: FOR {System.out.println("Loop: FOR");} ID IN (ID | range) forline+ END;

range: LP (INT | ID) DD (INT | ID) RP;

loop: LOOPDO {System.out.println("Loop: DO");} forline+ END;

forline: line
    | BREAK SEMI {System.out.println("Control: BREAK");}
    | NEXT SEMI {System.out.println("Control: NEXT");}
    | BREAK IF {System.out.println("Control: BREAK");} condition SEMI
    | NEXT IF {System.out.println("Control: NEXT");} condition SEMI;

expr: expr (ASS | EQ) expr1 | expr1;
expr1: expr2 APP expr1 | expr2;
expr2: expr3 OR expr2 | expr3;
expr3: expr4 AND expr3 | expr4;
expr4: expr5 (EQL | NEQL) expr4 | expr5;
expr5: expr6 (LEQ | GEQ | LE | GE) expr5 | expr6;
expr6: expr7 (PLUS | MINUS) expr6 | expr7;
expr7: expr8 (MULT | DIV | MOD) expr7 | expr8;
expr8: (NOT | MINUS) expr9 | expr9;
expr9: (INC | DEC) expr10 | expr10;
expr10: expr10 LB expr RB | expr11;
expr11: LP expr RP | ID | literal | func_call;

literal: INT | FLOAT | STRING | BOOL | list | lambda;

lambda: ARROW LP param1 RP LC RETURN expr SEMI RC (LP input RP)? {System.out.println("Structure: LAMBDA");} ;

list: LB input RB | LB RB;

func_call:
     ID LP input RP
    | ID LP RP
    | METHOD LP CL ID RP
    | ID DOT BUILT_IN LP input RP
    ;

input: expr COM input
    | expr;

// Parser rules
// The parser rules start with the program rule, which defines the overall structure of a
// valid program. They then specify how tokens can be combined to form declarations, control
// structures, expressions, assignments, function calls, and other constructs within a program.
// The parser rules collectively define the syntax of the language.

// TODO
BUILT_IN: 'match' | 'push';
EQ: '=';
DOT: '.';
RC: '}';
ARROW: '->';
LC: '{';
PATTERN: 'pattern';
MID: '    |';
APP: '<<';
OR: '||';
AND: '&&';
EQL: '==';
NEQL: '!=';
LEQ: '<=';
GEQ: '>=';
LE: '<';
GE: '>';
PLUS: '+';
MINUS: '-';
MULT: '*';
DIV: '\\';
MOD: '%';
NOT: '!';
INC: '++';
DEC: '--';
METHOD: 'method';
MAIN: 'main';
ASS:  '+=' | '-=' | '*=' | '\\=' | '%=';
BOOL: 'true' | 'false';
INT: [1-9][0-9]* | '0';
FLOAT: INT '.' [0]* INT;
STRING: '"' ~["]* '"' ;
BREAK: 'break';
NEXT: 'next';
LOOPDO: 'loop do';
DD: '..';
FOR: 'for';
IN: 'in';
IF: 'if';
ELSEIF: 'elseif';
ELSE: 'else';
RETURN: 'return';
DEF: 'def';
END: 'end';
SEMI: ';';
LP: '(';
RP: ')';
LB: '[';
RB: ']';
COM: ',';
CL: ':';
ID: [a-zA-Z_][a-zA-Z0-9_]*;
WS: [ \t]+ -> skip;
NL: [\n\r]+ ->skip;