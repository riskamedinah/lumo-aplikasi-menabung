import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  var opacity = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    startAnimation();
  }

  void startAnimation() async {
    await Future.delayed(const Duration(milliseconds:300));
    opacity.value = 1.0;

    await Future.delayed(const Duration(seconds: 5));
    Get.offNamed('/on-boarding');
  }
}