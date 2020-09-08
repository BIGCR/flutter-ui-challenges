import 'package:flutter/material.dart';
import 'package:flutter_ui_challenges/lightswitch/on_off_switch.dart';
import 'package:flutter_ui_challenges/onboarding/animated_onboarding.dart';
import 'package:flutter_ui_challenges/readabletabbar/readable_tab_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter UI Challenges',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: allRoutes,
      initialRoute: '/',
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: ListView(
        children: [...allPages.map((e) => RoutePageTile(e))],
      ),
    );
  }
}

class Page {
  const Page({this.name, this.route, this.builder});

  final String name;
  final String route;
  final WidgetBuilder builder;
}

final allPages = [
  Page(
    name: 'On/Off Switch',
    route: OnOffSwitch.routeName,
    builder: (context) => OnOffSwitch(),
  ),
  Page(
    name: 'Readable Tab Bar',
    route: ReadableTabBar.routeName,
    builder: (context) => ReadableTabBar(),
  ),
  Page(
    name: 'Animated Onboarding',
    route: Onboarding.routeName,
    builder: (context) => Onboarding(),
  ),
];

final routes =
    Map.fromEntries(allPages.map((e) => MapEntry(e.route, e.builder)));

final allRoutes = <String, WidgetBuilder>{...routes};

class RoutePageTile extends StatelessWidget {
  RoutePageTile(this.page);

  final Page page;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(page.name),
      onTap: () {
        Navigator.pushNamed(context, page.route);
      },
    );
  }
}
