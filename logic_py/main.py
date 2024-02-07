from CalculatorLogicPy.src.calculator.evaluator import *

expression = "1 + 2 * 3 / 4 + sin(1) + cos(1)"

evaluator = Evaluator(expression)
ans = evaluator.evaluate()
print(ans)
