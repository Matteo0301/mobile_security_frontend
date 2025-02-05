import 'dart:collection';

import 'package:flutter/material.dart';

class Model<T> extends ChangeNotifier {
  final List<T> _items = [];

  UnmodifiableListView<T> get items => UnmodifiableListView(_items);

  void add(T item) {
    _items.add(item);
  }

  void removeAll() {
    _items.clear();
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
