grammar FunctionCraft;

// Lexer rules
// The lexer rules define patterns for recognizing tokens like numbers, booleans, strings,
// comments, keywords, identifiers, and operators in the input text. These rules are used
// by the lexer to break the input into a token stream.

// TODO

program: (func | ptrn)* main;

func: DEF name = ID LP param RP {System.out.println("FuncDec: " + $name.text);}func_body END;

ptrn: PATTERN name = ID LP param1 RP {System.out.println("PatternDec: " + $name.text);} patrn_line* SEMI;

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

func_body: line* (RETURN {System.out.println("RETRUN");} expr? SEMI)?;

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
expr1: expr2 name = APP expr1 {System.out.println("Operator: " + $name.text);} | expr2;
expr2: expr3 name = OR expr2 {System.out.println("Operator: " + $name.text);} | expr3;
expr3: expr4 name = AND expr3 {System.out.println("Operator: " + $name.text);} | expr4;
expr4: expr5 name = (EQL | NEQL) expr4 {System.out.println("Operator: " + $name.text);} | expr5;
expr5: expr6 name = (LEQ | GEQ | LE | GE) expr5 {System.out.println("Operator: " + $name.text);} | expr6;
expr6: expr7 name = (PLUS | MINUS) expr6 {System.out.println("Operator: " + $name.text);} | expr7;
expr7: expr8 name = (MULT | DIV | MOD) expr7 {System.out.println("Operator: " + $name.text);} | expr8;
expr8: name = (NOT | MINUS) expr9 {System.out.println("Operator: " + $name.text);} | expr9;
expr9: name = (INC | DEC) expr10 {System.out.println("Operator: " + $name.text);} | expr10;
expr10: expr10 LB expr RB | expr11;
expr11: LP expr RP | ID | literal | func_call;

literal: INT | FLOAT | STRING | BOOL | list | lambda;

lambda: ARROW {System.out.println("Structure: LAMBDA");} LP param1 RP LC RETURN {System.out.println("RETURN");} expr SEMI RC (LP input RP)?;

list: LB input RB | LB RB;

func_call:
      name = BUILT_IN_FUNCTIONS {System.out.println("Built-In: " + $name.text.toUpperCase());} LP input RP
    | ID {System.out.println("FunctionCall");} LP input RP
    | ID {System.out.println("FunctionCall");} LP RP
    | METHOD LP CL ID RP
    | ID DOT name = BUILT_IN {System.out.println("Built-In: " + $name.text.toUpperCase());} LP input RP
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
BUILT_IN_FUNCTIONS: 'puts' | 'len' | 'chomp' | 'chop';
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
NL: [\n\r]+ -> skip;
COMMENT: '#' ~[\n]* -> skip;
ANY: .;
COMM: '=begin' ANY* '=end' -> skip;