import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart' as path;
import 'package:document_viewer/document_viewer.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DocsViewerScreen extends StatefulWidget {
  final String fileName;

  final String filePath;

  const DocsViewerScreen(
      {super.key, required this.fileName, required this.filePath});

  @override
  State<DocsViewerScreen> createState() => _DocsViewerScreenState();
}

class _DocsViewerScreenState extends State<DocsViewerScreen> {
  String pdfFlePath = "";

  @override
  void initState() {
    loadPdf();
    // TODO: implement initState
    super.initState();
  }



  Future<String> downloadAndSavePdf() async {
    final directory = await getApplicationDocumentsDirectory();

    final file = File("${directory.path}/${widget.filePath.split("/").last}");
    File localFile = File(widget.filePath);
    Uint8List bytes = localFile.readAsBytesSync();
    file.writeAsBytesSync(bytes);
    return file.path;
  }



  Future<String?> loadPdf() async {
    pdfFlePath = await downloadAndSavePdf();
    setState(() {});
    return pdfFlePath;
  }

  @override
  Widget build(BuildContext context) {
    // print(pdfFlePath);
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: Text(widget.fileName)),
        body: Padding(
          padding: EdgeInsets.all(20.sp),
          child: FutureBuilder(
            future: loadPdf(),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? DocumentViewer(filePath: pdfFlePath)
                  : const Center(child: CircularProgressIndicator());
            },
          ),
        )
        // pdfFlePath == null
        //     ? const Center(
        //     child: CircularProgressIndicator())
        //     : DocumentViewer(filePath: pdfFlePath.toString()),
        );
  }
}
