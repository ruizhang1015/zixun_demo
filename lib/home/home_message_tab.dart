import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:zixun_demo/util/ext.dart';

/// Author: ruizhang
/// Date: 2023/11/5 14:18
/// Description: 首页的message tab页
class HomeMessageTab extends StatefulWidget {
  const HomeMessageTab({super.key});

  @override
  State<HomeMessageTab> createState() => _HomeMessageTabState();
}

class _HomeMessageTabState extends State<HomeMessageTab> with AutomaticKeepAliveClientMixin {
  _ViewMode vm = _ViewMode();
  ScrollController lvController = ScrollController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      vm.fetchData();
    });
    vm.newMsg.addListener(onNewMessage);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ValueListenableBuilder<_Messenger?>(
      valueListenable: vm.messenger,
      builder: (_, messenger, __) {
        if (null == messenger) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Column(
            children: [
              AppBar(
                centerTitle: true,
                title: Text(
                  messenger.name,
                  style: const TextStyle(color: Colors.black),
                ),
                actions: [
                  // todo zrz 头像
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    ),
                  )
                ],
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                elevation: 0,
              ),
              Expanded(
                child: ValueListenableBuilder<List<_Message>?>(
                  valueListenable: vm.messages,
                  builder: (_, messages, __) {
                    if (null == messages) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (messages.isEmpty) {
                      return const Center(
                        child: Text("暂无消息"),
                      );
                    } else {
                      return Container(
                        color: Colors.grey[100],
                        child: ListView.separated(
                          controller: lvController,
                          reverse: true,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                          itemBuilder: (context, index) => buildMessageItem(index, messages[index]),
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(height: 24);
                          },
                          itemCount: messages.length,
                        ),
                      );
                    }
                  },
                ),
              )
            ],
          );
        }
      },
    );
  }

  ///收到新消息
  void onNewMessage() async {
    if ((vm.newMsg.value ?? 0) > 0) {
      //收到新消息自动滚动
      lvController.jumpTo(0);
    }
  }

  ///构建一个消息
  Widget buildMessageItem(int index, _Message item) {
    if (item.isReceived) {
      //收到的消息
      return buildReceivedMessageItem(item);
    } else {
      //发送的消息
      return buildSendMessageItem(item);
    }
  }

  ///收到的消息
  Widget buildReceivedMessageItem(_Message item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // todo zrz 头像
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: item.type == _MessageType.text
              ? Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(
                    item.text ?? "",
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              // todo zrz 模拟图片类型消息
              : Container(
                  color: Colors.blue,
                  width: 200,
                  height: 400,
                ),
        ),
      ],
    );
  }

  ///发送的消息
  Widget buildSendMessageItem(_Message item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: item.type == _MessageType.text
              ? Container(
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        item.text ?? "",
                        style: const TextStyle(color: Colors.white),
                      ),
                      //时间
                      Text(
                        DateTime.fromMillisecondsSinceEpoch(item.time).format2HHnn(),
                        style: const TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                )
              // todo zrz 模拟图片类型消息
              : Container(
                  color: Colors.blue,
                  width: 200,
                  height: 400,
                ),
        ),
        const SizedBox(width: 8),
        // todo zrz 头像
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(color: Colors.cyan, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
    vm.newMsg.removeListener(onNewMessage);
  }
}
// todo zrz 暂时定义到这里
///使用viewmodel管理状态
class _ViewMode {
  ValueNotifier<_Messenger?> messenger = ValueNotifier(null);
  ValueNotifier<List<_Message>?> messages = ValueNotifier(null);

  //收到新消息,用于列表自动滚动
  ValueNotifier<int?> newMsg = ValueNotifier(null);

  ///请求数据
  void fetchData() async {
    // todo zrz 模拟
    await Future.delayed(const Duration(seconds: 2));
    messenger.value = _Messenger("Ally", "https://host/avatar");
    //列表反转，消息按照时间倒序排列
    final msgs = [
      _Message(
        type: _MessageType.text,
        isReceived: false,
        avatar: "",
        time: DateTime.now().millisecondsSinceEpoch - 5 * 60 * 1000,
        text: "When the value is replaced with something that is not equal to the oldvalue as evaluated "
            "by the equality operator ==, this class notifies itslisteners.4",
      ),
      _Message(
        type: _MessageType.img,
        isReceived: true,
        avatar: "",
        imgUrl: "",
        time: DateTime.now().millisecondsSinceEpoch - 10 * 60 * 1000,
      ),
      _Message(
        type: _MessageType.text,
        isReceived: false,
        avatar: "",
        time: DateTime.now().millisecondsSinceEpoch - 15 * 60 * 1000,
        text: "When the value is replaced with something that is not equal to the oldvalue as evaluated "
            "by the equality operator ==, this class notifies itslisteners.2",
      ),
      _Message(
        type: _MessageType.text,
        isReceived: true,
        avatar: "",
        time: DateTime.now().millisecondsSinceEpoch - 20 * 60 * 1000,
        text: "When the value is replaced with something that is not equal to the oldvalue as evaluated "
            "by the equality operator ==, this class notifies itslisteners.1",
      ),
    ];
    messages.value = msgs;

    // todo zrz 模式收到新的消息
    while (true) {
      await Future.delayed(const Duration(seconds: 5));
      messages.value?.insert(
        0,
        _Message(
          type: _MessageType.text,
          isReceived: true,
          avatar: "",
          time: DateTime.now().millisecondsSinceEpoch,
          text: "这是新消息这是新消息这是新消息这是新消息这是新消息这是新消息这是新消息这是新消息",
        ),
      );
      messages.value = [...messages.value ?? []];
      newMsg.value = messages.value?.length;
    }
  }
}
// todo zrz 暂时定义到这里
///对话的对象
class _Messenger {
  final String name;
  final String avatar;

  _Messenger(this.name, this.avatar);
}
// todo zrz 暂时定义到这里
///消息体
class _Message {
  final _MessageType type;

  //是否为收到的消息
  final bool isReceived;
  final String? text;
  final String? imgUrl;

  //消息发送者的头像
  final String avatar;
  final int time;

  _Message(
      {required this.type, required this.isReceived, this.text, this.imgUrl, required this.avatar, required this.time});
}
// todo zrz 暂时定义到这里
///消息类型
enum _MessageType {
  text,
  img,
}
