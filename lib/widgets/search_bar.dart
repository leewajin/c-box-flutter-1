import 'package:flutter/material.dart';

class CustomSearchBar<T> extends StatefulWidget {
  final List<T> allItems;
  final ValueChanged<List<T>> onFiltered;
  final bool Function(T item, String query) filter;

  const CustomSearchBar({
    super.key,
    required this.allItems,
    required this.onFiltered,
    required this.filter,
  });

@override
State<CustomSearchBar<T>> createState() => _CustomSearchBarState<T>();
}

class _CustomSearchBarState<T> extends State<CustomSearchBar<T>> {
  final TextEditingController _controller = TextEditingController();

  void _filter(String query) {
    final filtered = widget.allItems.where((item) {
      return widget.filter(item, query);
    }).toList();

    widget.onFiltered(filtered);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _controller,
        onChanged: _filter,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: '검색',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }
}
