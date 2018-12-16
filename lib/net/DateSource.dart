import 'dart:async';

import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

void main() {
  new DataSource().getHotFilmCritics();
}

class DataSource {
  void a() {
    http
        .get('https://movie.douban.com/subject/26804147/photos?type=R')
        .then((http.Response response) {
      var document = parse(response.body.toString());
      String imgId = document
          .getElementsByClassName('poster-col3 clearfix')[0]
          .getElementsByTagName('li')[0]
          .attributes['data-id']
          .toString();
      print("https://img1.doubanio.com/view/photo/l/public/p" + imgId + ".jpg");
    });
  }

  void getHdCover() {
    Map<String, String> hdImgMap;
    http
        .get('https://movie.douban.com/cinema/nowplaying/beijing/')
        .then((http.Response response) {
      var document = parse(response.body.toString());
      List<Element> items = document.getElementsByClassName('list-item');
      hdImgMap = new Map();
      for (var item in items) {
        var url =
            item.getElementsByTagName('img')[0].attributes['src'].toString();
        String movieId = item.attributes['data-subject'].toString();

        RegExp exp = new RegExp('public\/p.+\.jpg');
        String s = exp.firstMatch(url).group(0);

        String imgId = s.substring(8, 18);
        String imgUrl =
            "https://img1.doubanio.com/view/photo/l/public/p" + imgId + ".jpg";
        print(imgUrl);
        hdImgMap.addAll({movieId: imgUrl});
      }
    });
  }

  Future getNewList() async {
    List<Map<String, String>> list = [];
    await http
        .get('https://movie.douban.com/chart')
        .then((http.Response response) {
      var document = parse(response.body.toString());
      List<Element> newList = document
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
      return list;
    });
  }

  void getWeeklyList() {
    http.get('https://movie.douban.com/chart').then((http.Response response) {
      var document = parse(response.body.toString());
      List<Element> newList = document
          .getElementById('listCont2')
          .getElementsByClassName('clearfix');

      for (int i = 1; i < newList.length; i++) {
        var info = newList[i].getElementsByTagName('a')[0];
        var rank = newList[i]
            .getElementsByTagName('span')[0]
            .getElementsByTagName('div')[0];
        String url = info.attributes['href'];
        String ranking = rank.attributes['class'];
        String change = rank.text.trim();
        String movieId = url.split('/')[4].trim();
        print(movieId);
        print(info.text.trim());
        print(url);
        print(ranking + change);

        print('-------------------------------------------');
      }
    });
  }

  static void getWeeklyData() {
    List<Map<String, String>> list = [];
    http.get('https://movie.douban.com/chart').then((http.Response response) {
      var document = parse(response.body.toString());
      print('1');
      //print(response.body.toString());
      List<Element> newList = document
          .getElementById('listCont2')
          .getElementsByClassName('clearfix');
      print(document.getElementById('listCont2').text);
      for (int i = 1; i < newList.length; i++) {
        print('2');
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
    });
  }

  List<Map<String, String>> getHotFilmCritics() {
    List<Map<String, String>> hotFilmCritics = [];
    http
        .get('https://movie.douban.com/subject/3878007/')
        .then((http.Response response) {
      var document = parse(response.body.toString());

      List<Element> commentList = document
          .getElementById('hot-comments')
          .getElementsByClassName('comment-item');

      for (var comment in commentList) {
        Map<String, String> criticsItem = new Map();

        print('---------------');

        String authorName = comment
            .getElementsByClassName('comment-info')[0]
            .getElementsByTagName('a')[0]
            .text;
        criticsItem['author'] = authorName;
        print('作者：' + authorName);

        String rate =
            comment.getElementsByClassName('rating')[0].attributes['title'];
        criticsItem['rate'] = rate;
        print('评分：' + rate);

        String starNum =
            comment.getElementsByClassName('rating')[0].attributes['class'];
        criticsItem['stars'] = starNum;
        print('星星：' + starNum.substring(0, 9));

        String votes = comment.getElementsByClassName('votes')[0].text;
        criticsItem['votes'] = votes;
        print('获赞：' + votes);

        String commentTime =
            comment.getElementsByClassName('comment-time ')[0].text.trim();
        criticsItem['commentTime'] = commentTime;
        print('时间:' + commentTime);

        String commentShort = comment.getElementsByClassName('short')[0].text;
        criticsItem['commentShort'] = commentShort;
        print('评论:' + commentShort);

        if (comment.getElementsByClassName('hide-item').length > 0) {
          String commentFull =
              comment.getElementsByClassName('hide-item')[0].text;
          criticsItem['commentFull'] = commentFull;
          print('全长评论：' + commentFull);
        }
        hotFilmCritics.add(criticsItem);
      }

      print('===============');
      for (var i in hotFilmCritics) {
        print(i);
      }
      return hotFilmCritics;
    });
  }
}
