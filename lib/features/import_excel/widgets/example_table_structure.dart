import 'package:flutter/material.dart';

/// A widget that displays an example table structure for Excel files.
///
/// This widget shows an image of a correctly formatted Excel table and
/// provides instructions to the user on how to structure their Excel file for
/// import.
class ExampleTableStructure extends StatelessWidget {
  const ExampleTableStructure({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Text(
            "Ensure that your Excel File follows following structure.\nEnsure that it does not have any headers.",
            overflow: TextOverflow.clip,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 10),
          Image.asset(
            'assets/image/example_excel_table.png',
            height: size.height * 0.40,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
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
                Icons.upload,
                size: 40,
              ),
              Text(
                " button to upload excel.",
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
