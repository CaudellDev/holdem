import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Texas Holem',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Game Setup'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController nameText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: MediaQuery.of(context).padding,
        color: Colors.green,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              child: Text("Texas Holdem", style: TextStyle(fontSize: 42)),
            ),
            Column(
              children: <Widget>[
                Text("Name:"),
                TextField(
                  controller: nameText,
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Text("Games started:"),
                Text("There are no games.")
              ],
            ),
            Row(
              children: <Widget>[
                RaisedButton(
                  child: Text("New Game"),
                  onPressed: null,
                ),
                RaisedButton(
                  child: Text("Load Game"),
                  onPressed: null,
                ),
              ],
            )
          ],
        ),
      )
    );
  }
}
