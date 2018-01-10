import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants.dart' as constant;

class MyTextFormField extends StatelessWidget {
  MyTextFormField({
    this.key,
    this.controller,
    this.initialValue: '',
    this.focusNode,
    this.decoration: const InputDecoration(),
    this.keyboardType: TextInputType.text,
    this.style,
    this.textAlign: TextAlign.start,
    this.autofocus: false,
    this.obscureText: false,
    this.autocorrect: true,
    this.maxLines: 1,
    this.onSaved,
    this.validator,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final Key key;
  final String initialValue;
  final FocusNode focusNode;
  final InputDecoration decoration;
  final TextInputType keyboardType;
  final TextStyle style;
  final TextAlign textAlign;
  final bool autofocus;
  final bool obscureText;
  final bool autocorrect;
  final int maxLines;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final List<TextInputFormatter> inputFormatters;

  @override
  Widget build(BuildContext context) {
    return new Flexible(
      child: new Padding(
        padding: constant.lateral_margin,
        child: new TextFormField(
          controller: controller,
          key: key,
          initialValue: initialValue,
          focusNode: focusNode,
          decoration: decoration,
          keyboardType: keyboardType,
          style: style,
          textAlign: textAlign,
          autofocus: autofocus,
          obscureText: obscureText,
          autocorrect: autocorrect,
          maxLines: maxLines,
          onSaved: onSaved,
          validator: validator,
          inputFormatters: inputFormatters,
        ),
      ),
    );
  }
}

class UseAsMyField extends StatelessWidget {
  UseAsMyField(this.item);
  final Widget item;

  @override
  Widget build(BuildContext context) {
    return new Flexible(
      child: new Padding(
        padding: constant.lateral_margin,
        child: item,
      ),
    );
  }
}
