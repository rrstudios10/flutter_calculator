# flutter_calculator
A simple calculator app inspired from OnePlus calculator app made using flutter
Calculator Light Theme | Calculator Dark Theme | History Light Theme | History Dark Theme
:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|
![Screenshot_1690556982](https://github.com/rrstudios10/flutter_calculator/assets/70618833/f2d60b95-b12e-4fa5-b86e-74fbb20c0461) | ![Screenshot_1690556792](https://github.com/rrstudios10/flutter_calculator/assets/70618833/1d85ca69-04ca-4675-8899-f8dc3880ae2c)| ![Screenshot_1690557218](https://github.com/rrstudios10/flutter_calculator/assets/70618833/577c835a-0338-4539-9c4a-a8f0c2926097) | ![Screenshot_1690557244](https://github.com/rrstudios10/flutter_calculator/assets/70618833/4de7ad4a-b4a3-4ff2-951d-be0ddbcbc63b)



## UI/UX

1. Calculator
    1. Numbers
    2. Backspace
    3. All Clear
    4. Operations
        1. Addition
        2. Subtraction
        3. Multiplication
        4. Division
        5. Evaluate
    5. Decimal
    6. Modulo
2. Support for dark theme
3. Supports dynamic colors for Android 13 and higher
4. History of calculations


## Logic

### Input Behavior

1. First character 
    1. Operators aren’t allowed except ‘-’(for unary minus)
2. Number
    1. A number can be input anywhere
3. Decimal
    1. ‘.’ cannot be followed by a ‘.’ or an operator (Example: .+)
    2. A number cannot have multiple ‘.’s
4. Two operators cannot be input one after the other
    1. When the user does this, the operator is replaced with the second one
        1. Exception: The user cannot do this if ‘-’ is the first character of the expression
    2. Exception: Operators other than ‘-’ can have ‘-’ next to it. 
5. Equals to
    1. Evaluates expression
    2. Does nothing when the expression ends with
        1. Operators
        2. ‘.’
        3. If there are no operators to evaluate
6. Backspace
    1. Removes a character in the expression
    2. Does nothing if there's no expression
7. All Clear
    1. Clears the expression

### Evaluation Behavior

1. The expression is parsed character by character
2. Regular Expression for regular and decimal numbers → r'[0-9]*(\.[0-9]+)?’
3. Get the first match of the regular expression in the substring starting at index i
4. If the expression character is 
    1. The first character in the match
        1. Add the match to the operandStack and move the index by the length of the match
    2. An operator
        1. Is ‘-’
            1. Get the first match of the regular expression in the substring starting at index i+1
            2. If it is not the beginning of the expression and the last character of the expression is not an operator
                1. If the top of the operatorStack has an operator of higher precedence condense the expression
                2. Add ‘+’ to the operatorStack
            3. Add the unary ‘-’ number to operandStack
            4. Move the index by the length of the match+1
        2. Else
            1. Is ‘+’
                1. If the top of the operatorStack has an operator of higher precedence condense the expression
            2. Add the operator to operatorStack
            3. Move the index by 1
5. After the completion of parsing, condense the expression and pop the operandStack and set it to expression

### Condense

1. Loop until operatorStack is not empty
    1. Pop the operatorStack and get the operator
    2. Pop the operandStack and get the right operand
    3. Pop the operandStack and get the left operand
    4. Try parsing the right and left operands and assign as integer or double accordingly
    5. Perform the operation
    6. If left and right operands are integers and the result contains ‘.’, remove all trailing zeroes (Regular Expression to remove the trailing zeroes → r'([.]*0)(?!.*\d)')
    7. Add the result to operandStack as a String
