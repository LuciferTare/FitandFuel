import 'package:flutter/material.dart';

Widget buildButtons({
  int? flex,
  required Color color,
  required String label,
  required Color labelColor,
  required VoidCallback? onPressed,
}) {
  return Expanded(
    flex: flex ?? 1,
    child: Container(
      constraints: BoxConstraints.tightFor(height: 50),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          splashFactory: NoSplash.splashFactory,
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 5),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 18,
              color: labelColor,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    ),
  );
}

Widget bigCloseButton({
  required BuildContext context,
  required VoidCallback onPressed,
}) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(
        color:
            Theme.of(context).brightness == Brightness.dark
                ? Color(0x3ED9D9D9)
                : Color(0x3E181A20),
      ),
    ),
    constraints: BoxConstraints.tightFor(width: 35, height: 35),
    child: IconButton(
      onPressed: onPressed,
      icon: Image.asset('assets/images/close.png', height: 25, width: 25),
      alignment: Alignment.center,
      padding: EdgeInsets.zero,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
    ),
  );
}
