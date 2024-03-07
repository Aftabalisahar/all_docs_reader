import 'dart:io';

import 'package:flutter/material.dart';

class FilesServiceProvider extends ChangeNotifier {
  List<String> pdfFiles = [];
  List<String> docsFiles = [];
  List<String> pptFiles = [];
  List<String> txtFiles = [];
  List<String> excelFiles = [];
  List<String> epubFiles = [];

  Future<void> fetchAllData(
      List<String> pdfFiles,
      List<String> docsFiles,
      List<String> pptFiles,
      List<String> txtFiles,
      List<String> excelFiles,
      List<String> epubFiles) async {
    this.pdfFiles = pdfFiles;
    this.docsFiles = docsFiles;
    this.pptFiles = pptFiles;
    this.excelFiles = excelFiles;
    this.txtFiles = txtFiles;
    this.epubFiles = epubFiles;
    notifyListeners();
  }

  int getCountAllFiles() {
    return pdfFiles.length +
        docsFiles.length +
        pptFiles.length +
        excelFiles.length +
        txtFiles.length +
        epubFiles.length;
  }

  getCurrentItemAt(int index, String type) {
    List files = getCurrentList(type);
    return files[index];

  }

  List<String> getCurrentList(String type) {
    return type.contains("All Files")
        ? getAllFilesList()
        : type.contains("Pdf Files")
            ? pdfFiles
            : type.contains("Docs/Word Files")
                ? docsFiles
                : type.contains("PPT Files")
                    ? pptFiles
                    : type.contains("Text Files")
                        ? txtFiles
                        : type.contains("Excel Files")
                            ? excelFiles
                            : epubFiles;
  }

  getAllFilesList() {
    List<String> allFiles = [];
    allFiles.addAll(pdfFiles);
    allFiles.addAll(docsFiles);
    allFiles.addAll(pptFiles);
    allFiles.addAll(excelFiles);
    allFiles.addAll(epubFiles);
    allFiles.addAll(txtFiles);
    return allFiles;
  }

  getPathEndsWith(String type, int index) {
    String path = getCurrentItemAt(index, type);
    return path.split("/").last.split(".").last;
  }

  getFileName(String type, int index) {
    String path = getCurrentItemAt(index, type);
    return path.split("/").last.split(".").first;
  }

  getFileDetails(String type, int index) {
    String path = getCurrentItemAt(index, type);
    File file = File(path);
    final date = file.lastModifiedSync();
    final length = file.lengthSync();
    return "${calculateKBs(length)} , ${date.day}-${date.month}-${date.year} ";
  }
  
  calculateKBs(int size){
    if(size > 1024){
      return "${(size / 1024).toStringAsFixed(2)}KB";
    }

  }

}
