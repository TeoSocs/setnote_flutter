import 'package:flutter/material.dart';

import 'constants.dart' as constant;

class SetnoteButton extends StatelessWidget {
  SetnoteButton({this.label, this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: constant.standard_margin,
      child: new RaisedButton(
        child: new Padding(
            padding: constant.standard_margin, child: new Text(label)),
        onPressed: onPressed,
      ),
    );
  }
}
