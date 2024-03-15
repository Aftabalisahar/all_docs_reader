import 'dart:io';

import 'package:all_docs_reader/provider/pdf_provider.dart';
import 'package:all_docs_reader/provider/selected_images_provider.dart';
import 'package:all_docs_reader/screens/loading_screen/loading_screen.dart';
import 'package:all_docs_reader/widgets/custom_elevated_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../utils/app_colors.dart';
import '../image_preview_screen/image_preview_screen.dart';

class SelectedImagesScreen extends StatefulWidget {
  const SelectedImagesScreen({super.key});

  @override
  State<SelectedImagesScreen> createState() => _SelectedImagesScreenState();
}

class _SelectedImagesScreenState extends State<SelectedImagesScreen> {
  PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              CupertinoIcons.back,
              size: 25.sp,
            )),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
        title: Text(
          "To Pdf",
          style: TextStyle(
              color: AppColors.whiteColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w400),
        ),

        backgroundColor: AppColors.mainColor,
        // centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10.h),
          Consumer<SelectedImagesProvider>(
              builder: (context, selectedImagesProvider, child) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              pageController.animateToPage(
                                  selectedImagesProvider.imageIndex - 1,
                                  duration: Duration(milliseconds: 100),
                                  curve: Curves.decelerate);
                              // selectedImagesProvider.slideImage();
                            },
                            icon: Icon(CupertinoIcons.back)),
                        SizedBox(
                          height: 500.h,
                          width: MediaQuery.of(context).size.width - 100,
                          child: PageView(
                            onPageChanged: (value) {
                              selectedImagesProvider.updateIndex(value);
                            },
                            controller: pageController,
                            children: List.generate(
                                selectedImagesProvider.selectedImages.length,
                                (index) => Image.file(
                                    fit: BoxFit.contain,
                                    File(selectedImagesProvider
                                        .selectedImages[index]))),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              pageController.animateToPage(
                                  selectedImagesProvider.imageIndex + 1,
                                  duration: Duration(milliseconds: 100),
                                  curve: Curves.decelerate);
                            },
                            icon: Icon(CupertinoIcons.forward)),
                      ])),
          Consumer<SelectedImagesProvider>(
            builder: (context, selectedImagesProvider, child) => Text(
                "${selectedImagesProvider.imageIndex + 1}/${selectedImagesProvider.selectedImages.length}",
                style: TextStyle(
                    color: AppColors.black100Color,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400)),
          ),
          SizedBox(height: 20.h),
          CustomElevatedButton(
            child: Text(
              "Add More Images",
              style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600),
            ),
            onPressed: () {
              pickImage().then(
                  (value) => Get.to(() => ImagePreviewScreen(path: value!)));
            },
          ),
          SizedBox(height: 10.h),
          Consumer<SelectedImagesProvider>(
            builder: (context, selectedImagesProvider, child) => CustomElevatedButton(
              child: Text(
                "Export To PDF",
                style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                Provider.of<PDFProvider>(context,listen: false).convertImagesToPdf(selectedImagesProvider.selectedImages, context);
              },
            ),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Future<String?> pickImage() async {
    ImagePicker picker = ImagePicker();
    final path = picker
        .pickImage(source: ImageSource.gallery)
        .then((value) => value?.path);
    return path;
  }
}
