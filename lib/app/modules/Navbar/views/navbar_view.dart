// views/navbar_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lumo/app/modules/History/views/history_view.dart';
import 'package:lumo/app/modules/Home/views/home_view.dart';
import 'package:lumo/app/modules/Profile/views/profile_view.dart';
import '../controllers/navbar_controller.dart';
import '../../../widgets/main_navbar.dart';

class NavbarView extends StatelessWidget {
  NavbarView({Key? key}) : super(key: key);

  // ✅ PUT CONTROLLER DISINI - SIMPLE!
  final NavbarController controller = Get.put(NavbarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _getPage(controller.currentIndex)),
      bottomNavigationBar: Obx(() {
        return MainNavbar(
          currentIndex: controller.currentIndex,
          onTap: controller.changeTab,
        );
      }),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return HomeView();
      case 1:
        return const HistoryView();
      case 2:
        return ProfileView();
      default:
        return Container();
    }
  }
}
