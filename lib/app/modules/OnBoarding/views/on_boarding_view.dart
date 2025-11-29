import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/on_boarding_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnBoardingView extends GetView<OnBoardingController> {
  const OnBoardingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyleTitle = const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: Colors.black87,
    );

    final textStyleDesc = const TextStyle(
      fontSize: 14,
      color: Colors.black54,
      height: 1.5,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () => Get.offAllNamed('/login'),
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: Color(0xFF00A86B),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView(
                  controller: controller.pageController,
                  onPageChanged: (index) =>
                      controller.currentPage.value = index,
                  children: [
                    buildPage(
                      image: 'assets/images/Saving-money-amico.svg',
                      title: 'Selamat Datang di Lumo!',
                      desc:
                          'Simpan sedikit demi sedikit, capai impianmu, dan nikmati perjalanan menabung bareng Lumo.',
                      titleStyle: textStyleTitle,
                      descStyle: textStyleDesc,
                    ),
                    buildPage(
                      image: 'assets/images/Team-goals-rafiki.svg',
                      title: 'Atur Keuanganmu',
                      desc:
                          'Kelola tabungan dan keuanganmu dengan mudah, kapan pun dan di mana pun.',
                      titleStyle: textStyleTitle,
                      descStyle: textStyleDesc,
                    ),
                    buildPage(
                      image: 'assets/images/Shared-goals-amico.svg',
                      title: 'Capai Tujuanmu',
                      desc:
                          'Pantau perkembangan tabungan dan wujudkan impianmu bersama Lumo.',
                      titleStyle: textStyleTitle,
                      descStyle: textStyleDesc,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => GestureDetector(
                      onTap: () => controller.goToPage(index),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        width: controller.currentPage.value == index ? 10 : 8,
                        height: controller.currentPage.value == index ? 10 : 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: controller.currentPage.value == index
                              ? const Color(0xFF00A86B)
                              : const Color(0xFFE0E0E0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: controller.nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00A86B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      controller.currentPage.value == 2 ? 'Mulai' : 'Next',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPage({
    required String image,
    required String title,
    required String desc,
    required TextStyle titleStyle,
    required TextStyle descStyle,
  }) {
    return Column(
      children: [
        const Spacer(),
        SvgPicture.asset(image, height: 300),
        const SizedBox(height: 40),
        Text(title, textAlign: TextAlign.center, style: titleStyle),
        const SizedBox(height: 16),
        Text(desc, textAlign: TextAlign.center, style: descStyle),
        const Spacer(),
      ],
    );
  }
}
