import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

/// 更多页面
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
        buildMorePageTitle(),
        buildHeaderSection(),
        buildButtonSection(),
        buildQqGroupSection(),
        buildThanksForApi(),
      ],
    );
  }

  Widget buildHeaderSection() {
    return new Container(
      margin: new EdgeInsets.only(left: 15.0, right: 15.0),
      decoration: new BoxDecoration(
        border: new Border(
          top: new BorderSide(color: Colors.grey.shade200, width: 1.0),
        ),
      ),
      padding: new EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: new Stack(
        children: <Widget>[
          new Container(
            height: 80.0,
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
              width: 80.0,
              height: 80.0,
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage('images/flutter_logo.png'),
                  fit: BoxFit.cover,
                ),
                color: Colors.white,
                borderRadius: new BorderRadius.all(new Radius.circular(40.0)),
                border: new Border.all(
                  color: Colors.grey.shade200,
                  width: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButtonSection() {
    return new Container(
        height: 120.0,
        margin: new EdgeInsets.only(top: 5.0),
        padding: new EdgeInsets.only(
            left: 10.0, right: 10.0, top: 15.0, bottom: 15.0),
        color: Colors.grey.shade100,
        child: new Container(
          child: new Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              new Flexible(
                  flex: 1,
                  child: new InkWell(
                    onTap: () {
                      onGithubClick();
                    },
                    child: new Container(
                      constraints: new BoxConstraints.expand(),
                      margin: new EdgeInsets.only(left: 5.0, right: 5.0),
                      color: Colors.white,
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'images/icon_github.png',
                            width: 40.0,
                            height: 40.0,
                          ),
                          new Container(
                            padding: new EdgeInsets.only(top: 10.0),
                            child: new Text(
                              '开源地址',
                              style: new TextStyle(
                                color: Colors.black,
                                fontSize: 13.0,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
              new Flexible(
                flex: 1,
                child: new InkWell(
                  onTap: () {
                    onArticleClick();
                  },
                  child: new Container(
                    constraints: new BoxConstraints.expand(),
                    margin: new EdgeInsets.only(left: 5.0, right: 5.0),
                    color: Colors.white,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'images/icon_blog.png',
                          width: 40.0,
                          height: 40.0,
                        ),
                        new Container(
                          padding: new EdgeInsets.only(top: 10.0),
                          child: new Text(
                            '文章',
                            style: new TextStyle(
                              color: Colors.black,
                              fontSize: 13.0,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              new Flexible(
                flex: 1,
                child: new InkWell(
                  onTap: () {
                    onWxClick();
                  },
                  child: new Container(
                    constraints: new BoxConstraints.expand(),
                    margin: new EdgeInsets.only(left: 5.0, right: 5.0),
                    color: Colors.white,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'images/icon_wx.png',
                          width: 40.0,
                          height: 40.0,
                        ),
                        new Container(
                          padding: new EdgeInsets.only(top: 10.0),
                          child: new Text(
                            '微信公众号',
                            style: new TextStyle(
                              color: Colors.black,
                              fontSize: 13.0,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildQqGroupSection() {
    return new InkWell(
      onTap: () {
        onQQGroupClick();
      },
      child: new Container(
        padding: new EdgeInsets.only(
            left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
        margin: new EdgeInsets.only(top: 15.0),
        decoration: new BoxDecoration(color: Colors.grey.shade100),
        child: new Row(
          children: <Widget>[
            Image.asset(
              'images/icon_qq.png',
              width: 25.0,
              height: 25.0,
            ),
            new Container(
              margin: new EdgeInsets.only(left: 15.0),
              child: new Text(
                'Flutter 技术讨论群',
                style: new TextStyle(fontSize: 15.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildThanksForApi() {
    return new Container(
      padding:
          new EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
      margin: new EdgeInsets.only(top: 5.0),
      decoration: new BoxDecoration(color: Colors.grey.shade100),
      child: new Row(
        children: <Widget>[
          Image.asset(
            'images/icon_api.png',
            width: 25.0,
            height: 25.0,
          ),
          new Container(
            margin: new EdgeInsets.only(left: 15.0),
            child: new Text(
              '感谢豆瓣提供的Api',
              style: new TextStyle(fontSize: 15.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMorePageTitle() {
    return new Container(
      child: new Text(
        '更多',
        style: new TextStyle(
            color: Colors.black, fontSize: 34.0, fontWeight: FontWeight.bold),
      ),
      padding: new EdgeInsets.only(top: 30.0, left: 15.0, bottom: 20.0),
    );
  }

  void onGithubClick() {
    setState(() {
      Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new WebviewScaffold(
            url: "https://github.com/zcoderr/Flutter_Douban",
            appBar: new AppBar(
              backgroundColor: Colors.lightBlueAccent,
              title: new Text("Flutter版豆瓣电影"),
            ),
          );
        },
      ));
    });
  }

  void onArticleClick() {}

  void onWxClick() {}

  void onQQGroupClick() {}
}
