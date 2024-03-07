import 'package:all_docs_reader/screens/docs_viewer_screen/docs_viewer_screen.dart';
import 'package:all_docs_reader/screens/docs_viewer_screen/excel_reader_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/custom_image_view.dart';
import '../../docs_viewer_screen/epub_viewer_screen.dart';

class FileItem extends StatelessWidget {
  final String name;
  final String filePath;
  final String details;

  final String type;

  const FileItem(
      {super.key,
      required this.name,
      required this.type,
      required this.details,
      required this.filePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        filePath.split("/").last.split(".").last.contains("epub")
            ? Get.to(
                () => EpubViewerScreen(filePath: filePath))
            : filePath.split("/").last.split(".").last.contains("xlx") ||
                    filePath.split("/").last.split(".").last.contains("xlsx")
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
                Text(details,
                    style: context.textTheme.bodySmall!
                        .copyWith(color: AppColors.black100Color)),
              ],
            ),
            Spacer(),
            IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.star)),
            IconButton(
                onPressed: () {},
                icon: CustomImageView(svgPath: AppImages.optionsIcon)),
          ],
        ),
      ),
    );
  }

  resizeName(String name) {
    return name.length > 25 ? "${name.substring(0, 25)}..." : name;
  }
}
