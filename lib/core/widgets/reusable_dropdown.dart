import 'package:flutter/material.dart';

class ReusableDropdown extends StatelessWidget {
  final List<String> items;
  final String? selectedValue;
  final String hintText;
  final ValueChanged<String?> onChanged;

  const ReusableDropdown({
    super.key,
    required this.items,
    this.selectedValue,
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: const Color(0xFFCECECE)),
      ),
      width: MediaQuery.of(context).size.width * 0.86,
      height: MediaQuery.of(context).size.height * 0.055,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          hint: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(hintText),
          ),
          icon: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.arrow_drop_down, color: Color(0xFF818181)),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(item),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
