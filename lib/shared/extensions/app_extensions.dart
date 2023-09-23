extension CustomList<T> on List {
  bool _even() {
    return length % 2 == 0;
  }

  bool _onlyOneElement() {
    return length == 1;
  }

  bool get isEvent => _even();
  bool get hasOnlyOne => _onlyOneElement();
}

extension CustomData<T> on String {
  DateTime get toDateTime {
    return DateTime.parse(replaceAll('/', '-'));
  }
}