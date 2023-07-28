import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/calculation.dart';

class Button extends StatefulWidget {
  final String text;
  final bool circular;
  final iconButton;
  const Button(this.text,
      {super.key, this.circular = false, this.iconButton = null});

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CalculationProvider>(builder: (context, calc, child) {
      if (widget.circular) {
        return ElevatedButton(
          style: ButtonStyle(
              elevation: MaterialStateProperty.all<double>(0.0),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black12),
              shape: MaterialStateProperty.all<CircleBorder>(CircleBorder())),
          onPressed: () => calc.addToExp(widget.text),
          child: widget.iconButton ?? Text(widget.text),
        );
      }
      return TextButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ))),
        child: widget.iconButton ?? Text(widget.text),
        onPressed: () => calc.addToExp(widget.text),
      );
    });
  }
}
