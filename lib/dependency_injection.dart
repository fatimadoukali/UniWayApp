import 'package:get/get.dart';
import 'package:uniwayapp/Controller/network_controller.dart';

class DepandencyInjiction {
  static void init() {
    Get.put<NetworkController>(NetworkController(), permanent: true);
  }
}
