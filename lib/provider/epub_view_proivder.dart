import 'package:flutter/material.dart';

class EpubViewProvider extends ChangeNotifier {
  int currentIndex = 0 ;
  updateIndex(int? index){
    currentIndex = index ?? 0 ;
    notifyListeners();
  }
}