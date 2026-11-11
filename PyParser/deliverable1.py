from antlr4 import *
from deliverable1Parser import deliverable1Parser
from deliverable1Lexer import deliverable1Lexer

input_stream = FileStream("project_deliverable_1.py", encoding='utf-8')
lexer = deliverable1Lexer(input_stream)
stream = CommonTokenStream(lexer)
parser = deliverable1Parser(stream)
tree = parser.start()
print(tree.toStringTree(recog=parser))
