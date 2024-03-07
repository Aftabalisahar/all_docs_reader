import 'package:all_docs_reader/provider/intro_provider.dart';
import 'package:all_docs_reader/screens/home_screen/home_screen.dart';
import 'package:all_docs_reader/screens/intro_screens/components/slide_item.dart';
import 'package:all_docs_reader/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  PageController pageController = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        leading: Provider.of<IntroProvider>(context).index == 3 ||
                Provider.of<IntroProvider>(context).index == 0
            ? const SizedBox.shrink()
            : IconButton(
                onPressed: () {
                  Provider.of<IntroProvider>(context, listen: false).index > 0
                      ? pageController.animateToPage(
                          Provider.of<IntroProvider>(context, listen: false)
                                  .index -
                              1,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.linear)
                      : null;
                },
                icon: Icon(Icons.arrow_back,
                    color: AppColors.whiteColor, size: 25.sp)),
        actions: [
          Provider.of<IntroProvider>(context).index != 2
              ? IconButton(
                  onPressed: () async {
                    Provider.of<IntroProvider>(context, listen: false).index < 3
                        ? pageController.animateToPage(
                            Provider.of<IntroProvider>(context, listen: false)
                                    .index +
                                1,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.linear)
                        : goToNextScreen(await Provider.of<IntroProvider>(context, listen: false).requestPermission());
                  },
                  icon: Icon(Icons.arrow_forward,
                      color: AppColors.whiteColor, size: 25.sp))
              : const SizedBox.shrink(),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 80.h,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(30.sp),
              child: Consumer<IntroProvider>(
                builder: (context, introProvider, child) => PageView(
                  physics: introProvider.index == 2 || introProvider.index == 3
                      ? const NeverScrollableScrollPhysics()
                      : const AlwaysScrollableScrollPhysics(),
                  controller: pageController,
                  onPageChanged: (value) {
                    introProvider.updateIndex(value);
                  },
                  children: List.generate(
                      4,
                      (index) => SlideItem(
                          onGetStarted: () async {
                            introProvider.index == 2 ? pageController.animateToPage(3,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.linear) : goToNextScreen(await introProvider.requestPermission());
                          },
                          index: index)),
                ),
              ),
            ),
          ),
          Container(
            height: 120.h,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
  goToNextScreen(bool go){
    if(go){
      Get.to(()=> const HomeScreen());
    }else{
      Fluttertoast.showToast(msg: "You must have to allow permission to use this app's functionality properly.");
    }
  }
}
