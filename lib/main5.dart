import 'dart:async';

import 'package:flutter/material.dart';

import 'palette.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _infoToShow = '0';

  @override
  void initState() {
    super.initState();
    getImageAndPalette();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> getImageAndPalette() async {
    Palette palette = await PaletteLib.getPaletteWithUrl(
        "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1532944374251&di=7f2b787ae06df1c8668567a144e635b7&imgtype=0&src=http%3A%2F%2Ff.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F63d0f703918fa0ece5f167da2a9759ee3d6ddb37.jpg");
    print(palette.darkVibrant.color.toString());

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _infoToShow = palette.vibrant.color.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Palette Plugin example app'),
        ),
        body: new Center(
          child: new Text(
            'Palette: $_infoToShow\n',
            style: new TextStyle(
                color: new Color(int.parse(
                    _infoToShow.split('(0x')[1].split(')')[0],
                    radix: 16))),
          ),
        ),
      ),
    );
  }
}
