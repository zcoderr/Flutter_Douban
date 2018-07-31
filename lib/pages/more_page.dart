import 'package:flutter/material.dart';

class MorePage extends StatefulWidget {
  @override
  State createState() {
    return new _MorePageState();
  }
}

class _MorePageState extends State<MorePage> {
  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[getMorePageTitle()],
    );
  }

  Widget getMorePageTitle() {
    return new Container(
      child: new Text(
        '更多',
        style: new TextStyle(
            color: Colors.black, fontSize: 34.0, fontWeight: FontWeight.bold),
      ),
      padding: new EdgeInsets.only(top: 30.0, left: 15.0, bottom: 20.0),
    );
  }
}
