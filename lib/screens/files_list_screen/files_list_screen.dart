import 'dart:async';

import 'package:all_docs_reader/provider/favorites_provider.dart';
import 'package:all_docs_reader/provider/files_service_provider.dart';
import 'package:all_docs_reader/screens/files_list_screen/components/file_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';
import '../../widgets/custom_image_view.dart';

class FilesListScreen extends StatefulWidget {
  final String title;

  const FilesListScreen({super.key, required this.title});

  @override
  State<FilesListScreen> createState() => _FilesListScreenState();
}

class _FilesListScreenState extends State<FilesListScreen> {
  @override
  void initState() {
    Timer(Duration(milliseconds: 100), () {
      Provider.of<FilesServiceProvider>(context, listen: false).getAllFavorites(context);
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              CupertinoIcons.back,
              color: AppColors.whiteColor,
              size: 25.sp,
            )),
        centerTitle: true,
        title: Text(widget.title,
            style: context.textTheme.bodyMedium!
                .copyWith(color: AppColors.whiteColor, fontSize: 18.sp)),
        actions: [
          IconButton(
              onPressed: () {},
              icon: CustomImageView(svgPath: AppImages.filterIcon)),
          IconButton(
              onPressed: () {},
              icon: CustomImageView(svgPath: AppImages.menuIcon)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<FilesServiceProvider>(
              builder: (context, filesServiceProvider, child) =>
                  ListView.builder(
                itemCount: widget.title.contains("All Files")
                    ? filesServiceProvider.getCountAllFiles()
                    : widget.title.contains("Pdf Files")
                        ? filesServiceProvider.pdfFiles.length
                        : widget.title.contains("Docs/Word Files")
                            ? filesServiceProvider.docsFiles.length
                            : widget.title.contains("PPT Files")
                                ? filesServiceProvider.pptFiles.length
                                : widget.title.contains("Text Files")
                                    ? filesServiceProvider.txtFiles.length
                                    : widget.title.contains("Excel Files")
                                        ? filesServiceProvider.excelFiles.length
                                        : widget.title.contains("Favorites")
                                            ? filesServiceProvider
                                                .favFiles.length
                                            : filesServiceProvider
                                                .epubFiles.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Consumer<FavoritesProvider>(
                    builder: (context, favoritesProvider, child) => FileItem(
                      name:
                          filesServiceProvider.getFileName(widget.title, index),
                      type: filesServiceProvider.getPathEndsWith(
                          widget.title, index),
                      details: filesServiceProvider.getFileDetails(
                          widget.title, index),
                      filePath: filesServiceProvider.getCurrentItemAt(
                          index, widget.title),
                      isFavorite: checkFavorite(
                          filesServiceProvider.getCurrentItemAt(
                              index, widget.title),
                          favoritesProvider.favorites), onFavChanged: (){
                      Provider.of<FilesServiceProvider>(context, listen: false).getAllFavorites(context);
                    },
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  bool checkFavorite(String path, List paths) {
    bool isFavorite = paths.contains(path);
    return isFavorite;
  }
}
