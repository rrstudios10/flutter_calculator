from Calculator.src.calculator.evaluator import *

expression = "-2 * -(-6 * -3 + (-2-(-6)))"

evaluator = Evaluator(expression)
ans = evaluator.evaluate()
print(ans)
