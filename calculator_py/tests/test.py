import unittest

from Calculator.src.calculator.main import *


class MyTestCase(unittest.TestCase):
    def test_evaluate(self):
        expression = "1+2"

        evaluator = Evaluator(expression)
        ans = evaluator.evaluate()
        self.assertEqual(ans, 3)  # add assertion here


if __name__ == '__main__':
    unittest.main()
