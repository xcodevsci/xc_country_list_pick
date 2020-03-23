import 'package:flutter/material.dart';
import 'package:xc_country_list_pick/xc_country_list_pick.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example xc cupertino country list pick',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  String _paysSelected = "";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 5.0),
              child: Text("$_paysSelected"),
            ),
            MaterialButton(
              onPressed: (){
                XCupertinoCountryListPick.show(context,
                    isShowTitle: true,
                    initialSelection: '+225',
                    fontFamily: 'Mali',
                    textColor: Colors.white,
                    //textSize: 25.0,
                    background: Colors.teal,//Colors.red[300],
                    borderRadius: 16,
                    onChanged: (value) async{
                      print(value.code);
                      _paysSelected = value.name;
                      setState((){});
                    }
                );
              },
              child: Text("Country list"),
              color: Colors.blue,
            )

          ],
        ),
      ),
    );
  }
}
