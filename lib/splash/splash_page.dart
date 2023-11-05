import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zixun_demo/routes.dart';

/// Author: ruizhang
/// Date: 2023/11/5 12:38
/// Description: 启动页
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  ValueNotifier<int> splashRemainTime = ValueNotifier(3);

  //模拟一个启动页广告倒计时
  late Timer splashTimer;

  @override
  void initState() {
    super.initState();
    startSplash();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: Center(
          child: ValueListenableBuilder(
            valueListenable: splashRemainTime,
            builder: (_, val, __) {
              return Text("splash 广告剩余时间 $val s");
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    splashTimer.cancel();
  }

  void startSplash() {
    // todo zrz 模拟splash广告停留
    Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        splashRemainTime.value = splashRemainTime.value - 1;
        if (splashRemainTime.value <= 0) {
          timer.cancel();
          // todo zrz 省略引导展示判断逻辑,进入引导页
          Navigator.pushReplacementNamed(context, RoutePath.guide);
        }
      },
    );
  }
}
