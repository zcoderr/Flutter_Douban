import 'dart:convert';
import 'dart:ui' as ui;

import 'package:doubanmovie_flutter/CustomView.dart';
import 'package:doubanmovie_flutter/model//MovieDetail.dart';
import 'package:doubanmovie_flutter/palette.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

///电影详情页
// ignore: must_be_immutable
class MovieDetailPage extends StatefulWidget {
  // 电影ID
  String movieId;

  // 电影高清海报图url
  String hdImgUrl;

  MovieDetailPage({Key key, this.movieId, this.hdImgUrl}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new MovieDetailPageState(movieId, hdImgUrl);
  }
}

class MovieDetailPageState extends State<MovieDetailPage> {
  String _movieId;
  String hdImgUrl;
  MovieDetail movieDetail;
  Color _titleBarColor;

  MovieDetailPageState(this._movieId, this.hdImgUrl);

  @override
  void initState() {
    super.initState();
    loadData();
  }

  getImageAndPalette() async {
    //通过Flutter插件获取图片主色调
    Palette palette =
        await PaletteLib.getPaletteWithUrl(movieDetail.images.large);
    //print(palette.darkVibrant.color.toString());

    if (!mounted) return;

    setState(() {
      if (palette.vibrant == null) {
        _titleBarColor = Colors.teal;
      } else {
        _titleBarColor = palette.vibrant.color;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (movieDetail != null && _titleBarColor != null) {
      return new Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            // titleBar
            new SliverAppBar(
              pinned: true,
              elevation: 0.0,
              backgroundColor: _titleBarColor,
              actions: <Widget>[
                new IconButton(
                  icon: new Icon(Icons.share),
                  tooltip: 'Open shopping cart',
                  onPressed: () {
                    // handle the press
                  },
                ),
              ],
              expandedHeight: 0.0,
              centerTitle: true,
              title: new Text(
                movieDetail.title,
                style: new TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            new SliverList(
              delegate: new SliverChildListDelegate(
                [
                  _blurHeaderSection(
                      hdImgUrl == null ? movieDetail.images.large : hdImgUrl),
                  _basicInfoSection(),
                  _summarySection(),
                  _actorListSection(),
                ],
              ),
            ),
          ],
        ),
      );
    }
    // 加载状态样式
    return new Scaffold(
      body: new Center(
        child: new CircularProgressIndicator(),
      ),
    );
  }

//  new SliverList(
//            delegate: new SliverChildBuilderDelegate(
//              (BuildContext context, int index) {
//                return getActorListItem(index);
//              },
//              childCount: movieDetail.casts.length,
//            ),
//          ),

  void loadData() {
    //获取电影详情数据
    http
        .get('https://api.douban.com/v2/movie/subject/' + _movieId)
        .then((http.Response response) {
      JsonDecoder jsonDecoder = new JsonDecoder();
      var _movieDetailMap = jsonDecoder.convert(response.body);
      setState(() {
        movieDetail = new MovieDetail.fromJson(_movieDetailMap);
      });
      getImageAndPalette();
    });
  }

  Widget _HeaderSection() {
    return new SizedBox(
      height: 270.0,
      child: DecoratedBox(
        decoration: new BoxDecoration(color: Colors.indigo),
        child: new Padding(
          padding: new EdgeInsets.only(top: 0.0),
          child: new Center(
            child: new Image.network(
              movieDetail.images.large,
              width: 144.0,
              height: 232.0,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  // Header 布局
  Widget _blurHeaderSection(String imgUrl) {
    return new Stack(
      children: <Widget>[
        // 底部背景图
        new Image.network(
          movieDetail.images.large,
          fit: BoxFit.fill,
          width: 500.0,
          height: 500.0,
        ),
        // 毛玻璃效果浮层
        new BackdropFilter(
          filter: new ui.ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
          child: new Container(
            padding: new EdgeInsets.only(top: 0.0),
            width: 500.0,
            height: 500.0,
            decoration:
                new BoxDecoration(color: Colors.grey.shade900.withOpacity(0.0)),
            // 居中的海报图
            child: new Center(
              child: new Image.network(
                imgUrl,
                width: 270,
                height: 400,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 基本信息区域
  Widget _basicInfoSection() {
    return new Padding(
      padding: new EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
      child: new Row(
        children: <Widget>[
          // weight=1
          new Expanded(
            child: new Align(
              alignment: new FractionalOffset(0.0, 0.0),
              child: new Column(
                // 左对齐
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // 电影标题
                  new Text(
                    movieDetail.title,
                    style: new TextStyle(
                        fontSize: 20.0,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold),
                  ),
                  // 电影标签
                  new Padding(
                    padding: new EdgeInsets.only(top: 5.0, bottom: 2.0),
                    child: new Text(
                      getGenres(),
                      style: new TextStyle(
                        color: Colors.grey,
                        fontSize: 11.0,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  new Text(
                    '原名：' + movieDetail.original_title,
                    style: new TextStyle(color: Colors.grey, fontSize: 11.0),
                  ),
                ],
              ),
            ),
          ),
          new Container(
            width: 100.0,
            height: 100.0,
            alignment: new FractionalOffset(1.0, 0.0),
            child: new Card(
                elevation: 5.0,
                shape: new RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(0.0),
                  ),
                ),
                child: new Center(
                  child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new Text(
                        '豆瓣评分',
                        style:
                            new TextStyle(color: Colors.grey, fontSize: 10.0),
                      ),
                      new Padding(
                        padding: new EdgeInsets.only(top: 2.0),
                        child: new Text(
                          movieDetail.rating.average.toString(),
                          style: new TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      new ScoreView(
                        new Size(100.0, 20.0),
                        movieDetail.rating.average,
                      ),
                      new Text(
                        movieDetail.ratings_count.toString() + "人",
                        style:
                            new TextStyle(color: Colors.grey, fontSize: 10.0),
                      ),
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }

  String getGenres() {
    StringBuffer sb = new StringBuffer();
    sb.write(movieDetail.year);

    for (int i = 0; i < movieDetail.genres.length; i++) {
      sb.write('/' + movieDetail.genres[i]);
    }
    return sb.toString();
  }

  //演员列表区域
  _actorListSection() {
    return new SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: new Padding(
          padding: new EdgeInsets.only(left: 15.0, top: 20.0, bottom: 30.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                '影人',
                style: new TextStyle(color: Colors.grey, fontSize: 12.0),
              ),
              new Row(
                children: buildActorItems(),
              ),
            ],
          ),
        ));
  }

  // 演员列表
  buildActorItems() {
    List<Widget> actorItems = [];
    actorItems.add(getDirectorsListItem());
    for (int i = 0; i < movieDetail.casts.length; i++) {
      actorItems.add(getActorListItem(i));
    }
    return actorItems;
  }

  // 演员列表Item
  Widget getActorListItem(int pos) {
    return new Column(
      children: <Widget>[
        new Padding(
          padding: new EdgeInsets.only(
              top: 10.0, left: 12.0, right: 12.0, bottom: 5.0),
          child: Image.network(
            movieDetail.casts[pos].avatars == null
                ? ""
                : movieDetail.casts[pos].avatars.large,
            width: 70.0,
            height: 100.0,
          ),
        ),
        new Text(movieDetail.casts[pos].name),
      ],
    );
  }

  // 导演Item
  Widget getDirectorsListItem() {
    return new Column(
      children: <Widget>[
        new Padding(
          padding: new EdgeInsets.only(
              top: 10.0, left: 6.0, right: 6.0, bottom: 5.0),
          child: Image.network(
            movieDetail.directors[0].avatars == null
                ? ""
                : movieDetail.directors[0].avatars.large,
            width: 70.0,
            height: 100.0,
          ),
        ),
        new LimitedBox(
          maxWidth: 70.0,
          child: new Text(
            movieDetail.directors[0].name,
            style: new TextStyle(fontSize: 12.0),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        new Text(
          '导演',
          style: new TextStyle(color: Colors.grey, fontSize: 12.0),
        ),
      ],
    );
  }

  // 电影简介区域
  Widget _summarySection() {
    return new Padding(
      padding: new EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Text(
            '简介',
            style: new TextStyle(color: Colors.grey, fontSize: 12.0),
          ),
          new Padding(
            padding: new EdgeInsets.only(top: 7.0),
            child: new Text(
              movieDetail.summary,
              style: new TextStyle(
                letterSpacing: 2.0,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ImgBlurPaint extends CustomPainter {
  ImgBlurPaint();

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint();

    ui.ImageFilter.blur(
      sigmaX: 0.0,
      sigmaY: 0.0,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
