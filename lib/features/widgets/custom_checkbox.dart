import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  final bool checked;
  final ValueChanged<bool> onChanged;

  CustomCheckbox({super.key, required this.checked, required this.onChanged});

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.tightFor(width: 20, height: 20),
      child: Transform.scale(
        scale: 1.1,
        child: Checkbox(
          value: widget.checked,
          onChanged: (value) => widget.onChanged(value ?? false),
          fillColor: WidgetStateProperty.resolveWith<Color>(
            (states) =>
                states.contains(WidgetState.selected)
                    ? Color(0xFF0066FF)
                    : Colors.transparent,
          ),
          checkColor: Color(0xFFFFFFFF),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
      ),
    );
  }
}
