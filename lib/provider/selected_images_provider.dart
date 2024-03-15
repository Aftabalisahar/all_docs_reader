import 'package:flutter/material.dart';

class SelectedImagesProvider extends ChangeNotifier {
  List<String> selectedImages = [
  ];
  int imageIndex = 0 ;

  addMoreImages(List<String> images){
    selectedImages.addAll(images);
    notifyListeners();
  }

  slideImage(){
    imageIndex > 0 ? imageIndex-- : imageIndex < selectedImages.length ? imageIndex++ : imageIndex --;
  }

  void updateIndex(int value) {
    imageIndex = value ;
    notifyListeners();
  }

}