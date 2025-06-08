import 'package:flutter/material.dart';

class CustomSearchBar<T> extends StatefulWidget {
  final List<T> allItems;
  final ValueChanged<List<T>> onFiltered;
  final bool Function(T item, String query) filter;
  final ValueChanged<String>? onChanged;

  const CustomSearchBar({
    super.key,
    required this.allItems,
    required this.onFiltered,
    required this.filter,
    this.onChanged,
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
        onChanged: (value) {
          _filter(value);              // 기존 필터링 로직
          widget.onChanged?.call(value); // 외부에서도 검색어 전달 받게!
        },
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
