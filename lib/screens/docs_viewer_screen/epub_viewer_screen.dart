import 'dart:io';

import 'package:all_docs_reader/utils/app_colors.dart';
import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../provider/epub_view_proivder.dart';

class EpubViewerScreen extends StatefulWidget {
  final String filePath ;
  const EpubViewerScreen({Key? key, required this.filePath}) : super(key: key);

  @override
  State<EpubViewerScreen> createState() => _EpubViewerScreenState();
}

class _EpubViewerScreenState extends State<EpubViewerScreen> {
  late EpubController _epubReaderController;

  @override
  void initState() {
    _epubReaderController = EpubController(
      document:
          // EpubDocument.openAsset('assets/New-Findings-on-Shirdi-Sai-Baba.epub'),
          EpubDocument.openFile(File(widget.filePath)),
      // epubCfi:
      //     'epubcfi(/6/26[id4]!/4/2/2[id4]/22)', // book.epub Chapter 3 paragraph 10
      // epubCfi:
      //     'epubcfi(/6/6[chapter-2]!/4/2/1612)', // book_2.epub Chapter 16 paragraph 3
    );

    super.initState();
  }

  @override
  void dispose() {
    _epubReaderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: EpubViewActualChapter(
          controller: _epubReaderController,
          builder: (chapterValue) => Text(
            chapterValue?.chapter?.Title?.replaceAll('\n', '').trim() ?? '',
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 20.sp),
          ),
        ),
      ),
      drawer: Drawer(
        child: EpubViewTableOfContents(controller: _epubReaderController),
      ),
      body: EpubView(
        onChapterChanged: (value) {
          Provider.of<EpubViewProvider>(context,listen: false).updateIndex(_epubReaderController.currentValueListenable.value?.position.index);
        },
        builders: EpubViewBuilders<DefaultBuilderOptions>(
          options: const DefaultBuilderOptions(),
          chapterDividerBuilder: (_) => const Divider(),
        ),
        controller: _epubReaderController,
      ),
      floatingActionButton: Consumer<EpubViewProvider>(
        builder: (context, epubViewProvider, child) =>
            epubViewProvider.currentIndex > 4
                ? GestureDetector(
                    onTap: () {
                      _epubReaderController.scrollTo(index: 0);
                    },
                    child: CircleAvatar(
                      radius: 25.r,
                      backgroundColor: AppColors.mainColor,
                      child: Icon(
                        Icons.arrow_upward,
                        size: 25.sp,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  )
                : SizedBox.shrink(),
      ));
}
