import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants.dart' as constant;
import 'drawer.dart';

class SetnoteButton extends StatelessWidget {
  SetnoteButton({this.label, this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: constant.standard_margin,
      child: new RaisedButton(
        child: new Text(label),
        onPressed: onPressed,
      ),
    );
  }
}

class SetnoteBaseLayout extends StatelessWidget {
  SetnoteBaseLayout({this.child, this.title});
  final Widget child;
  final String title;

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        MediaQueryData media = MediaQuery.of(context);
        if (media.orientation == Orientation.landscape &&
            media.size.width >= 950.00) {
          return new Scaffold(
            appBar: new AppBar(
              title: new Text(title),
            ),
            body: new Row(
              children: <Widget>[
                new Drawer(
                  child: new MyDrawer(),
                ),
                new Expanded(
                  child: child,
                ),
              ],
            ),
          );
        } else {
          return new Scaffold(
            appBar: new AppBar(title: new Text(title)),
            drawer: new Drawer(
              child: new MyDrawer(),
            ),
            body: child,
          );
        }
      },
    );
  }
}

class LoadingWidget extends StatelessWidget {
  LoadingWidget({this.condition, this.child});
  final bool condition;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (condition) {
      return child;
    } else {
      return new Center(child: new CircularProgressIndicator());
    }
  }
}

class SetnoteFormLayout extends StatelessWidget {
  SetnoteFormLayout({this.smallScreen, this.largeScreen, this.title});

  final Widget smallScreen;
  final Widget largeScreen;
  final String title;

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        MediaQueryData media = MediaQuery.of(context);
        if (media.orientation == Orientation.landscape &&
            media.size.width >= 950.00) {
          return new Scaffold(
            appBar: new AppBar(
              title: new Text(title),
            ),
            body: new Center(
              child: largeScreen,
            ),
          );
        } else {
          return new Scaffold(
            appBar: new AppBar(
              title: new Text(title),
            ),
            body: new Center(
              child:smallScreen,
            ),
          );
        }
      },
    );
  }
}

class MyTabletTextFormField extends StatelessWidget {
  MyTabletTextFormField({
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

class MyPhoneTextFormField extends StatelessWidget {
  MyPhoneTextFormField({
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
    return new Padding(
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

class SetnoteColorSelector extends StatefulWidget {
  SetnoteColorSelector({this.red: 33.0, this.green: 77.0, this.blue: 130.0});
  final double red, green, blue;

  @override
  SetnoteColorSelectorState createState() =>
      new SetnoteColorSelectorState(red: red, green: green, blue: blue);
}

class SetnoteColorSelectorState extends State<SetnoteColorSelector> {
  SetnoteColorSelectorState({this.red, this.green, this.blue});

  double red, green, blue;

  @override
  Widget build(BuildContext context) {
    BoxDecoration box = new BoxDecoration(
      color: new Color.fromARGB(255, red.round(), green.round(), blue.round()),
    );

    return new AlertDialog(
        contentPadding: new EdgeInsets.all(0.0),
        content: new IntrinsicWidth(
          child: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                new ClipRect(
                    child: new Container(
                        width: 50.0, height: 180.0, decoration: box)),
                new Padding(
                    padding: new EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0)),
                new Slider(
                    value: red,
                    min: 0.0,
                    max: 255.0,
                    activeColor: Colors.red[400],
                    onChanged: (double value) {
                      setState(() {
                        red = value;
                      });
                    }),
                new Padding(
                    padding: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0)),
                new Slider(
                    value: green,
                    min: 0.0,
                    max: 255.0,
                    activeColor: Colors.green[400],
                    onChanged: (double value) {
                      setState(() {
                        green = value;
                      });
                    }),
                new Padding(
                    padding: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0)),
                new Slider(
                    value: blue,
                    min: 0.0,
                    max: 255.0,
                    activeColor: Colors.blue[400],
                    onChanged: (double value) {
                      setState(() {
                        blue = value;
                      });
                    }),
              ]),
        ),
        actions: <Widget>[
          new FlatButton(
              onPressed: () {
                Color c = new Color.fromARGB(
                    255, red.round(), green.round(), blue.round());
                Navigator.pop(context, c);
              },
              child: new Text('Select'))
        ]);
  }
}

class SetnoteColorSelectorButton extends StatefulWidget {
  SetnoteColorSelectorButton({this.label});
  final String label;

  @override
  SetnoteColorSelectorButtonState createState() =>
      new SetnoteColorSelectorButtonState(label: label);
}

class SetnoteColorSelectorButtonState
    extends State<SetnoteColorSelectorButton> {
  SetnoteColorSelectorButtonState({this.label});
  String label;
  SetnoteColorSelector selector = new SetnoteColorSelector();
  Color _buttonColor;
  bool _whiteText = false;

  @override
  Widget build(BuildContext context) {
    if (_buttonColor == null) {
      _buttonColor = Theme.of(context).buttonColor;
    }
    return new RaisedButton(
      color: _buttonColor,
      child: new Text(
        label,
        style: new TextStyle(color: (_whiteText ? Colors.white : Colors.black)),
      ),
      onPressed: () {
        showDialog<Color>(
          context: context,
          child: selector,
        )
            .then((Color newColor) => setState(() {
                  _buttonColor = newColor;
                  if (newColor.computeLuminance() > 0.179) {
                    _whiteText = false;
                  } else {
                    _whiteText = true;
                  }
                }));
      },
    );
  }
}
