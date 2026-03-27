import 'package:flutter/material.dart';

PreferredSize appBar({required BuildContext context}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(kToolbarHeight),
    child: AppBar(
      backgroundColor: Color(0xFF181A20),
      elevation: 8,
      surfaceTintColor: Colors.transparent,
      title: Row(
        children: [
          Text(
            'Fit',
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'Salt',
              fontWeight: FontWeight.bold,
              color: Color(0xFFD9D9D9),
            ),
          ),
          Text(
            '&',
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'Salt',
              fontWeight: FontWeight.bold,
              color: Color(0xFFFCD535),
            ),
          ),
          Text(
            'Fuel',
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'Salt',
              fontWeight: FontWeight.bold,
              color: Color(0xFFD9D9D9),
            ),
          ),
          Spacer(),
          ClipOval(
            child: Container(
              color: const Color(0x3ED9D9D9),
              child: Image.asset(
                'assets/images/brand.png',
                width: 35,
                height: 35,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
      leadingWidth: 0,
      leading: Container(),
    ),
  );
}
