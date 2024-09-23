import 'package:academic_planner_for_it/features/ocr_screen/widgets/example_ocr_image.dart';
import 'package:academic_planner_for_it/utilities/services/image_picker_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoOcrList extends ConsumerStatefulWidget {
  const NoOcrList({super.key});

  @override
  ConsumerState createState() => _NoOcrListState();
}

class _NoOcrListState extends ConsumerState<NoOcrList> {
  final ImagePickerServices _imagePickerServices = ImagePickerServices();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const ExampleOcrImage(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton.icon(
              onPressed: () async {
                await _imagePickerServices.pickImageFromGallery(ref);
                setState(() {});
              },
              label: const Text('Upload Image'),
              icon: const Icon(
                Icons.image_outlined,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
