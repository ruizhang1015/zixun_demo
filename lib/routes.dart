import 'package:flutter/material.dart';
import 'package:zixun_demo/guide/guide_page.dart';
import 'package:zixun_demo/home/home_page.dart';
import 'package:zixun_demo/splash/splash_page.dart';

/// Author: ruizhang
/// Date: 2023/11/5 12:40
/// Description: 路由
class RoutePath {
  static const splash = "/";
  static const guide = "/guide";
  static const home = "/home";
}

// 配置路由
final Map<String, WidgetBuilder> routes = {
  RoutePath.splash: (context) => const SplashPage(),
  RoutePath.guide: (context) => const GuidePage(),
  RoutePath.home: (context) => const HomePage()
};

//路由解析返回目标route
RouteFactory onGenerateRoute = (RouteSettings settings) {
  final String name = settings.name ?? RoutePath.splash;
  final Function? pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    //todo 这里省略了queryParams路由参数解析
    return MaterialPageRoute(builder: (context) => pageContentBuilder(context));
  } else {
    //todo 这里应该是404页面
    return MaterialPageRoute(
      builder: (context) => const Scaffold(
        body: Center(child: Text("未找到页面")),
      ),
    );
  }
};