import 'dart:async';

import 'package:all_docs_reader/provider/bottom_nav_provider.dart';
import 'package:all_docs_reader/provider/epub_view_proivder.dart';
import 'package:all_docs_reader/provider/favorites_provider.dart';
import 'package:all_docs_reader/provider/files_service_provider.dart';
import 'package:all_docs_reader/provider/intro_provider.dart';
import 'package:all_docs_reader/provider/pdf_provider.dart';
import 'package:all_docs_reader/provider/selected_images_provider.dart';
import 'package:all_docs_reader/screens/intro_screens/intro_screen.dart';
import 'package:all_docs_reader/services/db_service/favorites_db.dart';
import 'package:all_docs_reader/utils/app_colors.dart';
import 'package:all_docs_reader/utils/app_images.dart';
import 'package:all_docs_reader/widgets/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

late var favoritesBox ;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.registerAdapter(FavoritesAdapter());
  favoritesBox = await Hive.openBox('favoriteBox');
  print(favoritesBox.values);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => IntroProvider()),
        ChangeNotifierProvider(create: (context) => SelectedImagesProvider()),
        ChangeNotifierProvider(create: (context) => PDFProvider()),
        ChangeNotifierProvider(create: (context) => EpubViewProvider()),
        ChangeNotifierProvider(create: (context) => FavoritesProvider()),
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
      Get.to(() => const IntroScreen());
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
