import 'dart:async';
import 'dart:convert';
import 'dart:math' as Math;
import 'dart:ui' as ui;

import 'package:doubanmovie_flutter/model//MovieDetail.dart';
import 'package:doubanmovie_flutter/model//MovieIntro.dart';
import 'package:doubanmovie_flutter/palette.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MovieDetailPage extends StatelessWidget {
  String hdImgUrl;
  MovieIntro movieIntro;

  MovieDetailPage({Key key, this.hdImgUrl, this.movieIntro}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _MovieDetailPageBuilder(movieIntro.id, hdImgUrl),
    );
  }
}

class _MovieDetailPageBuilder extends StatefulWidget {
  String _movieId;
  String hdImgUrl;
  _MovieDetailPageBuilder(this._movieId, this.hdImgUrl);

  @override
  State<StatefulWidget> createState() {
    return new _MovieDetailPageBuilderState(_movieId, hdImgUrl);
  }
}

class _MovieDetailPageBuilderState extends State<_MovieDetailPageBuilder> {
  String _movieId;
  String hdImgUrl;
  var _movieDetailMap;
  MovieDetail movieDetail;
  Color _titleBarColor = Colors.teal;

  _MovieDetailPageBuilderState(this._movieId, this.hdImgUrl);

  @override
  void initState() {
    super.initState();
    loadData();
    getImageAndPalette();
  }

  Future<void> getImageAndPalette() async {
    Palette palette = await PaletteLib.getPaletteWithUrl(hdImgUrl);
    print(palette.darkVibrant.color.toString());

    if (!mounted) return;

    setState(() {
      _titleBarColor = palette.vibrant.color;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_movieDetailMap != null) {
      return CustomScrollView(
        slivers: <Widget>[
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
            title: new Text(movieDetail.title),
          ),
          new SliverList(
            delegate: new SliverChildListDelegate(
              [
                _blurHeaderSection(
                    hdImgUrl == null ? movieDetail.images.large : hdImgUrl),
                _BasicInfoSection(),
                _SummarySection(),
                getActorList(),
              ],
            ),
          ),
//          new SliverList(
//            delegate: new SliverChildBuilderDelegate(
//              (BuildContext context, int index) {
//                return getActorListItem(index);
//              },
//              childCount: movieDetail.casts.length,
//            ),
//          ),
        ],
      );
    }
    return new Center(
      child: new CircularProgressIndicator(),
    );
  }

  void loadData() {
    http
        .get('https://api.douban.com/v2/movie/subject/' + _movieId)
        .then((http.Response response) {
      setState(() {
        JsonDecoder jsonDecoder = new JsonDecoder();
        _movieDetailMap = jsonDecoder.convert(response.body);
        movieDetail = new MovieDetail.fromJson(_movieDetailMap);
      });
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

  Widget _blurHeaderSection(String imgUrl) {
    return new Stack(
      children: <Widget>[
        new Image.network(
          movieDetail.images.large,
          fit: BoxFit.fill,
          width: 500.0,
          height: 400.0,
        ),
        new BackdropFilter(
          filter: new ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: new Container(
            padding: new EdgeInsets.only(top: 50.0),
            width: 500.0,
            height: 400.0,
            decoration:
                new BoxDecoration(color: Colors.grey.shade900.withOpacity(0.0)),
            child: new Center(
              child: new Image.network(
                imgUrl,
                width: 186.2,
                height: 300.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _BasicInfoSection() {
    return new Padding(
      padding: new EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new Align(
              alignment: new FractionalOffset(0.0, 0.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    movieDetail.title,
                    style: new TextStyle(
                        fontSize: 20.0,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold),
                  ),
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
                      new CustomPaint(
                        size: new Size(100.0, 20.0),
                        painter: new ScorePainter(
                          movieDetail.rating.average,
                        ),
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

  getActorList() {
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

  buildActorItems() {
    List<Widget> actorItems = [];
    actorItems.add(getDirectorsListItem());
    for (int i = 0; i < movieDetail.casts.length; i++) {
      actorItems.add(getActorListItem(i));
    }
    return actorItems;
  }

  Widget getActorListItem(int pos) {
    return new Column(
      children: <Widget>[
        new Padding(
          padding: new EdgeInsets.only(
              top: 10.0, left: 12.0, right: 12.0, bottom: 5.0),
          child: Image.network(
            movieDetail.casts[pos].avatars.large,
            width: 70.0,
            height: 100.0,
          ),
        ),
        new Text(movieDetail.casts[pos].name),
      ],
    );
  }

  Widget getDirectorsListItem() {
    return new Column(
      children: <Widget>[
        new Padding(
          padding: new EdgeInsets.only(
              top: 10.0, left: 6.0, right: 6.0, bottom: 5.0),
          child: Image.network(
            movieDetail.directors[0].avatars.large,
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

  Widget _SummarySection() {
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

class ScorePainter extends CustomPainter {
  double _score;

  ScorePainter(this._score);

  @override
  void paint(Canvas canvas, Size size) {
    double padding = 10.0; //左右两边间距
    double spacing = 2.0; // 星星之间间距

    double outR = (size.width - 2 * padding - 4 * spacing) / 2 / 5;
    double inR = outR * sin(18) / sin(180 - 36 - 18);

    Paint paint = new Paint();
    paint.isAntiAlias = true;
    paint.color = Colors.orange;
    paint.strokeWidth = 1.0;

    canvas.translate(padding + outR, outR);
    //Path path = getCompletePath(outR, inR);
    paint.style = PaintingStyle.fill;
//    Path path = getStarPath(outR, inR, 0.0, 0.0, 0.0);
//
//    for (int i = 0; i < 5; i++) {
//      canvas.drawPath(path, paint);
//      canvas.translate(spacing + outR * 2, 0.0);
//    }

    Path path;
    for (int i = 0; i < 5; i++) {
      if (_score > 2.0) {
        // 完整的星星
        paint.color = Colors.orange;
        path = getStarPath(outR, inR, 0.0, 0.0, 0.0);
        canvas.drawPath(path, paint);
      } else if (_score > 0.0) {
        // 不完整的星星
        paint.color = Colors.grey;
        path = getStarPath(outR, inR, 0.0, 0.0, 0.0);
        canvas.drawPath(path, paint);

        paint.blendMode = BlendMode.overlay;
        paint.color = Colors.orange;
        Rect rect = new Rect.fromLTWH(-outR, -outR, outR * _score, 2 * outR);
        canvas.drawRect(rect, paint);

        paint.blendMode = BlendMode.src;
      } else {
        // 灰色星星
        paint.color = Colors.grey;
        path = getStarPath(outR, inR, 0.0, 0.0, 0.0);
        canvas.drawPath(path, paint);
      }
      canvas.translate(spacing + outR * 2, 0.0);
      _score -= 2.0;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  getStarPath(double R, double r, double x, double y, double rot) {
    Path path = new Path();

    path.moveTo(Math.cos((54 + 72 * -1 - rot) / 180 * Math.PI) * r + x,
        -Math.sin((54 + 72 * -1 - rot) / 180 * Math.PI) * r + y);

    for (var i = 0; i < 5; i++) {
      path.lineTo(Math.cos((18 + 72 * i - rot) / 180 * Math.PI) * R + x,
          -Math.sin((18 + 72 * i - rot) / 180 * Math.PI) * R + y);
      path.lineTo(Math.cos((54 + 72 * i - rot) / 180 * Math.PI) * r + x,
          -Math.sin((54 + 72 * i - rot) / 180 * Math.PI) * r + y);
    }
    path.close();
    return path;
  }

  double cos(int num) {
    return Math.cos(num * Math.PI / 180);
  }

  double sin(int num) {
    return Math.sin(num * Math.PI / 180);
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
