from antlr4 import *
from deliverable2Parser import deliverable2Parser
from deliverable2Lexer import deliverable2Lexer

def main(file_name):
    input_stream = FileStream(file_name, encoding='utf-8')
    lexer = deliverable2Lexer(input_stream)
    stream = CommonTokenStream(lexer)
    parser = deliverable2Parser(stream)
    tree = parser.program()
    print(tree.toStringTree(recog=parser))

if __name__ == "__main__":
    main("project_deliverable_2.py")
