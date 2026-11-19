import contextlib
import io
import os
import sys
import tempfile
import unittest

from deliverable2 import parse, DEFAULT_INPUT


def run(source):
    with tempfile.NamedTemporaryFile("w", suffix=".py", delete=False, encoding="utf-8", newline="") as f:
        f.write(source)
    try:
        with contextlib.redirect_stderr(io.StringIO()):
            tree, parser, errors = parse(f.name)
        return tree.toStringTree(recog=parser), errors
    finally:
        os.unlink(f.name)


class Deliverable2Tests(unittest.TestCase):
    def ok(self, source):
        tree, errors = run(source)
        self.assertEqual(errors, 0, tree)
        return tree

    def bad(self, source):
        _, errors = run(source)
        self.assertGreater(errors, 0, "expected a syntax error for %r" % source)

    def test_project_file_parses(self):
        with open(DEFAULT_INPUT, encoding="utf-8") as f:
            tree, errors = run(f.read())
        self.assertEqual(errors, 0, tree)

    def test_deliverable1_features(self):
        self.ok('x = 1 + 2 * 3 % 4 - 5 / 6\nx += 1\nx -= 1\nx *= 2\nx /= 2\n'
                'a = [1, 2.5]\nb = ["s", \'t\']\nc = [[1, 2], [3]]\nd = []\ne = -x\nf = (x + 1) * 2\n')

    def test_if_elif_else(self):
        self.ok("if a < b:\n    x = 1\nelif a == b:\n    x = 2\nelse:\n    x = 3\n")

    def test_all_comparisons_and_logic(self):
        for op in ("<", "<=", ">", ">=", "==", "!="):
            self.ok("if a %s b:\n    x = 1\n" % op)
        self.ok("if a < b and c > d or not e:\n    x = 1\n")
        self.ok("if (not flag) and (a < 1 or b > 2):\n    x = 1\n")
        self.ok("if flag:\n    x = 1\n")
        self.ok("if a + 1 < b * 2:\n    x = 1\n")

    def test_else_body_is_inside_else(self):
        tree = self.ok("if a:\n\tx = 1\nelse:\n\tdata = -1")
        self.assertEqual(tree.count("(suite"), 2)
        self.assertEqual(tree.count("(statement (simple_statement"), 2)

    def test_dedent_ends_block_without_blank_line(self):
        tree = self.ok("if a:\n    x = 1\ny = 2\n")
        self.assertEqual(tree.count("(suite"), 1)
        self.assertLess(tree.index("<DEDENT>"), tree.index("y"))

    def test_multi_statement_body_and_blank_lines(self):
        self.ok("if a:\n    x = 1\n\n    y = 2\n\n\nz = 3\n")

    def test_nested_blocks(self):
        tree = self.ok("if a:\n    if b:\n        x = 1\n    else:\n        x = 2\n    y = 3\nelse:\n    z = 4\n")
        self.assertEqual(tree.count("(if_statement"), 2)
        self.assertEqual(tree.count("<DEDENT>"), 4)

    def test_dedent_multiple_levels_at_eof(self):
        self.ok("if a:\n    if b:\n        if c:\n            x = 1")

    def test_crlf_trailing_newline_and_leading_blank_lines(self):
        self.ok("\r\n\r\nif a:\r\n    x = 1\r\nelse:\r\n    x = 2\r\n")
        self.ok("x = 1")
        self.ok("")

    def test_multiline_array(self):
        self.ok("a = [1,\n     2,\n     3]\n")

    def test_errors_are_reported(self):
        self.bad("if a:\nx = 1\n")  # missing indent
        self.bad("if a:\n        x = 1\n    y = 2\n")  # inconsistent dedent
        self.bad("else:\n    x = 1\n")  # else without if
        self.bad("if a < :\n    x = 1\n")  # incomplete condition
        self.bad("if a\n    x = 1\n")  # missing colon
        self.bad("x = [1, 2,]\n")  # trailing comma


if __name__ == "__main__":
    unittest.main()
