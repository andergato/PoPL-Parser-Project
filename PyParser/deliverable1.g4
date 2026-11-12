grammar deliverable1;

program : (statement NEWLINE | NEWLINE)* EOF ;

statement: assignment 
         | expr 
         ;

assignment: ID ASSIGN_OP expr ;

expr: expr ('*' | '/' | '%') expr // pemdas
    | expr ('+' | '-') expr
    | '-' expr             
    | '(' expr ')'
    | atom
    ;

// ID = var name | NUMBER = int or float | STRING = quoted literal text
atom: ID | NUMBER | STRING | BOOL;

// implement array here

// arithmetic operators (+ - * / %) are literals in expr above, so only assignemnt need parse
ASSIGN_OP: '=' | '+=' | '-=' | '*=' | '/=' ;
BOOL: 'True' | 'False' ;                  // must stay above ID so t/f aren't parsed as var names
ID: [a-zA-Z_][a-zA-Z0-9_]* ;                // var names 
NUMBER: [0-9]+ ('.' [0-9]+)? ;            // negatives handled by '-' expr
STRING: '"' ~["\r\n]* '"'                   
      | '\'' ~['\r\n]* '\''              // 'a' or "a" or whatever are both valid strings
      ;
NEWLINE     : '\r'? '\n' ; 
WS          : [ \t]+ -> skip ;   // ignore whitespace
