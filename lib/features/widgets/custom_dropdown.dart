import 'package:flutter/material.dart';

Widget buildDropdown<T>({
  required T? value,
  Widget? hint,
  FocusNode? focusNode,
  required List<DropdownMenuItem<T>> items,
  required ValueChanged<T?>? onChanged,
  required String label,
  required bool enabled,
  required BuildContext context,
}) {
  return Expanded(
    child: TextSelectionTheme(
      data: TextSelectionThemeData(
        selectionColor: Color(0x1AD9D9D9),
        selectionHandleColor: Color(0xFFFCD535),
      ),
      child: SizedBox(
        height: 50,
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButtonFormField<T>(
            value: value,
            hint: hint,
            focusNode: focusNode,
            isExpanded: true,
            dropdownColor:
                Theme.of(context).brightness == Brightness.dark
                    ? Color(0xFF181A20)
                    : Color(0xFFD9D9D9),
            icon: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/dropdown_icon.png',
                  height: 12,
                  width: 12,
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? Color(0xBED9D9D9)
                          : Color(0xBE181A20),
                ),
              ],
            ),
            style: TextStyle(
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Color(0xFFD9D9D9)
                      : Color(0xFF181A20),
              fontSize: 14,
            ),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(
                fontSize: 14,
                color:
                    (focusNode?.hasFocus ?? false)
                        ? Color(0xFFFCD535)
                        : Theme.of(context).brightness == Brightness.dark
                        ? Color(0x7ED9D9D9)
                        : Color(0x7E181A20),
              ),
              filled: false,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0.75,
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? Color(0x3ED9D9D9)
                          : Color(0x3E181A20),
                ),
                borderRadius: BorderRadius.circular(2.5),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0.75,
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? Color(0x3ED9D9D9)
                          : Color(0x3E181A20),
                ),
                borderRadius: BorderRadius.circular(2.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFFCD535)),
                borderRadius: BorderRadius.circular(2.5),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            ),
            onChanged: enabled ? onChanged : null,
            items: items,
          ),
        ),
      ),
    ),
  );
}
