import 'package:flutter/material.dart';

class CalculationProvider with ChangeNotifier {
  String exp = "";
  List operatorStack = [];
  List operandStack = [];
  Map<String, String> history = {};
  bool decimalInput = true;
  List<String> operators = ['x', '-', '+', '/', '%'];

  get getHistory => history;
  get lastCharacterOfExpression => exp.isNotEmpty ? exp[exp.length - 1] : '';

  clearHistory() {
    history.clear();
    notifyListeners();
  }

  get getExpression => exp;

  bool isOperator(value) {
    return operators.contains(value);
  }

  condenseExp() {
    while (operatorStack.isNotEmpty) {
      //Get operands and operator and evaluate
      String operator = operatorStack.removeLast();
      var rightOperand = operandStack.removeLast();
      var leftOperand = operandStack.removeLast();
      if (int.tryParse(rightOperand) != null) {
        rightOperand = int.parse(rightOperand);
      } else if (double.tryParse(rightOperand) != null) {
        rightOperand = double.parse(rightOperand);
      }
      if (int.tryParse(leftOperand) != null) {
        leftOperand = int.parse(leftOperand);
      } else if (double.tryParse(leftOperand) != null) {
        leftOperand = double.parse(leftOperand);
      }

      var res;
      if (operator == '+') {
        res = leftOperand + rightOperand;
      } else if (operator == '-') {
        res = leftOperand - rightOperand;
      } else if (operator == 'x') {
        res = leftOperand * rightOperand;
      } else if (operator == '/') {
        res = leftOperand / rightOperand;
      } else if (operator == '%') {
        res = leftOperand % rightOperand;
      }
      if (res != null) {
        if (rightOperand.runtimeType == int && leftOperand.runtimeType == int) {
          if (res.toString().contains('.')) {
            RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
            res = res.toString().replaceAll(regex, '');
          }
        }
        operandStack.add(res.toString());
        history[exp] = res.toString();
      }
    }
  }

  evalExp() {
    RegExp r =
        RegExp(r'[0-9]*(\.[0-9]+)?'); //RegExp for regular and decimal numbers

    //Fill in the stacks
    int i = 0;
    while (i < exp.length) {
      //Get the first match of the regexp in the substring starting at index i
      String numMatch =
          r.allMatches(exp, i).map((z) => z.group(0)).toList()[0].toString();
      //Check if it is an operand
      if (numMatch.isNotEmpty && exp[i] == numMatch[0]) {
        operandStack.add(numMatch);
        i += numMatch
            .length; // Move 'i' to next operator index or the end of expression
      } else if (isOperator(exp[i])) {
        if (exp[i] == '-') {
          String numMatch = r
              .allMatches(exp, i + 1)
              .map((z) => z.group(0))
              .toList()[0]
              .toString();

          // Add the negative number to the stack
          if (!((operandStack
                  .isEmpty) || // If it the beginning of the expression
              (operatorStack
                      .isNotEmpty && // If the last character in the expression is an operator
                  isOperator(exp[i - 1])))) {
            if (operatorStack.isNotEmpty && operatorStack.last != '+') {
              condenseExp();
            }
            operatorStack.add('+');
          }
          operandStack.add((exp[i] + numMatch).toString());
          i++; // Move 'i' to next operand or the end of expression
          i += numMatch
              .length; // Move 'i' to next operator index or the end of expression
        } else {
          if (exp[i] == '+' &&
              (operatorStack.isNotEmpty && operatorStack.last != '+')) {
            condenseExp();
          }
          operatorStack.add(exp[i]);
          i++; // Move 'i' to next operand or the end of expression
        }
      }
    }
    condenseExp();
    exp = (operandStack.removeLast()).toString();
    notifyListeners();
  }

  addToExp(value) {
    if (value == 'AC') {
      exp = "";
      operandStack.clear();
      operatorStack.clear();
      decimalInput = true;
    } else if (value == '<-' && exp != "") {
      if (lastCharacterOfExpression == '.') {
        decimalInput = true;
      }
      exp = exp.substring(0, exp.length - 1);
    } else if (int.tryParse(value) != null) {
      exp += value;
    } else if (isOperator(value)) {
      if (value == '-') {
        if (lastCharacterOfExpression != '.' &&
            lastCharacterOfExpression != '-') {
          exp += value;
          decimalInput = true;
        }
      } else if (exp.isNotEmpty) {
        // Replace operator if the expression ends with operator
        if (exp.length != 1 && isOperator(lastCharacterOfExpression)) {
          exp = exp.substring(0, exp.length - 1) + value;
          decimalInput = true;
        }
        //Else add the operator to the expression
        else if (lastCharacterOfExpression != '-' &&
            lastCharacterOfExpression != '.') {
          exp += value;
          decimalInput = true;
        }
      }
    } else if (value == '.') {
      if (decimalInput) {
        if (lastCharacterOfExpression != '.') {
          exp += value;
          decimalInput = false;
        }
      }
    } else if (value == '=') {
      if (!((lastCharacterOfExpression == '.') ||
          isOperator(lastCharacterOfExpression))) {
        decimalInput = true;
        evalExp();
      }
    }
    notifyListeners();
  }
}
