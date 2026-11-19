grammar deliverable2;

// The lexer turns indentation into INDENT/DEDENT tokens (see @lexer::members).

@lexer::header {
from antlr4.Token import CommonToken
}

@lexer::members {
def _init_indent_state(self):
    self._pending = []
    self._indents = [0]
    self._depth = 0
    self._last_type = None

def _synth(self, ttype, text, ref):
    tok = CommonToken(self._tokenFactorySourcePair, ttype, 0, ref.start, ref.start - 1)
    tok.line = ref.line
    tok.column = ref.column
    tok.text = text
    return tok

def _indent_width(self, newline_text):
    # tabs advance to the next multiple of 8
    tail = newline_text[max(newline_text.rfind("\n"), newline_text.rfind("\r")) + 1:]
    width = 0
    for ch in tail:
        width = (width // 8 + 1) * 8 if ch == "\t" else width + 1
    return width

def nextToken(self):
    if not hasattr(self, "_pending"):
        self._init_indent_state()
    tok = self._next_raw_token()
    self._last_type = tok.type
    return tok

def _next_raw_token(self):
    if self._pending:
        return self._pending.pop(0)
    tok = super().nextToken()

    if tok.type == Token.EOF:
        if self._last_type == Token.EOF:
            return tok
        if self._last_type not in (None, self.NEWLINE, self.DEDENT):
            self._pending.append(self._synth(self.NEWLINE, "\n", tok))
        while len(self._indents) > 1:
            self._indents.pop()
            self._pending.append(self._synth(self.DEDENT, "<DEDENT>", tok))
        self._pending.append(tok)
        return self._pending.pop(0)

    if tok.type == self.NEWLINE:
        if self._depth > 0:
            return self._next_raw_token()
        width = 0 if self._input.LA(1) == Token.EOF else self._indent_width(tok.text)
        if width > self._indents[-1]:
            self._indents.append(width)
            self._pending.append(self._synth(self.INDENT, "<INDENT>", tok))
        else:
            while width < self._indents[-1]:
                self._indents.pop()
                self._pending.append(self._synth(self.DEDENT, "<DEDENT>", tok))
            if width != self._indents[-1]:
                self.getErrorListenerDispatch().syntaxError(
                    self, None, tok.line, tok.column,
                    "unindent does not match any outer indentation level", None)
                self._indents.append(width)
        return tok

    if tok.text in ("(", "["):
        self._depth += 1
    elif tok.text in (")", "]") and self._depth > 0:
        self._depth -= 1
    return tok
}

program : NEWLINE* statement* EOF ;

statement : simple_statement NEWLINE
          | compound_statement
          ;

simple_statement : assignment
                 | expr
                 ;

assignment : ID ASSIGN_OP expr
           | ID ASSIGN_OP array
           ;

// pemdas
expr : expr ('*' | '/' | '%') expr
     | expr ('+' | '-') expr
     | '-' expr
     | '(' expr ')'
     | atom
     ;

// ID = var name | NUMBER = int or float | STRING = quoted literal text
atom : ID | NUMBER | STRING | BOOL ;

array : '[' (array_item (',' array_item)*)? ']' ;
array_item : expr | array ;

compound_statement : if_statement ;

if_statement : 'if' condition ':' suite
               elif_clause*
               else_clause?
             ;
elif_clause : 'elif' condition ':' suite ;
else_clause : 'else' ':' suite ;

suite : NEWLINE INDENT statement+ DEDENT ;

condition : 'not' condition
          | expr COMPARE_OP expr
          | '(' condition ')'
          | condition 'and' condition
          | condition 'or' condition
          | expr
          ;

COMPARE_OP : '<' | '>' | '<=' | '>=' | '==' | '!=' ;

// arithmetic operators (+ - * / %) are literals in expr above
ASSIGN_OP : '=' | '+=' | '-=' | '*=' | '/=' ;
BOOL   : 'True' | 'False' ;               // must stay above ID so they aren't var names
ID     : [a-zA-Z_][a-zA-Z0-9_]* ;
NUMBER : [0-9]+ ('.' [0-9]+)? ;           // negatives handled by '-' expr
STRING : '"' ~["\r\n]* '"'
       | '\'' ~['\r\n]* '\''              // 'a' and "a" are both valid strings
       ;

// consumes blank lines; trailing whitespace is the next line's indentation
NEWLINE : ( '\r'? '\n' [ \t]* )+ ;
WS      : [ \t]+ -> skip ;

// never matched; only here so the lexer defines these token types
INDENT : {False}? 'indent' ;
DEDENT : {False}? 'dedent' ;
