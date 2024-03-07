import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../provider/files_service_provider.dart';

class FileProviderService {
  List<String> pdfFiles = [];
  List<String> docsFiles = [];
  List<String> pptFiles = [];
  List<String> txtFiles = [];
  List<String> excelFiles = [];
  List<String> epubFiles = [];

  handlePermission(BuildContext context) async {
    PermissionStatus permissionStatus;
    if (Platform.isAndroid) {
      String androidVersion = await getAndroidVersion();
      if (int.parse(androidVersion) <= 12) {
        permissionStatus = await Permission.storage.request();
      } else {
        permissionStatus = await Permission.photos.request();
      }
    } else if (Platform.isIOS) {
      permissionStatus = await Permission.photos.request();
    } else {
      // Handle other platforms if needed
      return false;
    }

    if (permissionStatus == PermissionStatus.granted) {
      // Permission granted
      selectDirectory(context);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      // Permission permanently denied, open settings
      openAppSettings();
    } else {
      // Permission denied
      Fluttertoast.showToast(msg: "Permission Denied");
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

  selectDirectory(BuildContext context) async {
    pdfFiles = await listFilesByExtension('.pdf');
    docsFiles = await listFilesByExtension('.docx');
    pptFiles = await listFilesByExtension('.ppt');
    txtFiles = await listFilesByExtension('.txt');
    excelFiles = await listFilesByExtension('.xlsx');
    epubFiles = await listFilesByExtension('.epub');
    Provider.of<FilesServiceProvider>(context, listen: false).fetchAllData(
        pdfFiles, docsFiles, pptFiles, txtFiles, excelFiles, epubFiles);
  }

  Future<List<String>> listFilesByExtension(String extension) async {
    List<String> filesList = [];
    try {
      // Get the directory where files might be located
      Directory dir = Directory("/storage/emulated/0/");

      // List all files in the directory
      List<FileSystemEntity> files = dir.listSync(recursive: true);

      // Filter files by extension
      for (var file in files) {
        if (file.path.toLowerCase().endsWith(extension)) {
          filesList.add(file.path);
        }
      }
    } catch (e) {
      print('Error while listing $extension files: $e');
    }
    return filesList;
  }
  


  
}
