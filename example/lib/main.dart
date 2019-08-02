
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:soe/soe.dart';

void main() => runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Create a client transformer
  List<StreamSubscription<dynamic>> _streamSubscriptions =
  <StreamSubscription<dynamic>>[];
  @override
  void initState() {
    super.initState();

    _streamSubscriptions.add(gyroscopeEvents.listen((String result) {
      print(result);
    }));

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Column(children: <Widget>[
          FlatButton(onPressed: (){
            startListening('how are you','your appid','your secretId','your secretKey');
          },child: Text('开始录音'),),
          FlatButton(onPressed: (){
            stopListening();
          },child: Text('停止录音'),),
          FlatButton(onPressed: (){

          },child: Text('录音测评'),),
        ],),
      ),

    );
  }

}
