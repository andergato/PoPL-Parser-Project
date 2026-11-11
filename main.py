import sys
from antlr4 import InputStream, CommonTokenStream
from PythonLexer import PythonLexer
from PythonParser import PythonParser


def main():
    with open(sys.argv[1]) as f:
        text = f.read() + "\n"

    lexer = PythonLexer(InputStream(text))
    parser = PythonParser(CommonTokenStream(lexer))
    tree = parser.program()

    print(tree.toStringTree(recog=parser))


if __name__ == "__main__":
    main()