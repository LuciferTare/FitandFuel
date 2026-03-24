import 'package:flutter/material.dart';

Widget buildTextField({
  required BuildContext context,
  required TextInputType keyboardType,
  required TextEditingController controller,
  required String labeltext,
  required bool enabled,
  required bool obscureText,
  Widget? suffixIcon,
  required FocusNode focusNode,
  int? maxLength,
  ValueChanged<String>? onChanged,
}) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          labeltext,
          style: TextStyle(fontSize: 14, color: Color(0xBED9D9D9)),
        ),
        SizedBox(height: 2.5),
        TextSelectionTheme(
          data: TextSelectionThemeData(
            selectionColor: Color(0x1AD9D9D9),
            selectionHandleColor: Color(0xFFFCD535),
          ),
          child: SizedBox(
            height: 50,
            child: TextField(
              keyboardType: keyboardType,
              controller: controller,
              cursorColor: Color(0xBED9D9D9),
              cursorWidth: 1,
              maxLength: maxLength,
              onChanged: onChanged,
              style: TextStyle(color: Color(0xFFD9D9D9), fontSize: 14),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF181A20),
                counterText: '',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0x00D9D9D9)),
                  borderRadius: BorderRadius.circular(10),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0x00D9D9D9)),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0x00FCD535)),
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 10,
                ),
                suffixIcon: suffixIcon,
              ),
              obscureText: obscureText,
              enabled: enabled,
              focusNode: focusNode,
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
          ),
        ),
      ],
    ),
  );
}

Widget searchTextField({
  required BuildContext context,
  required TextInputType keyboardType,
  required TextEditingController controller,
  required String labeltext,
  required bool enabled,
  required bool obscureText,
  Widget? suffixIcon,
  required FocusNode focusNode,
  int? maxLength,
  ValueChanged<String>? onChanged,
}) {
  return Expanded(
    child: TextSelectionTheme(
      data: TextSelectionThemeData(
        selectionColor: Color(0x1AD9D9D9),
        selectionHandleColor: Color(0xFFFCD535),
      ),
      child: SizedBox(
        height: 50,
        child: TextField(
          keyboardType: keyboardType,
          controller: controller,
          cursorColor: Color(0xBED9D9D9),
          cursorWidth: 1,
          maxLength: maxLength,
          onChanged: onChanged,
          style: TextStyle(color: Color(0xFFD9D9D9), fontSize: 14),
          decoration: InputDecoration(
            labelText: labeltext,
            labelStyle: TextStyle(fontSize: 14, color: Color(0xBED9D9D9)),
            floatingLabelStyle: TextStyle(
              fontSize: 14,
              color: Color(0xFFFCD535),
            ),
            filled: true,
            fillColor: Color(0xFF181A20),
            counterText: '',
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 0, color: Color(0x7ED9D9D9)),
              borderRadius: BorderRadius.circular(10),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 0, color: Color(0x7ED9D9D9)),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFFCD535)),
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            suffixIcon: suffixIcon,
          ),
          obscureText: obscureText,
          enabled: enabled,
          focusNode: focusNode,
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus!.unfocus();
          },
        ),
      ),
    ),
  );
}
