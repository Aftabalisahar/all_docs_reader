import 'package:flutter/widgets.dart';

class BottomNavigationProvider extends ChangeNotifier {
  int index = 0 ;
  updateIndex(int updatedIndex){
    index = updatedIndex ;
    notifyListeners();
  }
}