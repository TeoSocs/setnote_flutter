import 'package:flutter/material.dart';

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
        child: new Padding(
            padding: constant.standard_margin, child: new Text(label)),
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
                  child: new Padding(
                    padding: constant.standard_margin,
                    child: child,
                  ),
                ),
              ],
            ),
          );
        } else {
          return new Scaffold(
            appBar:
            new AppBar(title: new Text(title)),
            drawer: new Drawer(
              child: new MyDrawer(),
            ),
            body: new Padding(
              padding: constant.standard_margin,
              child: child,
            ),
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
              child: new Padding(
                padding: constant.form_page_margin,
                child: largeScreen,
              ),
            ),
          );
        } else {
          return new Scaffold(
            appBar: new AppBar(
              title: new Text(title),
            ),
            body: new Center(
              child: new Padding(
                padding: constant.standard_margin,
                child: smallScreen,
              ),
            ),
          );
        }
      },
    );
  }
}