import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';
import 'category_tab.dart';

class CategoryTabBar extends StatelessWidget {
  final List<String> categories;

  const CategoryTabBar({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    final selected = context.watch<CategoryProvider>().selected;

    if (categories.length <= 4) {
      // 항목이 적을 때는 Row로 균등 분배
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: categories.map((title) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: CategoryTab(
                  title: title,
                  isSelected: title == selected,
                  onTap: () => context.read<CategoryProvider>().select(title),
                ),
              ),
            );
          }).toList(),
        ),
      );
    }

    // 항목이 많을 때는 스크롤
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final title = categories[index];
          return CategoryTab(
            title: title,
            isSelected: title == selected,
            onTap: () => context.read<CategoryProvider>().select(title),
          );
        },
      ),
    );
  }
}