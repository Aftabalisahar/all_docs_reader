import 'package:all_docs_reader/screens/image_preview_screen/image_preview_screen.dart';
import 'package:all_docs_reader/utils/app_colors.dart';
import 'package:all_docs_reader/utils/app_images.dart';
import 'package:all_docs_reader/widgets/custom_image_view.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController = CameraController(
    _cameras.first,
    ResolutionPreset.medium,
  );
  late List<CameraDescription> _cameras;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    // Check if camera permission is granted
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      // Request camera permission
      await Permission.camera.request();
      // Check if permission is granted after request
      status = await Permission.camera.status;
      if (!status.isGranted) {
        // Permission not granted, navigate back
        Navigator.pop(context);
        return;
      }
    }

    // Retrieve the list of available cameras
    WidgetsFlutterBinding.ensureInitialized();
    _cameras = await availableCameras();

    if (_cameras.isEmpty) {
      // No camera available, navigate back
      Navigator.pop(context);
      return;
    }

    // Initialize the camera controller with the first camera from the list
    _cameraController = CameraController(
      _cameras.first,
      ResolutionPreset.medium,
    );

    // Initialize the camera controller and start the camera preview
    await _cameraController.initialize();

    // Update the state after the camera has been initialized
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    // Dispose of the camera controller when the widget is disposed
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox.shrink(),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
        title: Text(
          "Scan to PDF",
          style: TextStyle(
              color: AppColors.whiteColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w400),
        ),
        backgroundColor: AppColors.mainColor,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: _cameraController.value.aspectRatio,
              child: !_cameraController.value.isInitialized
                  ? Center(child: CircularProgressIndicator())
                  : CameraPreview(_cameraController),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10.sp),
            color: AppColors.mainColor, // Example color
            child: Row(
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel",
                        style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400))),
                SizedBox(width: MediaQuery.of(context).size.width * 0.28),
                GestureDetector(
                  onTap: () {
                    _cameraController.takePicture().then((value) {
                      Get.to(()=> ImagePreviewScreen(path: value.path,));
                    });
                  },
                  child: CircleAvatar(
                      backgroundColor: AppColors.whiteColor,
                      radius: 30.r,
                      child: CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 28.r,
                          child: CircleAvatar(
                              backgroundColor: AppColors.whiteColor,
                              radius: 26.r))),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    pickImage().then((value) => Get.to(()=> ImagePreviewScreen(path: value!)));
                  },
                  child: CustomImageView(
                    svgPath: AppImages.galleryIcon,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> pickImage() async {
    ImagePicker picker = ImagePicker();
    final path = picker.pickImage(source: ImageSource.gallery).then((value) => value?.path);
    return path;
  }
}
