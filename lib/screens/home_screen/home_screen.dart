import 'package:all_docs_reader/screens/home_screen/components/home_grid_item.dart';
import 'package:all_docs_reader/services/file_provider_service.dart';
import 'package:all_docs_reader/utils/app_colors.dart';
import 'package:all_docs_reader/utils/app_images.dart';
import 'package:all_docs_reader/widgets/custom_image_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

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
            // icon: Icon(
            //   CupertinoIcons.globe,
            //   color: AppColors.white50Color,
            //   size: 25.sp,
            // )),
            icon: SizedBox.shrink()),
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
              onPressed: () {
                Fluttertoast.showToast(msg: "Coming soon");
              },
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
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            index == 0
                                ? showRatingDialog()
                                : index == 2
                                    ? launchPrivacyUrl()
                                    : index == 3
                                        ? shareAPKLink()
                                        : launchPrivacyUrl();
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: Row(
                              children: [
                                CustomImageView(
                                  svgPath: index == 0
                                      ? AppImages.rateUsIcon
                                      : index == 1
                                          ? AppImages.guideIcon
                                          : index == 2
                                              ? AppImages.privacyIcon
                                              : AppImages.shareIcon,
                                  height: 25.h,
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 30.sp),
                                ),
                                Text(
                                    index == 0
                                        ? "Rate Us"
                                        : index == 1
                                            ? "Guide"
                                            : index == 2
                                                ? "Privacy"
                                                : "Share",
                                    textAlign: TextAlign.center,
                                    style: context.textTheme.bodyLarge!
                                        .copyWith(
                                            color: AppColors.blackColor,
                                            fontSize: 18.sp)),
                              ],
                            ),
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
                items: const [
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

  showRatingDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Rate your experience !",
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyLarge!.copyWith(
                        color: AppColors.blackColor, fontSize: 15.sp)),
                SizedBox(height: 10.h),
                CustomImageView(
                  imagePath: AppImages.userExperienceIcon,
                  height: 120.h,
                ),
                SizedBox(height: 15.h),
                RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 2.w),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    size: 20.sp,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                )
              ],
            ),
          );
        });
  }

  launchPrivacyUrl() async {
    final Uri link = Uri.parse(
        'https://sites.google.com/view/privacy-policy-all-file-reader/privacy_policy');
    if (!await launchUrl(link)) {
      throw Exception('Could not launch $link');
    }
  }

  shareAPKLink() {
    Share.share(
        "https://play.google.com/store/apps/details?id=com.all.document.reader.office.docs.viewer.app");
  }
}
