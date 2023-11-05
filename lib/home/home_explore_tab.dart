import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Author: ruizhang
/// Date: 2023/11/5 14:18
/// Description: 首页的explore tab页
class HomeExploreTab extends StatefulWidget {
  const HomeExploreTab({super.key});

  @override
  State<HomeExploreTab> createState() => _HomeExploreTabState();
}

class _HomeExploreTabState extends State<HomeExploreTab> with AutomaticKeepAliveClientMixin {
  _ViewMode vm = _ViewMode();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      vm.fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ValueListenableBuilder<List<_ListItem>?>(
        valueListenable: vm.list,
        builder: (_, list, __) {
          if (null == list) {
            //数据获取中
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (list.isNotEmpty) {
            //数据不为空
            return buildContent(list);
          } else {
            //空数据
            return const Center(
              child: Text("数据为空"),
            );
          }
        });
  }

  ///构建内容区域
  Widget buildContent(List<_ListItem> list) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemBuilder: (context, index) {
        if (index == 0) {
          //头布局
          return const Padding(
            padding: EdgeInsets.only(top: 80),
            child: Text("Explore", style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.black)),
          );
        }
        //数据item,减去头布局个数
        return buildListItem(list[index - 1]);
      },
      //+1是因为有个头布局
      itemCount: list.length + 1,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 8);
      },
    );
  }

  ///构建list item
  Widget buildListItem(_ListItem item) {
    return Card(
      color: _cardColors[item.type % _cardColors.length] ?? Colors.black,
      child: Container(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //图标区域
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    // todo zrz 点击
                  },
                  child: const Icon(Icons.search),
                ),
                GestureDetector(
                  onTap: () {
                    // todo zrz 点击
                  },
                  child: const Icon(Icons.share),
                ),
              ],
            ),
            const SizedBox(height: 18),
            //标题
            Text(
              item.title,
              style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            //描述
            Text(
              item.desc,
              style: const TextStyle(color: Colors.black, fontSize: 12),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

// todo zrz 暂时定义到这里
///使用viewmodel管理数据、状态
class _ViewMode {
  //列表数据
  ValueNotifier<List<_ListItem>?> list = ValueNotifier(null);

  //获取数据
  void fetchData() async {
    //todo zrz 模拟请求
    await Future.delayed(const Duration(seconds: 2));
    // todo zrz 请求成功
    list.value = List.generate(
      10,
      (index) => _ListItem(
        "Finding information$index",
        "This requires a fill value to initialize the list elements with.To create an empty "
            "list, use for a growable list orList.empty for a fixed length list$index",
        index,
      ),
    );
  }
}

// todo zrz 暂时定义到这里
///列表item数据模型
class _ListItem {
  final String title;
  final String desc;
  final int type;

  _ListItem(this.title, this.desc, this.type);
}

// todo zrz 暂时定义到这里
///todo [_ListItem]的type对应的卡片颜色
const _cardColors = {0: Colors.green, 1: Colors.purple, 2: Colors.blue, 3: Colors.cyan};
