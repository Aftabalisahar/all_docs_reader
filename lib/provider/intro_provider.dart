import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class IntroProvider extends ChangeNotifier {

  int index = 0 ;
   updateIndex(int updatedIndex){
     index = updatedIndex ;
     notifyListeners();
   }
   Future<bool> requestPermission() async {
    PermissionStatus permissionStatus;
    String androidVersion = await getAndroidVersion();
    if (int.parse(androidVersion) <= 12) {
      permissionStatus = await Permission.storage.request();
    } else {
      permissionStatus = await Permission.photos.request();
    }

    if (permissionStatus == PermissionStatus.granted) {
      // Permission granted
      return true;
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      // Permission permanently denied, open settings
      openAppSettings();
      return false;
    } else {
      Fluttertoast.showToast(msg: "Permission Denied");
      // Permission denied
      return false;
    }
  }

  static Future<String> getAndroidVersion() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo;

    try {
      androidInfo = await deviceInfo.androidInfo;
      String version = androidInfo.version.release; // Android version
      print('Android Version: $version');
      return version;
    } catch (e) {
      print('Failed to get Android version: $e');
      return "";
    }
  }
}