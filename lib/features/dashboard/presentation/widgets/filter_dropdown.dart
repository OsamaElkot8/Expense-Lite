import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/constants/app_constants.dart';

class FilterDropdown extends StatelessWidget {
  final String currentFilter;
  final ValueChanged<String> onFilterChanged;

  const FilterDropdown({
    super.key,
    required this.currentFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110.0,
      height: 30.0,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(6),
      ),
      child: DropdownButton<String>(
        value: currentFilter,
        isExpanded: true,
        underline: const SizedBox.shrink(),
        icon: const Icon(CupertinoIcons.chevron_down, size: 12),
        items: AppConstants.filterOptions.map((String filter) {
          return DropdownMenuItem<String>(
            value: filter,
            child: Text(
              filter,
              style: context.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            onFilterChanged(newValue);
          }
        },
      ),
    );
  }
}
