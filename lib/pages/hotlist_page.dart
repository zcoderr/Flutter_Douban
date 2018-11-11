import 'dart:async';
import 'dart:convert';

import 'package:doubanmovie_flutter/model//MovieIntroList.dart';
import 'package:doubanmovie_flutter/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

/// 首页-热门电影列表
/// Desc：请求豆瓣热门电影列表接口，根据接口返回的电影列表数据，用爬虫方法获取高清的电影海报地址

class HotListPage extends StatefulWidget {
  @override
  State createState() {
    return new HotListState();
  }
}

class HotListState extends State<HotListPage> {
  // 网络数据
  var _data;

  // 卡片数组
  List cards = [];
  int curPage = 0;

  // 存放高清电影海报的数组
  Map<String, String> hdImgMap;

  @override
  void initState() {
    super.initState();
    loadData(false);
  }

  Widget getListItem(int pos) {
    return new InkWell(
      onTap: () {
        toDetailPage(_data[pos].id, hdImgMap[_data[pos].id]);
      },
      child: new Padding(
        padding: new EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
        child: new AspectRatio(
          aspectRatio: 28.0 / 37.0,
          child: new Card(
            // 卡片
            clipBehavior: Clip.hardEdge,
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
              // 圆角
              borderRadius: BorderRadius.all(
                Radius.circular(16.0),
              ),
            ),
            child: new Stack(
              fit: StackFit.expand,
              children: <Widget>[
                new Image.network(_data[pos].images.large, fit: BoxFit.fill),
                hdImgMap == null
                    ? new Text('...') // 为空的时候什么都不显示
                    : Image.network(
                        // 不为空，加载高清图
                        hdImgMap[_data[pos].id],
                        fit: BoxFit.fill,
                      ),
                new Positioned(
                  left: 0.0,
                  top: 0.0,
                  child: Container(
                    // 卡片上部半透明蒙层
                    padding: new EdgeInsets.only(
                        left: 15.0, top: 10.0, right: 500.0, bottom: 10.0),
                    decoration: new BoxDecoration(
                      gradient: new LinearGradient(
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(0.0, 1.0),
                        colors: <Color>[
                          Colors.grey.shade600.withOpacity(0.7),
                          Colors.grey.shade600.withOpacity(0.1),
                          //const Color(0xff000000),
                          //const Color(0xff000000)
                        ],
                      ),
                    ),
                    child: new Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          '评分:${_data[pos].rating.average}',
                          style: new TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                        new Text(
                          _data[pos].title,
                          style: new TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30.0,
                              decorationColor: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  toDetailPage(String movieId, String imgUrl) {
    setState(() {
      Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new MovieDetailPage(
            movieId: movieId,
            hdImgUrl: imgUrl,
          );
        },
      ));
    });
  }

  Future<Null> _pullToRefresh() async {
    curPage = 1;
    loadData(false);
    return null;
  }

  // 爬虫方法获取高清的电影封面图
  void getHdImgCover() async {
    Map<String, String> map = new Map();
    await http.get('https://movie.douban.com/cinema/nowplaying/beijing/').then(
      (http.Response response) {
        new Future(
          () {
            var document = parse(response.body.toString());
            List<dom.Element> items =
                document.getElementsByClassName('list-item');
            for (var item in items) {
              var url = item
                  .getElementsByTagName('img')[0]
                  .attributes['src']
                  .toString();
              String movieId = item.attributes['data-subject'].toString();

              RegExp exp = new RegExp('public\/p.+\.jpg');
              String s = exp.firstMatch(url).group(0);

              String imgId = s.substring(8, 18);
              String imgUrl =
                  "https://img1.doubanio.com/view/photo/l/public/p" +
                      imgId +
                      ".jpg";
              print("获取到封面： " + imgUrl);
              map[movieId] = imgUrl;

              setState(
                () {
                  hdImgMap = map;
                },
              );
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_data == null) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      return new RefreshIndicator(
          child: new ListView.builder(
            itemCount: _data.length + 1,
            itemBuilder: (BuildContext context, int position) {
              if (position == 0) {
                return new HotListTitle();
              } else {
                return getListItem(position - 1);
              }
            },
          ),
          onRefresh: _pullToRefresh);
    }
  }

  // 加载豆瓣的数据
  void loadData(bool isLoadMore) {
    http
        .get('https://api.douban.com/v2/movie/in_theaters')
        .then((http.Response response) {
      JsonDecoder jsonDecoder = new JsonDecoder();
      Map respMap = jsonDecoder.convert(response.body);
      // 解析数据
      MovieIntroList list = new MovieIntroList.fromJson(respMap);

      //cards = list.subjects;
      cards = respMap['subjects'];
      print("resp" + cards.toString());
      setState(() {
        _data = list.subjects;
      });

      getHdImgCover();
    });
  }
}

// 顶部标题
class HotListTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Text(
        '首页',
        style: new TextStyle(
            color: Colors.black, fontSize: 36.0, fontWeight: FontWeight.bold),
      ),
      padding: new EdgeInsets.only(left: 15.0, bottom: 13.0, top: 30.0),
    );
  }
}
