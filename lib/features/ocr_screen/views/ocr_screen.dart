import 'package:academic_planner_for_it/features/ocr_screen/view_model/ocr_list_notifier.dart';
import 'package:academic_planner_for_it/features/ocr_screen/widgets/no_ocr_list.dart';
import 'package:academic_planner_for_it/features/ocr_screen/widgets/ocr_list.dart';
import 'package:academic_planner_for_it/features/ocr_screen/widgets/ocr_utility_button.dart';
import 'package:academic_planner_for_it/utilities/common_widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class OcrScreen extends ConsumerStatefulWidget {
  const OcrScreen({super.key});
  static const String routeName = '/ocrScreen';

  @override
  ConsumerState createState() => _OcrScreenState();
}

class _OcrScreenState extends ConsumerState<OcrScreen> {
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool isConnected = true;

  @override
  void initState() {
    super.initState();
    _checkConnection();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _checkConnection() async {
    final result = await Connectivity().checkConnectivity();
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    setState(() {
      isConnected = (result.first != ConnectivityResult.none);
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ocrList = ref.watch(ocrListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Upload an Image',
          style: TextStyle(fontSize: 20),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(
            MediaQuery.of(context).size.height * 0.12,
          ),
          child: const OcrUtilityButton(),
        ),
      ),
      drawer: const CustomDrawer(),
      body: !isConnected
          ? const Center(
              child: Text(
                'No internet connection. Please connect to the internet.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            )
          : ocrList.isEmpty
              ? const NoOcrList()
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: ocrList.length,
                        itemBuilder: (context, index) {
                          final ocrData = ocrList[index];
                          return OcrList(data: ocrData);
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
