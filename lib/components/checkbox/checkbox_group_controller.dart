import 'package:flutter/cupertino.dart';

class CheckboxGroupController<T> extends ChangeNotifier {
  late final List<T> _groupItems;

  CheckboxGroupController({
    List<T>? groupItems,
  }) : _groupItems = [if (groupItems != null) ...groupItems];

  List<T> get groupItems => _groupItems;

  void add(T item) {
    _groupItems.add(item);
    notifyListeners();
  }

  void addAll(List<T> items) {
    _groupItems.addAll(items);
    notifyListeners();
  }

  void removeAndAddAll(List<T> items) {
    _groupItems
      ..clear()
      ..addAll(items);
    notifyListeners();
  }

  void remove(T item) {
    _groupItems.remove(item);
    notifyListeners();
  }

  void clear() {
    _groupItems.clear();
    notifyListeners();
  }
}
