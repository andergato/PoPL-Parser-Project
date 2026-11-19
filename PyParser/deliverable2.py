import os
import sys

from antlr4 import *
from deliverable2Parser import deliverable2Parser
from deliverable2Lexer import deliverable2Lexer

HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_INPUT = os.path.join(HERE, "project_deliverable_2.py")


def parse(file_name):
    input_stream = FileStream(file_name, encoding="utf-8")
    lexer = deliverable2Lexer(input_stream)
    parser = deliverable2Parser(CommonTokenStream(lexer))
    tree = parser.program()
    return tree, parser, parser.getNumberOfSyntaxErrors()


def pretty(tree, parser, depth=0):
    pad = "  " * depth
    if isinstance(tree, TerminalNode):
        text = tree.getText().replace("\r", "").replace("\n", "\\n")
        return pad + "'" + text + "'" if text else pad + "<EOF>"
    name = parser.ruleNames[tree.getRuleIndex()]
    lines = [pad + name]
    lines.extend(pretty(child, parser, depth + 1) for child in tree.getChildren())
    return "\n".join(lines)


def main(file_name=DEFAULT_INPUT, as_tree=False):
    tree, parser, errors = parse(file_name)
    if as_tree:
        print(pretty(tree, parser))
    else:
        print(tree.toStringTree(recog=parser))
    return 1 if errors else 0


if __name__ == "__main__":
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    sys.exit(main(args[0] if args else DEFAULT_INPUT, "--tree" in sys.argv))
