import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/models/expense_category.dart';

class CategoryGrid extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategoryGrid({
    super.key,
    this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.categories, style: context.textTheme.titleSmall),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: ExpenseCategories.all.length + 1,
          itemBuilder: (context, index) {
            if (index == ExpenseCategories.all.length) {
              // Add Category button
              return _buildCategoryItem(
                context,
                category: null,
                isSelected: false,
                isAddButton: true,
              );
            }

            final category = ExpenseCategories.all[index];
            final isSelected = selectedCategory == category.name;

            return _buildCategoryItem(
              context,
              category: category,
              isSelected: isSelected,
              isAddButton: false,
            );
          },
        ),
      ],
    );
  }

  Widget _buildCategoryItem(
    BuildContext context, {
    ExpenseCategory? category,
    required bool isSelected,
    required bool isAddButton,
  }) {
    return GestureDetector(
      onTap: () {
        if (isAddButton) {
          // Handle add category
          context.showSnackBarMessage(
            message: context.l10n.addCategoryComingSoon,
          );
        } else if (category != null) {
          onCategorySelected(category.name);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isAddButton
                  ? context.colorScheme.surfaceContainerHighest
                  : (isSelected
                        ? context.colorScheme.primary
                        : (category?.color ?? context.colorScheme.primary)
                              .withValues(alpha: 0.1)),
              shape: BoxShape.circle,
              border: Border.all(
                color: isAddButton
                    ? context.colorScheme.primary
                    : context.colorScheme.surfaceContainerHighest,
                width: 2,
              ),
            ),
            child: Icon(
              isAddButton ? Icons.add : category?.icon ?? Icons.category,
              color: isAddButton
                  ? context.colorScheme.primary
                  : (isSelected
                        ? context.colorScheme.surface
                        : (category?.color ?? context.colorScheme.primary)),
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isAddButton ? context.l10n.addCategory : (category?.name ?? ''),
            style: context.textTheme.bodySmall?.copyWith(
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? context.colorScheme.primary
                  : context.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
