import 'package:flutter/material.dart';

Widget navButton({
  required String image,
  required String label,
  required GestureTapCallback onTap,
  required bool isActive,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        color: isActive ? Color(0x18FCD535) : Colors.transparent,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Image.asset(
          image,
          height: 32,
          width: 32,
          fit: BoxFit.contain,
          color: isActive ? Color(0xFFFCD535) : Color(0xBED9D9D9),
        ),
      ),
    ),
  );
}
