import 'package:flutter/material.dart';

class ExampleOcrImage extends StatelessWidget {
  const ExampleOcrImage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Text(
            "Ensure that your Image follows following structure.\n Ensure that it does not have any headers.",
            overflow: TextOverflow.clip,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 10),
          Image.asset(
            'assets/image/example_ocr_image.png',
            height: size.height * 0.40,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Press the ",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.clip,
                ),
                maxLines: 1,
              ),
              const Icon(
                Icons.image_outlined,
                size: 40,
              ),
              Text(
                " button to upload image.",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.clip,
                ),
                maxLines: 1,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
