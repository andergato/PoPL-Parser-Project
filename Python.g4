grammar Python;

program : (statement NEWLINE | NEWLINE)* EOF ;

statement : assignment
          | expr
          ;

assignment : NAME '=' expr ;

expr : expr '+' expr
     | NUMBER
     | NAME
     ;

NAME    : [a-zA-Z_][a-zA-Z_0-9]* ;
NUMBER  : [0-9]+ ;
NEWLINE : '\r'? '\n' ;
WS      : [ \t]+ -> skip ;