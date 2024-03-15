import 'package:hive/hive.dart';

part 'favorites_db.g.dart';

@HiveType(typeId: 0)
class Favorite {
  @HiveField(0)
  List<String> favorites = [];

  // Method to add a value to the map with a custom key
  void addFavorites(String path) {
    favorites.add(path);
  }
  void removeFavorite(String path) {
    favorites.remove(path);
  }

  containsFavorite(String path){
    if(favorites.contains(path)){
      return true ;
    }else {
      return false ;
    }
  }

  // dynamic getDetailByKey(String key) {
  //   return imagesPaths[key];
  // }
  List<String> getAllFavorites() {
    return List.from(favorites);
  }
}
