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
      children: <Widget>[
        getMorePageTitle(),
        getHeaderSection(),
        getButtonSection(),
        //getAboutSection(),
      ],
    );
  }

  Widget getHeaderSection() {
    return new Container(
      padding:
          new EdgeInsets.only(top: 25.0, bottom: 25.0, left: 15.0, right: 15.0),
      child: new Stack(
        children: <Widget>[
          new Container(
            height: 60.0,
            alignment: new FractionalOffset(0.0, 0.5),
            child: new Text(
              'Flutter-豆瓣电影',
              style: new TextStyle(
                fontSize: 24.0,
                color: Colors.black,
              ),
            ),
          ),
          new Align(
            alignment: new FractionalOffset(1.0, 0.0),
            child: new Container(
              width: 60.0,
              height: 60.0,
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage('images/flutter_logo.png'),
                  fit: BoxFit.cover,
                ),
                color: Colors.green.shade100,
                borderRadius: new BorderRadius.all(new Radius.circular(30.0)),
                border: new Border.all(
                  color: Colors.grey.shade200,
                  width: 0.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getAboutSection() {
    return new Padding(
      padding: new EdgeInsets.only(left: 15.0, right: 15.0),
      child: new Container(
        padding: new EdgeInsets.only(
            left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
        margin: new EdgeInsets.only(top: 5.0),
        decoration: new BoxDecoration(color: Colors.grey.shade100),
        child: new Stack(
          children: <Widget>[
            Image.asset(
              'images/icon_explore_normal.png',
              width: 20.0,
              height: 20.0,
            ),
            new Container(
              margin: new EdgeInsets.only(left: 40.0),
              child: new Text('关 于'),
            ),
            new Container(
              alignment: new Alignment(1.0, 0.0),
              child: Image.asset(
                'images/icon_explore_normal.png',
                width: 20.0,
                height: 20.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getButtonSection() {
    return new Container(
        height: 120.0,
        padding: new EdgeInsets.only(
            left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
        color: Colors.grey.shade100,
        child: new Container(
          child: new Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              new Flexible(
                flex: 1,
                child: new Container(
                  constraints: new BoxConstraints.expand(),
                  margin: new EdgeInsets.only(left: 5.0, right: 5.0),
                  color: Colors.white,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'images/icon_github.png',
                        width: 50.0,
                        height: 50.0,
                      ),
                      new Container(
                        padding: new EdgeInsets.only(top: 10.0),
                        child: new Text(
                          '开源地址',
                          style: new TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              new Flexible(
                flex: 1,
                child: new Container(
                  constraints: new BoxConstraints.expand(),
                  margin: new EdgeInsets.only(left: 5.0, right: 5.0),
                  color: Colors.white,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'images/icon_blog.png',
                        width: 50.0,
                        height: 50.0,
                      ),
                      new Container(
                        padding: new EdgeInsets.only(top: 10.0),
                        child: new Text(
                          '文章',
                          style: new TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              new Flexible(
                flex: 1,
                child: new Container(
                  constraints: new BoxConstraints.expand(),
                  margin: new EdgeInsets.only(left: 5.0, right: 5.0),
                  color: Colors.white,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'images/icon_wx.png',
                        width: 50.0,
                        height: 50.0,
                      ),
                      new Container(
                        padding: new EdgeInsets.only(top: 10.0),
                        child: new Text(
                          '微信公众号',
                          style: new TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget getGithubSection() {}

  Widget getWXSection() {}

  Widget getQQGroupSection() {}

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
