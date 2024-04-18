grammar FunctionCraft;

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

line:expr SEMI
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
    | NEXT IF {System.out.println("Control: NEXT");} condition SEMI
    ;
expr: name = variable {System.out.println("Assignment: " + $name.text);} (ASS | EQ) expr | expr1;
expr1: expr1 name = APP expr2 {System.out.println("Operator: " + $name.text);} | expr2;
expr2: LP expr2 RP name = OR LP expr3 RP {System.out.println("Operator: " + $name.text);} | expr3;
expr3: LP expr3 RP name = AND LP expr4 RP {System.out.println("Operator: " + $name.text);} | expr4;
expr4: expr4 name = (EQL | NEQL) expr5 {System.out.println("Operator: " + $name.text);} | expr5;
expr5: expr5 name = (LEQ | GEQ | LE | GE) expr6 {System.out.println("Operator: " + $name.text);} | expr6;
expr6: expr6 name = (PLUS | MINUS) expr7 {System.out.println("Operator: " + $name.text);} | expr7;
expr7: expr7 name = (MULT | DIV | MOD) expr8 {System.out.println("Operator: " + $name.text);} | expr8;
expr8: name = (NOT | MINUS) expr9 {System.out.println("Operator: " + $name.text);} | expr9;
expr9: name = (INC | DEC) expr10 {System.out.println("Operator: " + $name.text);} | expr10;
expr10: expr10 LB expr RB | expr11;
expr11: LP expr RP | ID | literal | func_call;

literal: INT | FLOAT | STRING | BOOL | list | lambda;

variable: ID | ID (LB expr RB)+;

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
    | expr
    ;
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
DIV: '/';
MOD: '%';
NOT: '!';
INC: '++';
DEC: '--';
METHOD: 'method';
MAIN: 'main';
ASS:  '+=' | '-=' | '*=' | '/=' | '%=';
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