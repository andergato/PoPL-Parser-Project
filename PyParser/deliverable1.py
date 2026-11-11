from antlr4 import *
from deliverable1Parser import deliverable1Parser
from deliverable1Lexer import deliverable1Lexer

def main(file_name):
    input_stream = FileStream(file_name, encoding='utf-8')
    lexer = deliverable1Lexer(input_stream)
    stream = CommonTokenStream(lexer)
    parser = deliverable1Parser(stream)
    tree = parser.program()
    print(tree.toStringTree(recog=parser))

if __name__ == "__main__":
    main("graded_test.py")
