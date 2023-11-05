/// Author: ruizhang
/// Date: 2023/11/5 16:23
/// Description: 一些拓展
extension IterableMapIndexed<E> on Iterable<E> {
  Iterable<R> mapIndexed<R>(R Function(int index, E) transform) sync* {
    var index = 0;
    for (final element in this) {
      yield transform(index++, element);
    }
  }
}

extension DateTimeExt on DateTime {
  String format2HHnn() {
    return "${this.hour}:${this.minute}";
  }
}
