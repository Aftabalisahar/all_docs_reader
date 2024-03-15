import 'dart:io';
import 'dart:typed_data';

import 'package:all_docs_reader/provider/selected_images_provider.dart';
import 'package:all_docs_reader/screens/image_preview_screen/image_rotation_screen.dart';
import 'package:all_docs_reader/screens/selected_images_screen/selected_images_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_crop_plus/image_crop_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../utils/app_colors.dart';
import '../../widgets/custom_elevated_button.dart';

class ImagePreviewScreen extends StatefulWidget {
  final String path;

  const ImagePreviewScreen({super.key, required this.path});

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {


  File? sampleFile ;
  File? file ;
  final cropKey = GlobalKey<CropState>();

  Uint8List getImageData() {
    File file = File(widget.path);
    return file.readAsBytesSync();
  }

  @override
  void initState() {
    sampleFile = File(widget.path);
    file = File(widget.path);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              CupertinoIcons.back,
              size: 25.sp,
            )),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
        title: Text(
          "Adjust",
          style: TextStyle(
              color: AppColors.whiteColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w400),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Consumer<SelectedImagesProvider>(
              builder: (context, selectedImagesProvider, child) => GestureDetector(
                onTap: () {
                  _cropImage().then((value) {
                    selectedImagesProvider.addMoreImages([value]);
                    Get.to(()=> SelectedImagesScreen());
                  });

                },
                child: Text(
                  "Next",
                  style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          )
        ],
        backgroundColor: AppColors.mainColor,
        // centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20.sp),
              child: Container(
                padding: EdgeInsets.all(1.sp),
                color: Colors.black,
                child: Crop.file(
                  sampleFile!,
                  key: cropKey,
                ),
              ),
            ),
          ),

          Container(
            color: AppColors.mainColor,
            padding: EdgeInsets.all(10.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Column(
                    children: [
                      Icon(Icons.camera_rounded,
                          color: AppColors.whiteColor, size: 30.sp),
                      Text(
                        "Retake",
                        style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    deleteDialog(context);
                  },
                  child: Column(
                    children: [
                      Icon(CupertinoIcons.delete,
                          color: AppColors.whiteColor, size: 30.sp),
                      Text(
                        "Delete",
                        style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async{
                    _cropImage().then((value) {
                      Get.to(()=> ImageRotationScreen(path: value));
                    });
                  },
                  child: Column(
                    children: [
                      Icon(Icons.rotate_left,
                          color: AppColors.whiteColor, size: 30.sp),
                      Text(
                        "Rotate",
                        style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  deleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Are you sure you want to delete this image ?",
              textAlign: TextAlign.center,
              style: context.textTheme.labelLarge!.copyWith(
                color: AppColors.blackColor,
                fontWeight: FontWeight.w500,
                fontSize: 15.sp,
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white50Color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    "Cancel",
                    style: context.textTheme.labelLarge!.copyWith(
                      color: AppColors.blackColor,
                      fontSize: 13.sp,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CustomElevatedButton(
                  child: Text(
                    "  Yes  ",
                    style: context.textTheme.labelLarge!.copyWith(
                      color: AppColors.whiteColor,
                      fontSize: 13.sp,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<String> _cropImage() async {
    final scale = cropKey.currentState!.scale;
    final area = cropKey.currentState!.area;
    if (area == null) {
      // cannot crop, widget is not setup
      return "";
    }

    // scale up to use maximum possible number of pixels
    // this will sample image in higher resolution to make cropped image larger
    final sample = await ImageCrop.sampleImage(
      file: this.file!,
      preferredSize: (2000 / scale).round(),
    );

    final file = await ImageCrop.cropImage(
      file: sample,
      area: area,
    );


    return file.path ;
    debugPrint('$file');
    // sample.delete();
    // sampleFile?.delete();
    // this.file!.delete();
  }

}
