import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const CustomBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.transparent, // We set the color in the container
        elevation: 0, // Elevation handled by the outer container
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navIcon("assets/medical-report.png", 0),
                  _navIcon("assets/add.png", 1),
                  const SizedBox(width: 60), // Space for main/home button
                  _navIcon("assets/service.png", 3),
                  _navIcon("assets/profile.png", 4),
                ],
              ),
            ),
            Positioned(
              child: GestureDetector(
                onTap: () => onTabSelected(2),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: selectedIndex == 2 ? Colors.white : const Color.fromARGB(255, 0, 0, 0),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Image.asset(
                      "assets/home-button.png",
                      width: 30,
                      height: 30,
                      color: selectedIndex == 2 ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navIcon(String asset, int index) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onTabSelected(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: isSelected
              ? const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                )
              : null,
          child: Image.asset(
            asset,
            width: 30,
            height: 30,
            color: isSelected
                ? Colors.black
                : const Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ),
    );
  }
}
