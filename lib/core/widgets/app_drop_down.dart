import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class AppDropDown extends StatelessWidget {
  const AppDropDown({
    Key? key,
    required this.hint,
    required this.label,
    required this.items,
    required this.onValueSelected,
    this.selectedValue,
  }) : super(key: key);

  final String hint;
  final String label;
  final double? selectedValue;
  final List<double> items;
  final Function(double?) onValueSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.transparent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.white)),
          const SizedBox(height: 5,),
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white10,
              ),
            child: DropdownButtonHideUnderline(
                child: DropdownButton2<double>(
              isExpanded: true,
              hint: Text(
                hint,
                style: const TextStyle(
                    fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
              ),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white
              ),
              items: items
                  .map((double item) => DropdownMenuItem<double>(
                        value: item,
                        child: Text(
                          '$item',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ))
                  .toList(),
              value: selectedValue,
              onChanged: onValueSelected,
              dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(color: appColorGradient1)),
              iconStyleData: const IconStyleData(
                  icon: Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 24,
                  color: Colors.white,
                ),
              )),
              menuItemStyleData: const MenuItemStyleData(
                height: 50,
              ),
            )),
          ),
        ],
      ),
    );
  }
}
