
import 'package:all_docs_reader/screens/home_screen/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';
import '../docs_viewer_screen/docs_viewer_screen.dart';

class SuccessScreen extends StatefulWidget {
  final String? filePath;

  // final Function? toBeCalled ;

  const SuccessScreen({super.key,this.filePath});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Get.to(() => const HomeScreen());
            },
            icon: Icon(
              CupertinoIcons.clear,
              size: 25.sp,
            )),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),

        backgroundColor: AppColors.mainColor,
        // centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: double.infinity),
          Icon(CupertinoIcons.checkmark_alt_circle_fill,
              color: AppColors.mainColor, size: 50.sp),
          SizedBox(height: 30.h),
          Text(
            "PDF saved successfully!",
            style: TextStyle(
                color: AppColors.blackColor,
                fontSize: 22.sp,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 15.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r))
                  ),
                  child: Text(" Share ",
                      style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w400))
              ),
              OutlinedButton(
                  onPressed: () {
                    Get.to(
                            () => DocsViewerScreen(fileName: "name", filePath: widget.filePath!));
                  },
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r))
                  ),
                  child: Text(" Open ",
                      style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w400))
              ),
            ],
          )

        ],
      ),
    );
  }
}