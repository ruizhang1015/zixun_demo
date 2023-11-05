import 'package:flutter/material.dart';
import 'package:zixun_demo/home/home_explore_tab.dart';
import 'package:zixun_demo/home/home_message_tab.dart';
import 'package:zixun_demo/util/ext.dart';

/// Author: ruizhang
/// Date: 2023/11/5 12:56
/// Description: 首页
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  _ViewMode vm = _ViewMode();
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        //与联动
        onPageChanged: vm.changeTabIndex,
        controller: pageController,
        children: vm.tabs.map((e) => buildTabPage(e)).toList(),
      ),
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: vm.currentTabIndex,
        builder: (_, index, __) {
          return bottomNavigation(index);
        },
      ),
    );
  }

  ///底部导航栏
  Widget bottomNavigation(int currentTabIndex) {
    return Container(
      height: kToolbarHeight,
      color: Colors.white,
      child: Row(
        children: vm.tabs
            .mapIndexed(
              (index, e) => Expanded(
                child: InkResponse(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () => onTabTap(index),
                  child: Center(
                    child: Icon(
                      e.icon,
                      color: currentTabIndex == index ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  ///一个tab页
  Widget buildTabPage(_TabData tab) {
    switch (tab.type) {
      case _TabType.explore:
        return const HomeExploreTab();
      case _TabType.message:
        return const HomeMessageTab();
      case _TabType.setting:
      case _TabType.mine:
      default:
        return Center(child: Text("暂未实现${tab.type}"));
    }
  }

  ///tab item点击
  void onTabTap(int index) {
    //与pageview联动
    if (index != vm.currentTabIndex.value) {
      pageController.jumpToPage(index);
    }
  }
}

///使用viewmodel管理状态
// todo zrz 暂时定义到这里
class _ViewMode {
  //tab数据
  final tabs = [
    _TabData(Icons.account_balance, _TabType.explore),
    _TabData(Icons.message_outlined, _TabType.message),
    _TabData(Icons.settings, _TabType.setting),
    _TabData(Icons.person, _TabType.mine)
  ];

  //当前tab index
  ValueNotifier<int> currentTabIndex = ValueNotifier(0);

  void changeTabIndex(int index) {
    currentTabIndex.value = index;
  }
}

///tab数据baen
// todo zrz 暂时定义到这里
class _TabData {
  final IconData icon;
  final _TabType type;

  _TabData(this.icon, this.type);
}

///tab类型
// todo zrz 暂时定义到这里
enum _TabType {
  explore,
  message,
  setting,
  mine,
}
