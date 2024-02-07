import math


class Evaluator:
    expr = ""
    numStack = []
    operatorStack = []

    def __init__(self, expr):
        self.expr = expr

    def evaluate(self):
        sawDecimal = False
        sawOperator = False
        negateNext = False
        i = 0
        isSci = None
        while i < len(self.expr):
            c = self.expr[i]
            if c.isdigit():
                sawOperator = False
                num = 0.0
                j = 1
                while i < len(self.expr) and (self.expr[i].isdigit() or self.expr[i] == '.'):
                    if self.expr[i] == '.':
                        sawDecimal = True
                    else:
                        if sawDecimal:
                            num += int(self.expr[i]) * pow(0.1, j)
                            j += 1
                        else:
                            num = num * 10.0 + int(self.expr[i])  # (expr[i] - '0')
                    i += 1
                i -= 1
                self.numStack.append(num * (-1 if negateNext else 1))
                sawDecimal = False
            elif c == '(':
                # TODO: Add negateNext logic here
                self.operatorStack.append(c)
            elif c == ')':
                while self.operatorStack[-1] != '(':
                    ans = self._calculate()
                    self.numStack.append(ans)
                self.operatorStack.pop()

                if len(self.operatorStack) > 0 and self.operatorStack[-1] == isSci:
                    self._calculateSci(isSci)
                    isSci = None
            elif self._isOperator(c):
                if c == '-' and (sawOperator or len(self.operatorStack) == 0):
                    negateNext = True
                else:
                    negateNext = False
                    sawOperator = True
                    while len(self.operatorStack) > 0 and self._precedence(c) <= self._precedence(
                            self.operatorStack[-1]):
                        ans = self._calculate()
                        self.numStack.append(ans)
                    self.operatorStack.append(c)
            else:
                isSci = self.isScientific(i)
                if isSci is not None:
                    i += len(isSci)
                    self.operatorStack.append(isSci)
                    i -= 1
            i += 1
        while len(self.operatorStack) > 0:  # .isEmpty():
            ans = self._calculate()
            self.numStack.append(ans)
        return self.numStack.pop()

    def _isOperator(self, c):
        return c == '+' or c == '-' or c == '/' or c == '*' or c == '^'

    def isScientific(self, i):
        if self.expr[i: i + 3] == "sin":
            return "sin"
        elif self.expr[i: i + 3] == "cos":
            return "cos"
        elif self.expr[i: i + 3] == "tan":
            return "tan"
        elif self.expr[i: i + 3] == "log":
            return "log"
        elif self.expr[i: i + 2] == "ln":
            return "ln"
        return None

    def _precedence(self, op):
        if (op == '+') or (op == '-'):
            return 1
        elif (op == '*') or (op == '/'):
            return 2
        elif op == '^':
            return 3
        return -1

    def _calculate(self):
        a = self.numStack.pop()
        b = self.numStack.pop()
        operator = self.operatorStack.pop()
        if operator == '+':
            return a + b
        elif operator == '-':
            return b - a  # not a - b since evaluation is done from left to
        elif operator == '^':
            return int(b ** a)
        if operator == '*':
            return a * b
        elif operator == '/':
            if a == 0:
                raise Exception("Cannot divide by zero")
            return b / float(a)
        return 0

    def _calculateSci(self, isSci):
        x = self.numStack.pop()
        self.operatorStack.pop()
        match isSci:
            case "sin":
                self.numStack.append(math.sin(x))
            case "cos":
                self.numStack.append(math.cos(x))
            case "tan":
                self.numStack.append(math.tan(x))
            case "log":
                self.numStack.append(math.log10(x))
            case "ln":
                self.numStack.append(math.log(x))
