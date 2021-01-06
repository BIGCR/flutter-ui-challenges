import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

import '../url_util.dart';

class TabItem {
  final String title;
  final IconData icon;

  TabItem(this.title, this.icon);
}

Iterable<E> mapIndexed<E, T>(
    Iterable<T> items, E Function(int index, T item) f) sync* {
  var index = 0;

  for (final item in items) {
    yield f(index, item);
    index = index + 1;
  }
}

final readableTabs = [
  TabItem(
    'Home',
    IconData(OMIcons.codePoints['home'],
        fontFamily: 'outline_material_icons',
        fontPackage: 'outline_material_icons'),
  ),
  TabItem(
    'Search',
    IconData(OMIcons.codePoints['search'],
        fontFamily: 'outline_material_icons',
        fontPackage: 'outline_material_icons'),
  ),
  TabItem(
    'Bag',
    IconData(OMIcons.codePoints['shop'],
        fontFamily: 'outline_material_icons',
        fontPackage: 'outline_material_icons'),
  ),
  TabItem(
    'Likes',
    IconData(OMIcons.codePoints['thumb_up'],
        fontFamily: 'outline_material_icons',
        fontPackage: 'outline_material_icons'),
  ),
  TabItem(
    'Profile',
    IconData(OMIcons.codePoints['person'],
        fontFamily: 'outline_material_icons',
        fontPackage: 'outline_material_icons'),
  ),
];

class ReadableTabBar extends StatefulWidget {
  static final routeName = '/readable_tab_bar';

  @override
  _ReadableTabBarState createState() => _ReadableTabBarState();
}

class _ReadableTabBarState extends State<ReadableTabBar>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _activePosition = 0;
  Duration _duration = Duration(milliseconds: 300);

  @override
  void initState() {
    _tabController = TabController(
      length: readableTabs.length,
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Readable Tabs Demo'),
        actions: [
          IconButton(
              icon: FaIcon(FontAwesomeIcons.pinterest),
              onPressed: () {
                UrlUtil.launchURL(
                    'https://www.pinterest.com/pin/764837949211163312/');
              })
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: NeverScrollableScrollPhysics(),
                children: [...readableTabs.map((e) => Icon(e.icon))],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              height: kBottomNavigationBarHeight,
              decoration:
                  BoxDecoration(color: Theme.of(context).cardColor, boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 6.0,
                ),
              ]),
              child: TabBar(
                onTap: (position) {
                  setState(
                    () {
                      _activePosition = position;
                    },
                  );
                },
                indicator: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3.0,
                    ),
                  ),
                ),
                controller: _tabController,
                unselectedLabelColor: Theme.of(context).primaryColor,
                labelColor: Theme.of(context).primaryColor,
                tabs: [
                  ...mapIndexed(readableTabs, (index, TabItem tab) {
                    return Stack(
                      fit: StackFit.expand,
                      alignment: Alignment.center,
                      children: [
                        AnimatedOpacity(
                          duration: _duration,
                          opacity: _activePosition != index ? 1 : 0,
                          curve: Curves.decelerate,
                          child: Center(
                            child: Text(tab.title),
                          ),
                        ),
                        AnimatedAlign(
                          duration: _duration,
                          alignment: _activePosition == index
                              ? Alignment.center
                              : Alignment(0.0, 5),
                          child: Icon(tab.icon),
                          curve: Curves.decelerate,
                        )
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
