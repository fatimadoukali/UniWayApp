import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(List<ConnectivityResult> connectivityResult) {
    if (connectivityResult.contains(ConnectivityResult.none)) {
      Get.rawSnackbar(
          backgroundColor: Colors.red,
          messageText: Text('Please connect to the internet'),
          isDismissible: false,
          duration: Duration(days: 1),
          snackStyle: SnackStyle.GROUNDED,
          margin: EdgeInsets.zero,
          icon: Icon(Icons.wifi_off));
    } else {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
    }
  }
}
