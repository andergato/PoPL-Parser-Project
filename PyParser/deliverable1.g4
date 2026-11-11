grammar deliverable1;

start: statement* EOF ;
statement: assignment| assignment NEWLINE | NEWLINE ;
assignment: ID OPERATOR expression ;
expression: ID | ID OPERATOR ID expression* | OPERATOR ID ;

ID: [a-zA-Z_][a-zA-Z0-9_]* | '-'?[0-9]+'.'*[0-9]* | '"'ID* ;
OPERATOR: '=' | '+=' | '*=' | '-=' | '/=' | '/' | '%' | '-' | '+' | '*' ;
NEWLINE     : '\r'? '\n' ;
WS          : [ \t]+ -> skip ;  