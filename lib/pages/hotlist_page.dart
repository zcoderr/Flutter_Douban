import 'dart:async';
import 'dart:convert';

import 'package:doubanmovie_flutter/model//MovieIntroList.dart';
import 'package:doubanmovie_flutter/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

class HotListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new HotList();
  }
}

class HotList extends StatefulWidget {
  @override
  State createState() {
    return new HotListState();
  }
}

class HotListState extends State<HotList> {
  var datas;
  List cards = [];
  int curPage = 0;
  Map<String, String> hdImgMap;

  @override
  void initState() {
    super.initState();
    loadData(false);
  }

  Widget getListItem(int pos) {
    return new InkWell(
      onTap: () {
        toDetailPage(pos);
      },
      child: new Padding(
        padding: new EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
        child: new AspectRatio(
          aspectRatio: 28.0 / 37.0,
          child: new Card(
            elevation: 7.0,
            shape: new RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: new Stack(
              fit: StackFit.expand,
              children: <Widget>[
                new Image.network(datas[pos].images.large, fit: BoxFit.fill),
                hdImgMap == null
                    ? new Text('')
                    : new MovieCover(hdImgMap[datas[pos].id]),
                new Positioned(
                  left: 0.0,
                  top: 0.0,
                  child: Container(
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
                          '评分:${datas[pos].rating.average}',
                          style: new TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                        new Text(
                          datas[pos].title,
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

  toDetailPage(int pos) {
    setState(() {
      Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new MovieDetailPage(
            hdImgUrl: hdImgMap[datas[pos].id],
            movieIntro: datas[pos],
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

  void getHdImgCover() async {
    Map<String, String> map = new Map();
    await http
        .get('https://movie.douban.com/cinema/nowplaying/beijing/')
        .then((http.Response response) {
      new Future(() {
        var document = parse(response.body.toString());
        List<dom.Element> items = document.getElementsByClassName('list-item');
        for (var item in items) {
          var url =
              item.getElementsByTagName('img')[0].attributes['src'].toString();
          String movieId = item.attributes['data-subject'].toString();

          RegExp exp = new RegExp('public\/p.+\.jpg');
          String s = exp.firstMatch(url).group(0);

          String imgId = s.substring(8, 18);
          String imgUrl = "https://img1.doubanio.com/view/photo/m/public/p" +
              imgId +
              ".jpg";
          print(imgUrl);
          map[movieId] = imgUrl;
        }
        return map;
      }).then((map) {
        setState(() {
          hdImgMap = map;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (datas == null) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      return new RefreshIndicator(
          child: new ListView.builder(
            itemCount: datas.length + 1,
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

  void loadData(bool isLoadMore) {
    http
        .get('https://api.douban.com/v2/movie/in_theaters')
        .then((http.Response response) {
      JsonDecoder jsonDecoder = new JsonDecoder();
      Map map = jsonDecoder.convert(response.body);
      cards = map['subjects'];

      MovieIntroList list = new MovieIntroList.fromJson(map);
      setState(() {
        datas = list.subjects;
      });
      getHdImgCover();
    });
  }
}

class HotListTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Text(
        'Today',
        style: new TextStyle(
            color: Colors.black, fontSize: 36.0, fontWeight: FontWeight.bold),
      ),
      padding: new EdgeInsets.only(left: 15.0, bottom: 13.0, top: 30.0),
    );
  }
}

class MovieCover extends StatefulWidget {
  String imgUrl;

  MovieCover(this.imgUrl);

  @override
  State createState() {
    return new MovieCoverState(imgUrl);
  }
}

class MovieCoverState extends State<MovieCover> {
  String imgUrl;
  Image hdImage;

  MovieCoverState(this.imgUrl);

  @override
  void initState() {
    parseHdImgUrl();
  }

  @override
  void didUpdateWidget(MovieCover oldWidget) {}

  @override
  Widget build(BuildContext context) {
    return hdImage == null ? new Text('') : hdImage;
//    return Image.network(
//      imgUrl,
//      fit: BoxFit.fill,
//    );
  }

  parseHdImgUrl() async {
    if (imgUrl == null) {
      return;
    }
    Image image;
    image = Image.network(
      imgUrl,
      fit: BoxFit.fill,
    );

    setState(() {
      hdImage = image;
    });
  }
}
