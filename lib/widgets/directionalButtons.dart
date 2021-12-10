import 'package:flutter/material.dart';

class DirectionalButton extends StatelessWidget {
  const DirectionalButton({
    required this.color,
    required this.buttonTitle,
    required this.onPress,
  });

  final Color color;
  final String buttonTitle;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPress,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            buttonTitle,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
