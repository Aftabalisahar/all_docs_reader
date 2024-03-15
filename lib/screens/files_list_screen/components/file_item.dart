import 'dart:io';

import 'package:all_docs_reader/provider/favorites_provider.dart';
import 'package:all_docs_reader/provider/files_service_provider.dart';
import 'package:all_docs_reader/screens/docs_viewer_screen/docs_viewer_screen.dart';
import 'package:all_docs_reader/screens/docs_viewer_screen/excel_reader_screen.dart';
import 'package:all_docs_reader/services/file_provider_service.dart';
import 'package:all_docs_reader/widgets/custom_elevated_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/custom_image_view.dart';
import '../../docs_viewer_screen/epub_viewer_screen.dart';

class FileItem extends StatelessWidget {
  final String name;
  final String filePath;
  final String details;
  final bool isFavorite;

  final String type;
  final Function onFavChanged;

  const FileItem({super.key,
    required this.name,
    required this.type,
    required this.details,
    required this.filePath,
    required this.isFavorite,
    required this.onFavChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        filePath
            .split("/")
            .last
            .split(".")
            .last
            .contains("epub")
            ? Get.to(() => EpubViewerScreen(filePath: filePath))
            : filePath
            .split("/")
            .last
            .split(".")
            .last
            .contains("xlx") ||
            filePath
                .split("/")
                .last
                .split(".")
                .last
                .contains("xlsx")
            ? Get.to(
                () => ExcelReaderScreen(fileName: name, filePath: filePath))
            : Get.to(
                () => DocsViewerScreen(fileName: name, filePath: filePath));
      },
      child: Container(
        padding: EdgeInsets.all(10.sp),
        child: Row(
          children: [
            CustomImageView(
              svgPath: type.contains("pdf")
                  ? AppImages.pdfIcon
                  : type.contains("docx")
                  ? AppImages.wordIcon
                  : type.contains("ppt")
                  ? AppImages.pptIcon
                  : type.contains("txt")
                  ? AppImages.textIcon
                  : type.contains("xlsx")
                  ? AppImages.xlIcon
                  : AppImages.epubIcon,
              height: 70.h,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(resizeName(name),
                    style: context.textTheme.bodySmall!.copyWith(
                        color: AppColors.blackColor, fontSize: 12.sp)),
                Text("${calculateSize(filePath)}  ${getFileDetails(true, filePath)}",
                    style: context.textTheme.bodySmall!
                        .copyWith(color: AppColors.black100Color)),
              ],
            ),
            Spacer(),
            Consumer<FavoritesProvider>(
              builder: (context, favoritesProvider, child) =>
                  IconButton(
                      onPressed: () {
                        favoritesProvider.addFavorite(filePath);
                        onFavChanged();
                      },
                      icon: !isFavorite
                          ? Icon(CupertinoIcons.star)
                          : Icon(
                        CupertinoIcons.star_fill,
                        color: AppColors.mainColor,
                      )),
            ),
            IconButton(
                onPressed: () {
                  showOptionDialog(context);
                },
                icon: CustomImageView(svgPath: AppImages.optionsIcon)),
          ],
        ),
      ),
    );
  }

  resizeName(String name) {
    return name.length > 25 ? "${name.substring(0, 25)}..." : name;
  }

  showOptionDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(resizeName(name),
                          style: context.textTheme.labelLarge!.copyWith(
                              color: AppColors.blackColor, fontSize: 14.sp)),
                      Spacer(),
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(Icons.close))
                    ],
                  ),
                  Column(
                      children: List.generate(
                          4,
                              (index) =>
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  index == 0 ? goTo() : index == 1 ?  renameDialog(
                                      context, filePath) : index == 2 ? shareFile(filePath) : showInfoDialog(context);
                                },
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.all(20.sp),
                                  decoration: const BoxDecoration(
                                      border: BorderDirectional(
                                          top: BorderSide(color: Colors.grey))),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomImageView(
                                        height: 18.h,
                                        width: 18.w,
                                        margin: EdgeInsets.only(right: 10.w),
                                        svgPath: index == 0
                                            ? AppImages.readFileIcon
                                            : index == 1
                                            ? AppImages.renameFileIcon
                                            : index == 2
                                            ? AppImages.shareFileIcon
                                            : AppImages.infoFileIcon,
                                      ),
                                      Text(
                                          index == 0
                                              ? "Read"
                                              : index == 1
                                              ? "Rename"
                                              : index == 2
                                              ? "Share"
                                              : "Info",
                                          style: context.textTheme.labelLarge!
                                              .copyWith(
                                              color: AppColors.blackColor,
                                              fontSize: 13.sp)),
                                    ],
                                  ),
                                ),
                              ))),
                ],
              ),
            ));
  }
  showInfoDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(Icons.close)),
                  ),
                  Column(
                      children: List.generate(
                          5,
                              (index) => index == 0 ? Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("File Information",
                                    style: context.textTheme.labelLarge!.copyWith(
                                        color: AppColors.blackColor, fontSize: 14.sp)),
                              ) :
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.all(20.sp),
                                decoration: const BoxDecoration(
                                    border: BorderDirectional(
                                        top: BorderSide(color: Colors.grey))),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        index == 1
                                            ? "File Name :"
                                            : index == 2
                                            ? "File Path :"
                                            : index == 3
                                            ? "Last Modification Date :"
                                            : "Size :",
                                        style: context.textTheme.labelLarge!
                                            .copyWith(
                                            color: AppColors.blackColor,
                                            fontSize: 13.sp)),
                                    Text(
                                        index == 1
                                            ? name
                                            : index == 2
                                            ? filePath
                                            : index == 3
                                            ? getFileDetails(true, filePath)
                                            : calculateSize(filePath),
                                        style: context.textTheme.labelMedium!
                                            .copyWith(
                                          fontWeight: FontWeight.w400,
                                            color: AppColors.black100Color,
                                            fontSize: 12.sp)),
                                  ],
                                ),
                              ))),
                ],
              ),
            ));
  }

  goTo() {
    filePath
        .split("/")
        .last
        .split(".")
        .last
        .contains("epub")
        ? Get.to(() => EpubViewerScreen(filePath: filePath))
        : filePath
        .split("/")
        .last
        .split(".")
        .last
        .contains("xlx") ||
        filePath
            .split("/")
            .last
            .split(".")
            .last
            .contains("xlsx")
        ? Get.to(
            () => ExcelReaderScreen(fileName: name, filePath: filePath))
        : Get.to(
            () => DocsViewerScreen(fileName: name, filePath: filePath));
  }
  
  shareFile(String path){
    Share.shareXFiles([XFile(path)]);
  }
  
  
  
  renameDialog(BuildContext context, String filePath) {
    TextEditingController controller = TextEditingController(text: name);
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Rename",
                  style: context.textTheme.labelLarge!.copyWith(
                    color: AppColors.blackColor,
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(height: 10.h),
                TextField(
                  controller: controller,
                  style: context.textTheme.bodySmall!.copyWith(
                    color: AppColors.blackColor,
                    fontSize: 13.sp,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(5.sp),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
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
                        "  OK  ",
                        style: context.textTheme.labelLarge!.copyWith(
                          color: AppColors.whiteColor,
                          fontSize: 13.sp,
                        ),
                      ),
                      onPressed: () {
                        String extension = filePath.split("/").last.split(".").last;
                        print(extension);
                        String dir = filePath.replaceAll(".$extension", "");
                        print(dir);
                        // Rename the file
                        try {
                          File originalFile = File(filePath);
                          if (originalFile.existsSync()) {

                            // originalFile.rename(filePath).then((value) {
                            //     print(value.path);
                            // Navigator.pop(context);
                            // FileProviderService().selectDirectory(context);});

                        } else {
                        print("Original file does not exist.");
                        // Handle accordingly, show message, etc.
                        }
                        } catch (e) {
                        print("Error renaming file: $e");
                        // Handle error, show message, etc.
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
    );
  }


  getFileDetails(bool isDate,String path){
    File file = File(path);
    if(isDate){
      DateTime dateTime = file.lastModifiedSync();
      return "${dateTime.day}/${dateTime.month}/${dateTime.year} - ${dateTime.hour} : ${dateTime.minute}" ;
    }else {
      calculateSize(path);
    }
  }

  String calculateSize(String path) {
    File file = File(path);
    if (!file.existsSync()) {
      return 'File not found';
    }

    int bytes = file.lengthSync();
    double kilobytes = bytes / 1024;
    double megabytes = kilobytes / 1024;
    double gigabytes = megabytes / 1024;

    if (gigabytes >= 1) {
      return '${gigabytes.toStringAsFixed(2)} GB';
    } else if (megabytes >= 1) {
      return '${megabytes.toStringAsFixed(2)} MB';
    } else if (kilobytes >= 1) {
      return '${kilobytes.toStringAsFixed(2)} KB';
    } else {
      return '$bytes bytes';
    }
  }
}
