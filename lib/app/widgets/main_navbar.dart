import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MainNavbar({Key? key, required this.currentIndex, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF009F61), 
        unselectedItemColor: const Color(0xFF9E9E9E),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: _buildNavItem(
              assetPath: 'assets/images/home.svg',
              isSelected: currentIndex == 0,
            ),
            label: 'Tabungan',
          ),
          BottomNavigationBarItem(
            icon: _buildNavItem(
              assetPath: 'assets/images/history.svg',
              isSelected: currentIndex == 1,
            ),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: _buildNavItem(
              assetPath: 'assets/images/profile.svg',
              isSelected: currentIndex == 2,
            ),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({required String assetPath, required bool isSelected}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: SvgPicture.asset(
        assetPath,
        width: 24,
        height: 24,
        color: isSelected ? const Color(0xFF009F61) : const Color(0xFF9E9E9E),
      ),
    );
  }
}
