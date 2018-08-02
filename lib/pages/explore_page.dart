import 'dart:convert';

import 'package:doubanmovie_flutter/model/MovieIntro.dart';
import 'package:doubanmovie_flutter/model/MovieIntroList.dart';
import 'package:doubanmovie_flutter/utils/StarView.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

import 'movie_detail_page.dart';

class ExplorePage extends StatefulWidget {
  @override
  State createState() => new ExplorePageState();
}

class ExplorePageState extends State<ExplorePage> {
  List<MovieIntro> _comingSoonData;
  List _newMovieList;
  List _weeklyRankList;

  final PageController _pageController = new PageController();
  double _currentPage = 0.0;

  @override
  void initState() {
    loadComningSoonData();
    loadNewRankData();
    getWeeklyData();
  }

  @override
  Widget build(BuildContext context) {
    if (_comingSoonData == null ||
        _newMovieList == null ||
        _weeklyRankList == null) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      return ListView(
        children: <Widget>[
          getComingSoonTitle(),
          new Container(
            height: 265.0,
            child: new ListView(
              physics: const PageScrollPhysics(
                  parent: const BouncingScrollPhysics()),
              scrollDirection: Axis.horizontal,
              children: new List.generate(_comingSoonData.length, (int index) {
                return getComingSoonItem(index);
              }),
            ),
          ),
          new Container(
            height: 500.0,
            padding: new EdgeInsets.only(top: 15.0),
            child: new PageView(
              controller: PageController(viewportFraction: 0.85),
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                getWeeklyPager(),
                getNewPager(),
              ],
            ),
          ),
        ],
      );
    }
  }

  Widget getComingSoonTitle() {
    return new Container(
      child: new Text(
        '即将上映',
        style: new TextStyle(
            color: Colors.black, fontSize: 34.0, fontWeight: FontWeight.bold),
      ),
      padding: new EdgeInsets.only(top: 30.0, left: 15.0, bottom: 20.0),
    );
  }

  Widget getComingSoonItem(int index) {
    return new InkWell(
      onTap: () {
        toDetailPage(_comingSoonData[index].id);
      },
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            child: new Text(
              _comingSoonData[index].title,
              style: new TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
            padding: new EdgeInsets.only(left: 17.0, bottom: 5.0),
          ),
          new Container(
            height: 230.0,
            padding: new EdgeInsets.only(left: 15.0),
            child: new AspectRatio(
              aspectRatio: 28.0 / 37.0,
              child: new Card(
                child: new Image.network(
                  _comingSoonData[index].images.large,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getNewPager() {
    return new Container(
      padding: new EdgeInsets.only(left: 17.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            '新片榜',
            style: new TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
          ),
          new Container(
            height: 400.0,
            padding: new EdgeInsets.only(top: 5.0),
            child: new ListView(
              physics: new NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: new List.generate(5, (int index) {
                return getNewPagerItem(index);
              }),
            ),
          ),
          new Align(
            alignment: new Alignment(0.0, 0.0),
            child: new Text(
              '显示全部（共10部）',
              style: new TextStyle(fontSize: 13.0, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget getNewPagerItem(int index) {
    return new InkWell(
      onTap: () {
        toDetailPage(_newMovieList[index]['id']);
      },
      child: new Container(
        padding: new EdgeInsets.only(top: 5.0),
        child: new Row(
          children: <Widget>[
            Image.network(
              _newMovieList[index]['img'],
              width: 50.0,
              height: 72.0,
              fit: BoxFit.fill,
            ),
            new Container(
              padding: new EdgeInsets.only(left: 5.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    _newMovieList[index]['title'],
                    style: new TextStyle(
                      fontSize: 12.0,
                      color: Colors.black,
                    ),
                  ),
                  new StarView(
                      80.0, 20.0, double.parse(_newMovieList[index]['score'])),
                  new Text(
                    _newMovieList[index]['score'] + '分',
                    style: new TextStyle(
                      fontSize: 10.0,
                      color: Colors.grey,
                    ),
                  ),
                  new Text(
                    _newMovieList[index]['num'],
                    style: new TextStyle(
                      fontSize: 10.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getWeeklyPager() {
    return new Container(
      padding: new EdgeInsets.only(left: 15.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            '本周口碑榜',
            style: new TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
          ),
          new Container(
            height: 450.0,
            padding: new EdgeInsets.only(top: 5.0),
            child: new ListView(
              physics: new NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: new List.generate(10, (int index) {
                return getWeeklyPageItem(index);
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget getWeeklyPageItem(int index) {
    return new InkWell(
      onTap: () {
        toDetailPage(_weeklyRankList[index]['id']);
      },
      child: new Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
        ),
        padding: new EdgeInsets.only(top: 8.0, bottom: 8.0, left: 3.0),
        margin: new EdgeInsets.only(top: 3.0),
        child: new Row(
          children: <Widget>[
            new Text(
              _weeklyRankList[index]['rankid'] + '.',
              style: new TextStyle(color: Colors.grey),
            ),
            new Container(
              width: 250.0,
              padding: new EdgeInsets.only(
                left: 5.0,
                right: 5.0,
              ),
              child: new Text(
                _weeklyRankList[index]['title'],
                maxLines: 1,
                style: new TextStyle(color: Colors.black),
              ),
            ),
            new Align(
              alignment: new Alignment(1.0, 0.0),
              child: new Row(
                children: <Widget>[
                  _weeklyRankList[index]['rank'] == 'up'
                      ? new Image.asset('images/icon_ranking_up.png',
                          width: 10.0, height: 10.0)
                      : new Image.asset('images/icon_ranking_down.png',
                          width: 10.0, height: 10.0),
                  new Text(_weeklyRankList[index]['change']),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void loadComningSoonData() {
    http
        .get('https://api.douban.com/v2/movie/coming_soon')
        .then((http.Response response) {
      JsonDecoder jsonDecoder = new JsonDecoder();
      Map map = jsonDecoder.convert(response.body);

      MovieIntroList list = new MovieIntroList.fromJson(map);
      setState(() {
        _comingSoonData = list.subjects;
      });
    });
  }

  void loadNewRankData() {
    List<Map<String, String>> list = [];
    http.get('https://movie.douban.com/chart').then((http.Response response) {
      var document = parse(response.body.toString());
      List<dom.Element> newList = document
          .getElementsByClassName('indent')[0]
          .getElementsByTagName('table');

      for (var item in newList) {
        Map<String, String> movie = new Map();

        String url = item.getElementsByTagName('a')[0].attributes['href'];
        String title = item.getElementsByTagName('a')[0].attributes['title'];
        String score = item
            .getElementsByClassName('star clearfix')[0]
            .getElementsByClassName('rating_nums')[0]
            .text;

        String num = item
            .getElementsByClassName('star clearfix')[0]
            .getElementsByClassName('pl')[0]
            .text;

        String img = item.getElementsByTagName('img')[0].attributes['src'];
        String movieId = url.split('/')[4].trim();
        print(title);
        print(url);
        print(score);
        print(num);
        print(img);
        movie['title'] = title;
        movie['id'] = movieId;
        movie['score'] = score;
        movie['num'] = num;
        movie['img'] = img;

        list.add(movie);
        print('---------------------');
        //hdImgMap.addAll({movieId: imgUrl});
      }

      setState(() {
        _newMovieList = list;
      });
    });
  }

  void getWeeklyData() {
    List<Map<String, String>> list = [];
    http.get('https://movie.douban.com/chart').then((http.Response response) {
      var document = parse(response.body.toString());
      List<dom.Element> newList = document
          .getElementById('listCont2')
          .getElementsByClassName('clearfix');

      for (int i = 1; i < newList.length; i++) {
        Map<String, String> movie = new Map();

        var info = newList[i].getElementsByTagName('a')[0];
        var rank = newList[i]
            .getElementsByTagName('span')[0]
            .getElementsByTagName('div')[0];
        String url = info.attributes['href'];
        String ranking = rank.attributes['class'];
        String change = rank.text.trim();
        String movieId = url.split('/')[4].trim();

        print(info.text.trim());
        print(url);
        print(ranking + change);
        movie['rankid'] = i.toString();
        movie['title'] = info.text.trim();
        movie['url'] = url;
        movie['rank'] = ranking;
        movie['change'] = change;
        movie['id'] = movieId;

        list.add(movie);
        print('-------------------------------------------');
      }
      setState(() {
        _weeklyRankList = list;
      });
    });
  }

  toDetailPage(String movieId) {
    setState(() {
      Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new MovieDetailPage(
            movieId: movieId,
          );
        },
      ));
    });
  }
}

class PageDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _PageDemoState();
}

class _PageDemoState extends State<PageDemo> {
  final PageController _pageController = new PageController();
  double _currentPage = 0.0;

  @override
  Widget build(BuildContext context) => new Scaffold(
        body: new LayoutBuilder(
            builder: (context, constraints) => new NotificationListener(
                  onNotification: (ScrollNotification note) {
                    setState(() {
                      _currentPage = _pageController.page;
                    });
                  },
                  child: new PageView.custom(
                    physics: const PageScrollPhysics(
                        parent: const BouncingScrollPhysics()),
                    controller: _pageController,
                    childrenDelegate: new SliverChildBuilderDelegate(
                      (context, index) => new _SimplePage(
                            '$index',
                            parallaxOffset: constraints.maxWidth /
                                2.0 *
                                (index - _currentPage),
                          ),
                      childCount: 10,
                    ),
                  ),
                )),
      );
}

class _SimplePage extends StatelessWidget {
  _SimplePage(this.data, {Key key, this.parallaxOffset = 0.0})
      : super(key: key);

  final String data;
  final double parallaxOffset;

  @override
  Widget build(BuildContext context) => new Center(
        child: new Center(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Text(
                data,
                style: const TextStyle(fontSize: 60.0),
              ),
              new SizedBox(height: 40.0),
              new Transform(
                transform:
                    new Matrix4.translationValues(parallaxOffset, 0.0, 0.0),
                child: const Text('Yet another line of text'),
              ),
            ],
          ),
        ),
      );
}
