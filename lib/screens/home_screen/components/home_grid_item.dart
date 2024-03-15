import 'package:all_docs_reader/provider/files_service_provider.dart';
import 'package:all_docs_reader/screens/files_list_screen/files_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/custom_image_view.dart';

class HomeGridItem extends StatelessWidget {
  final int index;

  const HomeGridItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => FilesListScreen(
            title: index == 0
                ? "All Files"
                : index == 1
                    ? "Pdf Files"
                    : index == 2
                        ? "Docs/Word Files"
                        : index == 3
                            ? "PPT Files"
                            : index == 4
                                ? "Text Files"
                                : index == 5
                                    ? "Excel Files"
                                    : "EPUB Files"));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 25.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: Colors.grey)),
        child: Column(
          children: [
            CustomImageView(
              svgPath: index == 0
                  ? AppImages.allFilesIcon
                  : index == 1
                      ? AppImages.pdfIcon
                      : index == 2
                          ? AppImages.wordIcon
                          : index == 3
                              ? AppImages.pptIcon
                              : index == 4
                                  ? AppImages.textIcon
                                  : index == 5
                                      ? AppImages.xlIcon
                                      : AppImages.epubIcon,
              height: 50.h,
            ),
            SizedBox(height: 10.h),
            Consumer<FilesServiceProvider>(
              builder: (context, filesServiceProvider, child) => Text(
                  index == 0
                      ? "All Files\n(${filesServiceProvider.getCountAllFiles()})"
                      : index == 1
                          ? "Pdf Files\n(${filesServiceProvider.pdfFiles.length})"
                          : index == 2
                              ? "Docs/Word\nFiles (${filesServiceProvider.docsFiles.length})"
                              : index == 3
                                  ? "PPT Files\n(${filesServiceProvider.pptFiles.length})"
                                  : index == 4
                                      ? "Text Files\n(${filesServiceProvider.txtFiles.length})"
                                      : index == 5
                                          ? "Excel Files\n(${filesServiceProvider.excelFiles.length})"
                                          : "EPUB Files\n(${filesServiceProvider.epubFiles.length})",
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
