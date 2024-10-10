import 'dart:io';

import 'package:academic_planner_for_it/utilities/services/google_ocr_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerServices {
  File? _imageFile;

  final GoogleOCRServices _googleOCRServices = GoogleOCRServices();

  Future<void> pickImageFromGallery(WidgetRef ref) async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      _imageFile = File(pickedImage!.path);
      await _googleOCRServices.performTextRecognition(_imageFile, ref);
    } catch (e) {
      throw Exception('$e');
    }
  }
}
