import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

void main() {
  new Test().b();
}

class Test {
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

  void b() {
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
}
