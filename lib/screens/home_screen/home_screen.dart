import 'package:all_docs_reader/screens/home_screen/components/home_grid_item.dart';
import 'package:all_docs_reader/services/file_provider_service.dart';
import 'package:all_docs_reader/utils/app_colors.dart';
import 'package:all_docs_reader/utils/app_images.dart';
import 'package:all_docs_reader/widgets/custom_image_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../provider/bottom_nav_provider.dart';
import '../files_list_screen/files_list_screen.dart';
import 'components/tools_grid_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    FileProviderService fileProviderService = FileProviderService();
    fileProviderService.handlePermission(context);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              CupertinoIcons.globe,
              color: AppColors.whiteColor,
              size: 25.sp,
            )),
        centerTitle: true,
        title: Text("Home",
            style: context.textTheme.bodyMedium!
                .copyWith(color: AppColors.whiteColor, fontSize: 20.sp)),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => const FilesListScreen(
                      title: "Favorites",
                    ));
              },
              icon: Icon(CupertinoIcons.star_fill,
                  size: 25.sp, color: AppColors.yellow0Color)),
          IconButton(
              onPressed: () {},
              icon: CustomImageView(svgPath: AppImages.crownIcon)),
        ],
      ),
      body: Consumer<BottomNavigationProvider>(
        builder: (context, bottomNavigationProvider, child) => Column(
          children: [
            bottomNavigationProvider.index == 0
                ? Expanded(
                    child: GridView.builder(
                    padding: EdgeInsets.all(40.sp),
                    itemCount: 7,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20.h,
                        crossAxisSpacing: 30.w),
                    itemBuilder: (context, index) => HomeGridItem(index: index),
                  ))
                : bottomNavigationProvider.index == 1
                    ? Expanded(
                        child: GridView.builder(
                        padding: EdgeInsets.all(40.sp),
                        itemCount: 5,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 20.h,
                            crossAxisSpacing: 30.w),
                        itemBuilder: (context, index) =>
                            ToolsGridItem(index: index),
                      ))
                    : Expanded(
                        child: ListView.builder(
                          itemCount: 4,
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: Row(
                            children: [
                              CustomImageView(
                                svgPath: index == 0 ? AppImages.rateUsIcon : index == 1 ? AppImages.guideIcon : index == 2 ? AppImages.privacyIcon : AppImages.shareIcon,
                                height: 25.h,
                                margin: EdgeInsets.symmetric(horizontal: 30.sp),
                              ),
                              Text(index == 0 ? "Rate Us" : index == 1 ? "Guide" : index == 2 ? "Privacy" : "Share",
                                  textAlign: TextAlign.center,
                                  style: context.textTheme.bodyLarge!.copyWith(
                                      color: AppColors.blackColor,
                                      fontSize: 18.sp)),
                            ],
                          ),
                        ),
                      )),
          ],
        ),
      ),
      bottomNavigationBar: Consumer<BottomNavigationProvider>(
        builder: (context, bottomNavigationProvider, child) =>
            BottomNavigationBar(
                backgroundColor: AppColors.mainColor,
                currentIndex: bottomNavigationProvider.index,
                onTap: (value) {
                  bottomNavigationProvider.updateIndex(value);
                },
                selectedIconTheme: IconThemeData(color: AppColors.whiteColor),
                unselectedIconTheme:
                    IconThemeData(color: AppColors.white50Color),
                items: [
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.home), label: ""),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.square_grid_2x2), label: ""),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.settings), label: ""),
            ]),
      ),
    );
  }
}
