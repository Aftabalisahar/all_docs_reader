import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';

import '../main.dart';
import '../services/db_service/favorites_db.dart';

class FavoritesProvider extends ChangeNotifier {
  List<String> favorites = [];

  Future<void> addFavorite(String path) async {
    try {
      // Check if the favorites box contains the 'favorites' key
      if (favoritesBox.containsKey("favorites")) {
        Favorite favoriteImage = favoritesBox.get("favorites");

        if (favoriteImage.containsFavorite(path)) {
          favoriteImage.removeFavorite(path);
          favoritesBox.put("favorites", favoriteImage);
          Fluttertoast.showToast(msg: "Removed from Favorites");
        } else {
          favoriteImage.addFavorites(path);
          favoritesBox.put("favorites", favoriteImage);
          Fluttertoast.showToast(msg: "Added to Favorites");
        }
      } else {
        Favorite favoriteImage = Favorite();
        favoriteImage.addFavorites(path);
        favoritesBox.put("favorites", favoriteImage);
        Fluttertoast.showToast(msg: "Added to Favorites");
      }

      await getAllFavorites();
    } catch (e) {
      print("Error adding to favorites: $e");
      Fluttertoast.showToast(msg: "Error adding to Favorites");
    }
  }



  Future<void> removeFavorite(String path) async {
    try {
      if (favoritesBox.containsKey("favorites")) {
        Favorite favoriteImage = favoritesBox.get("favorites");
        favoriteImage.removeFavorite(path);
        favoritesBox.put("favorites", favoriteImage);
      }
      Fluttertoast.showToast(msg: "Removed from Favorites");
      await getAllFavorites();
    } catch (e) {
      print("Error removing from favorites: $e");
      Fluttertoast.showToast(msg: "Error removing from Favorites");
    }
  }

  Future<List> getAllFavorites() async {
    try {
      if (favoritesBox.containsKey("favorites")) {
        Favorite favoriteImage = favoritesBox.get("favorites");
        favorites = favoriteImage.getAllFavorites();
        print("Favorites: $favorites");
        notifyListeners();
        return favorites ;
      } else {
        favorites = [];
        notifyListeners();
        return favorites ;
      }
    } catch (e) {
      print("Error getting favorites: $e");
      favorites = [];
    }
    return favorites ;
  }
}
