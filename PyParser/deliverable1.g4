grammar deliverable1;

program : (statement NEWLINE | NEWLINE)* EOF ;

statement: assignment 
         | expr 
         ;

assignment: ID OPERATOR expr ;

expr: ID | ID OPERATOR ID expr* | OPERATOR ID ;

ID: [a-zA-Z_][a-zA-Z0-9_]* | NUMBER | '"'ID* ;
NUMBER: '-'?[0-9]+'.'*[0-9]* ;
OPERATOR: '=' | '+=' | '*=' | '-=' | '/=' | '/' | '%' | '-' | '+' | '*' ;
NEWLINE     : '\r'? '\n' ;
WS          : [ \t]+ -> skip ;  