import 'dart:io';
import 'dart:typed_data';

import 'package:all_docs_reader/provider/selected_images_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';
import '../../widgets/custom_image_view.dart';
import '../selected_images_screen/selected_images_screen.dart';

class ImageRotationScreen extends StatefulWidget {
  final String path;

  const ImageRotationScreen({super.key, required this.path});

  @override
  _ImageRotationScreenState createState() => _ImageRotationScreenState();
}

class _ImageRotationScreenState extends State<ImageRotationScreen> {
  late File _imageFile;
  late img.Image _image;
  double _angle = 0.0;

  @override
  void initState() {
    super.initState();
    // Load your image file here
    _loadImage();
  }

  Future<img.Image> _loadImage() async {
    // Replace with the actual path to your image file
    String imagePath = '/path/to/your/image.jpg';
    _imageFile = File(widget.path);
    List<int> imageBytes = await _imageFile.readAsBytes();
    return _image = img.decodeImage(Uint8List.fromList(imageBytes))!;
    // setState(() {});
  }

  void _rotateLeft() {
    setState(() {
      _angle -= 90.0;
      if (_angle < 0) _angle = 270.0;
    });
  }

  void _rotateRight() {
    setState(() {
      _angle += 90.0;
      if (_angle >= 360) _angle = 0.0;
    });
  }

  void _resetRotation() {
    setState(() {
      _angle = 0.0;
    });
  }

 Future _saveImage() async {
    // Check if image and file are loaded
    if (_image != null && _imageFile != null) {
      // Create a copy of the original image
      img.Image rotatedImage = img.copyRotate(_image, _angle.toInt());

      // Encode the rotated image to PNG format
      Uint8List pngBytes = Uint8List.fromList(img.encodePng(rotatedImage));

      try {
        // Get the path for saving the new image
        Directory directory = await getTemporaryDirectory();
        String filePath = '${directory.path}/rotated_image.png';

        // Write the PNG bytes to the file
        await File(filePath).writeAsBytes(pngBytes);
        return filePath ;
        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image saved successfully at $filePath'),
          ),
        );
      } catch (e) {
        // Show an error message if there's an issue saving the image
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving image: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              CupertinoIcons.back,
              size: 25.sp,
            )),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
        centerTitle: true,
        title: Text(
          "Rotate",
          style: TextStyle(
              color: AppColors.whiteColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w400),
        ),
        actions: [
          Consumer<SelectedImagesProvider>(
            builder: (context, selectedImagesProvider, child) => IconButton(onPressed: () {
            _saveImage().then((value) {
              selectedImagesProvider.addMoreImages([value]);
              Get.to(()=> SelectedImagesScreen());
            });
                    }, icon: Icon(Icons.check)),
          )],
        backgroundColor: AppColors.mainColor,
        // centerTitle: true,
      ),
      // appBar: AppBar(
      //   title: Text('Image Rotation'),
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.save),
      //       onPressed: _saveImage,
      //     ),
      //   ],
      // ),
      body: Column(
        children: [
          FutureBuilder(
              future: _loadImage(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Expanded(
                      child: _image != null
                          ? Transform.rotate(
                              angle: _angle * (3.1415926535897932 / 180),
                              child: Image.memory(
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                Uint8List.fromList(img.encodePng(_image)),
                              ))
                          : SizedBox.shrink());
                } else {
                  return const Expanded(
                    child: Center(
                        child: CircularProgressIndicator()
                    ),
                  );
                }
              }),
          Container(
            color: AppColors.mainColor,
            padding: EdgeInsets.all(10.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    _resetRotation();
                  },
                  child: Column(
                    children: [
                      CustomImageView(
                          svgPath: AppImages.resetRotationIcon, height: 30.h),
                      Text(
                        "Reset",
                        style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    _rotateLeft();
                  },
                  child: Column(
                    children: [
                      CustomImageView(
                          svgPath: AppImages.leftRotationIcon, height: 30.h),
                      Text(
                        "Rotate left",
                        style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    _rotateRight();
                  },
                  child: Column(
                    children: [
                      CustomImageView(
                          svgPath: AppImages.rightRotationIcon, height: 30.h),
                      Text(
                        "Rotate right",
                        style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
