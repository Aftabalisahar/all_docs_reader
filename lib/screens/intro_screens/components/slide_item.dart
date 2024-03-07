import 'package:all_docs_reader/utils/app_colors.dart';
import 'package:all_docs_reader/utils/app_images.dart';
import 'package:all_docs_reader/widgets/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/get_utils.dart';

import '../../../widgets/custom_elevated_button.dart';

class SlideItem extends StatelessWidget {
  final int index ;
  final Function onGetStarted ;

  const SlideItem({super.key, required this.index, required this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomImageView(
          height: index != 3 ? 200.h : 250.h,
          svgPath: index == 0
              ? AppImages.slideFirstIcon
              : index == 1
                  ? AppImages.slideSecondIcon
                  : index == 2
                      ? AppImages.slideThirdIcon
                      : AppImages.accessScreenIcon,
        ),
        SizedBox(
          height: 20.h,
        ),
        index != 3
            ? Text(
                index == 0
                    ? "All Document Reader and Viewer"
                    : index == 1
                        ? "It’s Time to Go Paperless!"
                        : "Scan & Convert to PDF Files",
                textAlign: TextAlign.center,
                style: context.textTheme.titleLarge!
                    .copyWith(fontWeight: FontWeight.bold))
            : const SizedBox.shrink(),
        SizedBox(
          height: 20.h,
        ),
        index != 3
            ? Text(
                index == 0
                    ? "Open and read all your files on mobile with All Document Reader"
                    : index == 1
                        ? "Easily open all files on your mobile"
                        : "Scan images and convert them to PDF files. Enjoy reading!",
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium!
                    .copyWith(color: AppColors.black100Color))
            : const SizedBox.shrink(),
        index == 3
            ? Wrap(
                children: [
                  Text("Allow",
                      style: context.textTheme.bodyMedium!
                          .copyWith(color: AppColors.black100Color)),
                  Text(" Document Reader & Viewer",
                      style: context.textTheme.labelLarge!
                          .copyWith(color: AppColors.black100Color)),
                  Text("to access your files and documents.",
                      style: context.textTheme.bodyMedium!
                          .copyWith(color: AppColors.black100Color)),
                ],
              )
            : const SizedBox.shrink(),
        index == 2 ? SizedBox(height: 20.h) : const SizedBox.shrink(),
        index == 2 || index == 3
            ? CustomElevatedButton(
                onPressed: () {
                  onGetStarted();
                },
                child: Text(index == 2 ? "Get Started" : "Allow Permission",
                    style: context.textTheme.bodyMedium!
                        .copyWith(color: AppColors.whiteColor)))
            : const SizedBox.shrink()
      ],
    );
  }
}
