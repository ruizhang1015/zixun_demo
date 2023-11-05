import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
        child: const Center(
          child: Text("splash"),
        ),
      ),
    );
  }

  void startSplash() async {
    await SchedulerBinding.instance.endOfFrame;
    // todo zrz 省略引导展示判断逻辑,进入引导页
    // todo zrz 模拟splash广告停留
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      Navigator.pushReplacementNamed(context, RoutePath.guide);
    }
  }
}
