import 'package:flutter/material.dart';

class CategoryDropdown extends StatelessWidget {
  final String? selected;
  final List<String> categories;
  final Function(String?) onChanged;

  const CategoryDropdown({
    super.key,
    required this.selected,
    required this.categories,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: '카테고리',
      ),
      value: selected,
      items: categories
          .map((category) => DropdownMenuItem(
        value: category,
        child: Text(category),
      ))
          .toList(),
      onChanged: onChanged,
    );
  }
}
