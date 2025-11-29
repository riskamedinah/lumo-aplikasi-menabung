// controllers/navbar_controller.dart
import 'package:get/get.dart';

class NavbarController extends GetxController {
  final _currentIndex = 0.obs;

  int get currentIndex => _currentIndex.value;

  @override
  void onInit() {
    super.onInit();
    _checkInitialIndex();
  }

  void changeTab(int index) {
    _currentIndex.value = index;
  }

  void _checkInitialIndex() {
    final arguments = Get.arguments;
    if (arguments != null && arguments['initialIndex'] != null) {
      final initialIndex = arguments['initialIndex'] as int;
      if (initialIndex >= 0 && initialIndex <= 2) {
        _currentIndex.value = initialIndex;
      }
    }
  }
}
