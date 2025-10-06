import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AutocompleteTextField<T> extends StatelessWidget {
  const AutocompleteTextField({
    super.key,
    required this.controller,
    required this.suggestions,
    required this.onSelected,
    required this.getSuggestions,
    this.selectedValue,
    this.formatters,
    this.label,
    this.focusNode,
    this.textColor = Colors.white,
  });

  final List<T> suggestions;
  final TextEditingController controller;
  final Color textColor;
  final T? selectedValue;
  final FocusNode? focusNode;
  final String? label;
  final Function(T) onSelected;
  final Function(String) getSuggestions;
  final List<TextInputFormatter>? formatters;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) Text(label!, style: TextStyle(color: textColor)),
        const SizedBox(height: 5,),
        TypeAheadField<T>(
          hideOnLoading: true,
          controller: controller,
          focusNode: focusNode,
          suggestionsCallback: (search) => getSuggestions(search),
          builder: (context, controller, focusNode) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white10,
              ),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                autofocus: true,
                style: TextStyle(color: textColor),
                cursorColor: textColor,
                inputFormatters: formatters,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelStyle: TextStyle(color: textColor),
                  contentPadding: const EdgeInsets.only(left: 10),
                ),
              ),
            );
          },
          emptyBuilder:
              (context) =>
                  (controller.text.isNotEmpty &&
                          controller.text.length > 2 &&
                          suggestions.isEmpty)
                      ? SizedBox()
                      : SizedBox(),
          itemBuilder: (context, value) {
            return ListTile(title: Text(value.toString()));
          },
          onSelected: (value) {
            onSelected(value);
            controller.text = value.toString();
          },
        ),
      ],
    );
  }
}
