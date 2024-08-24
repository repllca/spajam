import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNavigationModel extends ChangeNotifier {
  int _currentIndex = 1; //最初に表示される画面

  // getterとsetterを指定しています
  // setのときにnotifyListeners()を呼ぶことアイコンタップと同時に画面を更新しています。
  int get currentIndex => _currentIndex;

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners(); // View側に変更を通知
  }
}
