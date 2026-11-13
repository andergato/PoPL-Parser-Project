grammar deliverable1;

program : (statement (NEWLINE+ statement)* | NEWLINE)* EOF ;

statement: assignment 
         | expr 
         ;

assignment: ID ASSIGN_OP expr 
          | ID ASSIGN_OP array
          ;

expr: expr ('*' | '/' | '%') expr // pemdas
    | expr ('+' | '-') expr
    | '-' expr             
    | '(' expr ')'
    | atom
    ;

// ID = var name | NUMBER = int or float | STRING = quoted literal text
atom: ID | NUMBER | STRING | BOOL;

// implement array here
array: '[' (NUMBER',')* NUMBER* ']'    // Floats or ints
     | '[' (STRING',')* STRING* ']'    // Strings
     | '[' (array',')* array* ']'      // Array of arrays
     ;

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
