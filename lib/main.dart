import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

class TablesList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('tables').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');

        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return Text('Loading...');
          case ConnectionState.none: return Text('There are no tables available. Create game to play.');
          default:
            return ListView(
              shrinkWrap: true,
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return ListTile(
                  title: Text(document['desc']),
                  subtitle: Text(document['curr_turn'].toString()),
                );
              }).toList(),
            );
        }
      },
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

  bool showSignIn = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'profile',
      'email',
    ]
  );

  TextEditingController nameText = TextEditingController();

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.accessToken,
        accessToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await _auth.signInWithCredential(credential));
    print("Signed in: " + user.displayName);
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: MediaQuery.of(context).padding,
        color: Colors.green,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Card(
              elevation: 8.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(color: Colors.white),
                    child: Text("Texas Holdem", style: TextStyle(fontSize: 42))
                ),
              ),
            ),
            Visibility(
              visible: showSignIn,
              child: Center(
                child: Container(
                  child: RaisedButton(
                    color: Colors.white,
                    onPressed: (){
                      _handleSignIn().whenComplete((){
                        setState(() {
                          showSignIn = false;
                        });
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Image.asset(
                            'images/google_logo.png',
                            height: 40.0,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text(
                              "Sign in with Google",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              )
                            )
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: !showSignIn,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Text("Nickname:", style: TextStyle(fontSize: 24),),
                          TextField(
                            style: TextStyle(fontSize: 24,),
                            controller: nameText,
                            decoration: null,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Text("Games started:"),
                            TablesList(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          color: Colors.white,
                          disabledColor: Colors.white70,
                          child: Text("Start Game"),
                          onPressed: (){},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          color: Colors.white,
                          disabledColor: Colors.white70,
                          child: Text("Load Game"),
                          onPressed: (){},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}
