import 'package:flutter/material.dart';
import 'package:zixun_demo/routes.dart';

/// Author: ruizhang
/// Date: 2023/11/5 12:56
/// Description: 引导页
class GuidePage extends StatefulWidget {
  const GuidePage({super.key});

  @override
  State<GuidePage> createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  //当前guide页
  ValueNotifier<int> currentIndex = ValueNotifier(0);

  //todo guide数据，暂时用String图片代替
  List<String> guideData = [
    "assets/images/guide.png",
    "assets/images/guide.png",
    "assets/images/guide.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          buildPageView(),
          Positioned(
            top: MediaQuery.of(context).padding.top + 40,
            left: 0,
            right: 0,
            child: Center(child: _Indicator()),
          ),
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 40,
            left: 0,
            right: 0,
            child: Center(child: buildSkip()),
          ),
        ],
      ),
    );
  }

  ///引导主内容
  Widget buildPageView() {
    return PageView(
      onPageChanged: onPageChanged,
      children: guideData.map((e) => Image.asset("assets/images/guide.png", fit: BoxFit.contain)).toList(),
    );
  }

  ///skip按钮
  Widget buildSkip() {
    return GestureDetector(
      onTap: onSkip,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(20),
            right: Radius.circular(20),
          ),
        ),
        child: IntrinsicWidth(
          child: Center(
            child: ValueListenableBuilder<int>(
              valueListenable: currentIndex,
              builder: (_, val, __) {
                //优化，最后一页展示start文字
                return Text(
                  val == guideData.length - 1 ? 'Start' : 'Skip',
                  style: const TextStyle(color: Colors.white),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  void onSkip() {
    Navigator.pushReplacementNamed(context, RoutePath.home);
  }
}

///指示器
class _Indicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //找到父节点拿到状态
    final parentState = context.findRootAncestorStateOfType<_GuidePageState>()!;
    return ValueListenableBuilder<int>(
      valueListenable: parentState.currentIndex,
      builder: (_, val, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            parentState.guideData.length,
            (index) {
              return Padding(
                //最后一个不设置右间距
                padding: EdgeInsets.only(right: index == parentState.guideData.length - 1 ? 0 : 6),
                child: buildOneDot(index == val),
              );
            },
          ),
        );
      },
    );
  }

  ///一个指示器原点。[isActive]是否是活跃点
  Widget buildOneDot(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.grey,
        borderRadius: const BorderRadius.horizontal(
          left: Radius.circular(4),
          right: Radius.circular(4),
        ),
      ),
    );
  }
}
