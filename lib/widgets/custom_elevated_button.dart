import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../utils/app_colors.dart';

class CustomElevatedButton extends StatelessWidget {
  final Widget child ;
  final ButtonStyle? style ;
  final Function()? onPressed ;
  const CustomElevatedButton({super.key, required this.child, required this.onPressed, this.style});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed,
        style: style ?? ElevatedButton.styleFrom(
          backgroundColor: AppColors.mainColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r))
        ),
        child: child);
  }
}
