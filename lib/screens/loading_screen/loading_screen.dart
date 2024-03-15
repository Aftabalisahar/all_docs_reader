import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_colors.dart';

class LoadingScreen extends StatefulWidget {
  final Function? toBeCalled;

  final Function? imagesList;

  // final Function? toBeCalled ;

  const LoadingScreen({super.key, this.toBeCalled, this.imagesList});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  callFunction() {
    widget.toBeCalled;
  }

  @override
  void initState() {
    callFunction();
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
          const SizedBox(width: double.infinity),
          CupertinoActivityIndicator(
            radius: 30.r,
            color: AppColors.mainColor,
          ),
          SizedBox(height: 30.h),
          Text(
            "Loading",
            style: TextStyle(
                color: AppColors.blackColor,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15.h),
          Text(
            "Please wait while we get the\nfile ready!",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: AppColors.blackColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}


