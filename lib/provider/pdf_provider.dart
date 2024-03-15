import 'dart:io';
import 'package:all_docs_reader/provider/intro_provider.dart';
import 'package:all_docs_reader/screens/loading_screen/loading_screen.dart';
import 'package:all_docs_reader/screens/successful_screen/successfull_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';

class PDFProvider extends ChangeNotifier {
  Future<String> getDocumentDirectoryPath() async {
    final directory = Directory("/storage/emulated/0/Download/");
    return directory.path;
  }

  Future<String> convertImagesToPdf(List<String> imagePaths,BuildContext context) async {
    Get.to(()=> const LoadingScreen());
    // Create a new PDF document
    final pdf = pw.Document();

    // Add each image to the PDF document
    for (var path in imagePaths) {
      // Create a new instance of PdfImage for each image
      final pdfImage = pw.MemoryImage(File(path).readAsBytesSync());

      // Add the image to the PDF document page
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(pdfImage),
            );
          },
        ),
      );
    }

    // Get the document directory path
    final documentDirectory = await getDocumentDirectoryPath();

    // Generate a unique file name with the current time instance
    final currentTime = DateTime.now().toString().replaceAll(RegExp(r'[^0-9]'), '');
    final outputFileName = 'Pdf_$currentTime.pdf';

    // Output path for the PDF file
    final outputPath = '$documentDirectory/$outputFileName';

    // Save the PDF document to a file
    final file = File(outputPath);
    await file.writeAsBytes(await pdf.save());
    Provider.of<IntroProvider>(context,listen: false).requestPermission(context);
    Get.to(()=> SuccessScreen(filePath: outputPath,));
    return outputPath ;
  }
}