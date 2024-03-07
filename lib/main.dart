import 'dart:async';

import 'package:all_docs_reader/provider/bottom_nav_provider.dart';
import 'package:all_docs_reader/provider/epub_view_proivder.dart';
import 'package:all_docs_reader/provider/files_service_provider.dart';
import 'package:all_docs_reader/provider/intro_provider.dart';
import 'package:all_docs_reader/screens/intro_screens/intro_screen.dart';
import 'package:all_docs_reader/utils/app_colors.dart';
import 'package:all_docs_reader/utils/app_images.dart';
import 'package:all_docs_reader/widgets/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size ;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => IntroProvider()),
        ChangeNotifierProvider(create: (context) => EpubViewProvider()),
        ChangeNotifierProvider(create: (context) => FilesServiceProvider()),
        ChangeNotifierProvider(create: (context) => BottomNavigationProvider()),
      ],
      child: ScreenUtilInit(
        designSize: size,
        child: GetMaterialApp(
          title: 'All Documents Reader',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.mainColor),
            useMaterial3: true,
          ),
          home: const SplashScreen(),
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      Get.to(()=> const IntroScreen());
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Center(
        child: CustomImageView(
          svgPath: AppImages.splashIcon,
        ),
      ),
    );
  }
}
