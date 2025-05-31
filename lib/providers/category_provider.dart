import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  String _selected = '전체';

  String get selected => _selected;

  void select(String category) {
    if (_selected != category) {
      _selected = category;
      notifyListeners(); // 구독자들에게 알림 보내기!
    }
  }
}