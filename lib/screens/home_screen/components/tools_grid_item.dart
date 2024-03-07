import 'package:all_docs_reader/provider/files_service_provider.dart';
import 'package:all_docs_reader/screens/files_list_screen/files_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/custom_image_view.dart';

class ToolsGridItem extends StatelessWidget {
  final int index;

  const ToolsGridItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Get.to(() => FilesListScreen(
        //     title: index == 0
        //         ? "Scan Pdf"
        //         : index == 1
        //             ? "Scan Word"
        //             : index == 2
        //                 ? "Merge Pdf"
        //                 : index == 3
        //                     ? "Split Pdf"
        //                     : index == 4
        //                         ? "Compress Pdf"
        //                         : ""));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 30.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: Colors.grey)),
        child: Column(
          children: [
            CustomImageView(
              svgPath: index == 0
                  ? AppImages.scanPdfIcon
                  : index == 1
                      ? AppImages.scanWordIcon
                      : index == 2
                          ? AppImages.mergePdfIcon
                          : index == 3
                              ? AppImages.splitPdfIcon
                              : AppImages.compressPdfIcon,
              height: 50.h,
            ),
            SizedBox(height: 10.h),
            Consumer<FilesServiceProvider>(
              builder: (context, filesServiceProvider, child) => Text(
                  index == 0
                      ? "Scan Pdf"
                      : index == 1
                      ? "Scan Word"
                      : index == 2
                      ? "Merge Pdf"
                      : index == 3
                      ? "Split Pdf"
                      : index == 4
                      ? "Compress Pdf"
                      : "",
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyMedium!
                      .copyWith(color: AppColors.black100Color)),
            ),
          ],
        ),
      ),
    );
  }
}
