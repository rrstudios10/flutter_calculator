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
                self.numStack.append(num)
                sawDecimal = False
            elif c == '(':
                self.operatorStack.append(c)
            elif c == ')':
                while self.operatorStack[-1] != '(':
                    ans = self._calculate()
                    self.numStack.append(ans)
                self.operatorStack.pop()

                if len(self.operatorStack) > 0 and self.operatorStack[-1] == isSci:
                    ans = self._calculate()
                    self.numStack.append(ans)
                    isSci = None
            elif self._isOperator(c):
                # if c == '-' and (sawOperator or len(self.numStack) == 0):  # or len(self.operatorStack) == 0):
                #     negateNext = True
                # else:
                sawOperator = True
                if c == '-':
                    if len(self.operatorStack) == 0 or self.operatorStack[-1] == '*_':
                        while len(self.operatorStack) > 0 and self._precedence('+') <= self._precedence(
                                self.operatorStack[-1]):
                            ans = self._calculate()
                            self.numStack.append(ans)
                        self.operatorStack.append('+')
                    # self.operatorStack.append('*_')
                    self.numStack.append(-1)
                    while len(self.operatorStack) > 0 and self._precedence('*_') <= self._precedence(
                            self.operatorStack[-1]):
                        ans = self._calculate()
                        self.numStack.append(ans)
                    self.operatorStack.append('*_')
                else:
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

    def isScientific(self, i: int):
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

    def isScentific(self, s: str):
        return s == "sin" or s == "cos" or s == "tan" or s == "log" or s == "ln"

    def _precedence(self, op):
        if (op == '+') or (op == '-'):
            return 1
        elif (op == '*') or (op == '/'):
            return 2
        elif op == '^':
            return 3
        elif op == '*_':
            return 4
        return -1

    def _calculate(self):
        operator = self.operatorStack.pop()
        if self.isScentific(operator):
            return self._calculateSci(operator)
        else:
            a = self.numStack.pop()
            # print(a)
            if len(self.numStack) == 0:
                return a
            b = self.numStack.pop()
            # print(b)
            if operator == '+':
                return a + b
            elif operator == '-':
                return b - a  # not a - b
            elif operator == '^':
                return int(b ** a)
            elif operator == '*' or operator == '*_':
                return a * b
            elif operator == '/':
                if a == 0:
                    raise Exception("Cannot divide by zero")
                return b / float(a)
            return 0

    def _calculateSci(self, isSci):
        x = self.numStack.pop()
        ans = 0
        match isSci:
            case "sin":
                ans = math.sin(x)
            case "cos":
                ans = math.cos(x)
            case "tan":
                ans = math.tan(x)
            case "log":
                ans = math.log10(x)
            case "ln":
                ans = math.log(x)
        return ans
