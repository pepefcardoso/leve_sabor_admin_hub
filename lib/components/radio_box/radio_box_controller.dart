import 'package:flutter/material.dart';

class RadioBoxController<T> extends ChangeNotifier {
  T? _item;

  RadioBoxController(
    this._item,
  );

  T? get item => _item;

  set item(T? item) {
    _item = item;
    notifyListeners();
  }

  void limpar() {
    _item = null;
    notifyListeners();
  }
}
