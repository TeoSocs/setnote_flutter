import 'package:flutter/material.dart';

import 'constants.dart' as constant;
import 'drawer.dart';

class MatchPage extends StatelessWidget {
  MatchPage({this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text(constant.app_name + " - " + title)),
        drawer: new Drawer(
          child: new MyDrawer(),
        ),
        body: new Center(
            child: new ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420.0),
          child: new Column(
            children: <Widget>[
              new Expanded(
                child: new Form(
                    child: new ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        children: <Widget>[

                          new Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Expanded(
                                child: new TextFormField(

                                  decoration: const InputDecoration(
                                    hintText: 'Squadra A',
                                    labelText: 'Squadra A *',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              new Expanded(
                                child: new TextFormField(
                                  decoration: const InputDecoration(
                                    hintText: 'Squadra B',
                                    labelText: 'Squadra B *',
                                  ),

                                ),
                              ),
                            ],
                          ),

                          new Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Expanded(
                                child: new TextFormField(

                                  decoration: const InputDecoration(
                                    hintText: 'How do you log in?',
                                    labelText: 'New Password *',
                                  ),
                                ),
                              ),
                              new Expanded(
                                child: new TextFormField(

                                  decoration: const InputDecoration(
                                    hintText: 'How do you log in?',
                                    labelText: 'New Password *',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              new Expanded(
                                child: new TextFormField(
                                  decoration: const InputDecoration(
                                    hintText: 'How do you log in?',
                                    labelText: 'Re-type Password *',
                                  ),

                                ),
                              ),
                            ],
                          ),
                          new Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Expanded(
                                child: new TextFormField(

                                  decoration: const InputDecoration(
                                    hintText: 'How do you log in?',
                                    labelText: 'New Password *',
                                  ),
                                ),
                              ),
                              new Expanded(
                                child: new TextFormField(

                                  decoration: const InputDecoration(
                                    hintText: 'How do you log in?',
                                    labelText: 'New Password *',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              new Expanded(
                                child: new TextFormField(
                                  decoration: const InputDecoration(
                                    hintText: 'How do you log in?',
                                    labelText: 'Re-type Password *',
                                  ),

                                ),
                              ),
                            ],
                          ),


                          new MyButton(label: constant.formations_label, address: "/formations")
                        ]

                    )),
              ),



            ],
          ),
        )));
  }
}

class MyButton extends StatelessWidget {
  MyButton({this.label, this.address});
  final String label;
  final String address;

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: new EdgeInsets.all(10.0),
      child: new RaisedButton(
        child: new Padding(
            padding: new EdgeInsets.all(10.0), child: new Text(label)),
        onPressed: () => Navigator.of(context).pushNamed(address),
      ),
    );
  }
}
