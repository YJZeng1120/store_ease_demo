import 'dart:io';
import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';

Future<Option<Uint8List>> getImageFromCamera() async {
  final imagePicker = ImagePicker();
  final pickedFile = await imagePicker.pickImage(
    source: ImageSource.camera,
    maxWidth: 200,
  );

  if (pickedFile != null) {
    File imageFile = File(pickedFile.path);
    Uint8List imageBytes = await imageFile.readAsBytes();
    return some(imageBytes);
  } else {
    // 處理使用者取消操作的情況
    return none();
  }
}

Future<Option<Uint8List>> getImageFromGallery() async {
  final imagePicker = ImagePicker();
  final pickedFile = await imagePicker.pickImage(
    source: ImageSource.gallery,
    maxWidth: 200,
  );

  if (pickedFile != null) {
    File imageFile = File(pickedFile.path);
    Uint8List imageBytes = await imageFile.readAsBytes();
    return some(imageBytes);
  } else {
    // 處理使用者取消操作的情況
    return none();
  }
}

class ImageHelper {
  // 如果使用者沒有新增照片時，使用imageBytesProxy
  static late Uint8List imageBytesProxy;

  static Future<Uint8List> init() async {
    final ByteData bytes =
        await rootBundle.load('assets/images/add_picture.png');
    imageBytesProxy = bytes.buffer.asUint8List();
    return imageBytesProxy;
  }
}

saveImageToGallery(
  final ScreenshotController screenshotController,
  final String title,
) async {
  final value = await screenshotController.capture();
  await saveScreenshot(
    value!,
    title,
  );
}

Future saveScreenshot(
  Uint8List imageBytes,
  String title,
) async {
  final randomSuffix = Random().nextInt(10000);
  final name = 'ScreenShot-$title-$randomSuffix';
  await ImageGallerySaver.saveImage(
    imageBytes,
    name: name,
  );
}
