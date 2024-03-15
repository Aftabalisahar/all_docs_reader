import 'package:flutter/services.dart';

class FileLister {
  static const MethodChannel _channel = MethodChannel('file_lister');

  static Future<List<String>> listFilesByExtension(String extension) async {
    try {
      final List<String> filesList = await _channel.invokeMethod('listFilesByExtension', extension);
      return filesList;
    } on PlatformException catch (e) {
      print("Error: '${e.message}'.");
      return [];
    }
  }
}
