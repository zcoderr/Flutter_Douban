import 'package:doubanmovie_flutter/pages/explore_page.dart';
import 'package:doubanmovie_flutter/pages/hotlist_page.dart';
import 'package:doubanmovie_flutter/pages/more_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(new DoubanMovieClient());

class DoubanMovieClient extends StatefulWidget {
  @override
  State createState() {
    return new ClientState();
  }
}

class ClientState extends State<DoubanMovieClient> {
  int _tabIndex = 0;
  final tabTextStyleNormal = new TextStyle(color: const Color(0xff999999));
  final tabTextStyleSelected = new TextStyle(color: const Color(0xff4c4c4c));

  var tabImages;
  var _body;
  var appBarTitles = ['首页', '发现', '更多'];

  Image getTabImage(path) {
    return new Image.asset(path, width: 20.0, height: 20.0);
  }

  void initData() {
    if (tabImages == null) {
      tabImages = [
        [
          getTabImage('images/icon_hot_normal.png'),
          getTabImage('images/icon_hot_selected.png')
        ],
        [
          getTabImage('images/icon_explore_normal.png'),
          getTabImage('images/icon_explore_selected.png')
        ],
        [
          getTabImage('images/icon_more_normal.png'),
          getTabImage('images/icon_more_selected.png')
        ]
      ];
    }
    _body = new IndexedStack(
      children: <Widget>[
        new HotListPage(),
        new ExplorePage(),
        new MorePage(),
        new HotListPage()
      ],
      index: _tabIndex,
    );
  }

  TextStyle getTabTextStyle(int curIndex) {
    if (curIndex == _tabIndex) {
      return tabTextStyleSelected;
    }
    return tabTextStyleNormal;
  }

  Image getTabIcon(int curIndex) {
    if (curIndex == _tabIndex) {
      return tabImages[curIndex][1];
    }
    return tabImages[curIndex][0];
  }

  Text getTabTitle(int curIndex) {
    return new Text(appBarTitles[curIndex], style: getTabTextStyle(curIndex));
  }

  @override
  Widget build(BuildContext context) {
    initData();

    final CupertinoTabBar botNavBar = new CupertinoTabBar(
        /*
       * 在底部导航栏中布置的交互项：迭代存储NavigationIconView类的列表
       *  返回此迭代的每个元素的底部导航栏项目
       *  创建包含此迭代的元素的列表
       */
        items: <BottomNavigationBarItem>[
          new BottomNavigationBarItem(
              icon: getTabIcon(0), title: getTabTitle(0)),
          new BottomNavigationBarItem(
              icon: getTabIcon(1), title: getTabTitle(1)),
          new BottomNavigationBarItem(
              icon: getTabIcon(2), title: getTabTitle(2)),
        ],
        // 当前活动项的索引：存储底部导航栏的当前选择
        currentIndex: _tabIndex,
        // 当点击项目时调用的回调
        onTap: (int index) {
          setState(() {
            _tabIndex = index;
          });
        });

    return new MaterialApp(
      theme: new ThemeData(primaryColor: const Color(0xFF63CA6C)),
      home: new Scaffold(
        body: _body,
        bottomNavigationBar: botNavBar,
      ),
    );
  }
}
