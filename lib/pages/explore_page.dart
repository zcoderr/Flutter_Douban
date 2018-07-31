import 'dart:convert';

import 'package:doubanmovie_flutter/model/MovieIntro.dart';
import 'package:doubanmovie_flutter/model/MovieIntroList.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

class ExplorePage extends StatefulWidget {
  @override
  State createState() => new ExplorePageState();
}

class ExplorePageState extends State<ExplorePage> {
  List<MovieIntro> _comingSoonData;
  List _newMovieList = [];
  final PageController _pageController = new PageController();
  double _currentPage = 0.0;

  @override
  void initState() {
    loadComningSoonData();
    loadRankingData();
  }

  @override
  Widget build(BuildContext context) {
    if (_comingSoonData == null || _newMovieList == null) {
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
              scrollDirection: Axis.horizontal,
              children: new List.generate(_comingSoonData.length, (int index) {
                return getComingSoonItem(index);
              }),
            ),
          ),
          new Container(
            height: 320.0,
            padding: new EdgeInsets.only(top: 15.0),
            child: new PageView(
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
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Container(
          child: new Text(
            _comingSoonData[index].title,
            style:
                new TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
            height: 300.0,
            child: new ListView(
              scrollDirection: Axis.vertical,
              children: new List.generate(4, (int index) {
                return getWeeklyPagerItem(index);
              }),
            ),
          )
        ],
      ),
    );
  }

  Widget getWeeklyPagerItem(int index) {
    return new Text(_newMovieList[index]['title']);
  }

  Widget getNewPager() {
    return new Container(
      padding: new EdgeInsets.only(left: 15.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            '新片榜',
            style: new TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
          )
        ],
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

  void loadRankingData() {
    List<Map<String, String>> list = [];
    http.get('https://movie.douban.com/chart').then((http.Response response) {
      var document = parse(response.body.toString());
      List<dom.Element> newList = document
          .getElementsByClassName('indent')[0]
          .getElementsByTagName('table');

      for (var item in newList) {
        Map<String, String> movie = new Map();

        String id = item.getElementsByTagName('a')[0].attributes['href'];
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

        print(title);
        print(id);
        print(score);
        print(num);
        print(img);
        movie['title'] = title;
        movie['id'] = id;
        movie[score] = score;
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
