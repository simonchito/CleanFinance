import 'package:flutter/material.dart';

import '../../../../app/app_strings.dart';
import '../../../../core/utils/icon_mapper.dart';

class SelectionSheetItem<T> {
  const SelectionSheetItem({
    required this.value,
    required this.label,
    this.subtitle,
    this.iconKey,
    this.iconData,
  });

  final T value;
  final String label;
  final String? subtitle;
  final String? iconKey;
  final IconData? iconData;
}

Future<T?> showSelectionSheet<T>({
  required BuildContext context,
  required String title,
  required List<SelectionSheetItem<T>> items,
  required T? selectedValue,
  String? description,
  double maxHeight = 420,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _SelectionSheet<T>(
      title: title,
      description: description,
      items: items,
      selectedValue: selectedValue,
      maxHeight: maxHeight,
    ),
  );
}

class SelectionSheetField<T> extends StatelessWidget {
  const SelectionSheetField({
    required this.label,
    required this.items,
    required this.onChanged,
    this.value,
    this.placeholder,
    this.sheetTitle,
    this.sheetDescription,
    this.enabled = true,
    this.maxSheetHeight = 420,
    super.key,
  });

  final String label;
  final List<SelectionSheetItem<T>> items;
  final ValueChanged<T> onChanged;
  final T? value;
  final String? placeholder;
  final String? sheetTitle;
  final String? sheetDescription;
  final bool enabled;
  final double maxSheetHeight;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final selectedItem = _findSelectedItem();
    final scheme = Theme.of(context).colorScheme;
    final resolvedPlaceholder =
        placeholder ?? (strings.isEnglish ? 'Select' : 'Seleccionar');

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: !enabled || items.isEmpty
          ? null
          : () async {
              final selected = await showSelectionSheet<T>(
                context: context,
                title: sheetTitle ?? label,
                description: sheetDescription,
                items: items,
                selectedValue: value,
                maxHeight: maxSheetHeight,
              );
              if (selected != null) {
                onChanged(selected);
              }
            },
      child: InputDecorator(
        isEmpty: selectedItem == null,
        decoration: InputDecoration(
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(
            Icons.expand_more_rounded,
            color: enabled ? null : scheme.onSurfaceVariant,
          ),
          enabled: enabled,
        ),
        child: selectedItem == null
            ? Text(
                resolvedPlaceholder,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              )
            : _SelectionTileContent(
                item: selectedItem,
                selected: false,
                compact: true,
              ),
      ),
    );
  }

  SelectionSheetItem<T>? _findSelectedItem() {
    for (final item in items) {
      if (item.value == value) {
        return item;
      }
    }
    return null;
  }
}

class _SelectionSheet<T> extends StatelessWidget {
  const _SelectionSheet({
    required this.title,
    required this.items,
    required this.selectedValue,
    required this.maxHeight,
    this.description,
  });

  final String title;
  final String? description;
  final List<SelectionSheetItem<T>> items;
  final T? selectedValue;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          12,
          0,
          12,
          MediaQuery.of(context).padding.bottom + 12,
        ),
        child: Material(
          color: scheme.surface,
          elevation: 8,
          borderRadius: BorderRadius.circular(28),
          clipBehavior: Clip.antiAlias,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: SizedBox(
                      width: 36,
                      child: Divider(thickness: 4),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  if (description != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      description!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final isSelected = item.value == selectedValue;
                        return _SelectionSheetRow<T>(
                          item: item,
                          selected: isSelected,
                          onTap: () => Navigator.of(context).pop(item.value),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectionSheetRow<T> extends StatelessWidget {
  const _SelectionSheetRow({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final SelectionSheetItem<T> item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: selected ? scheme.primaryContainer : scheme.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? scheme.primary : scheme.outlineVariant,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: _SelectionTileContent(
                  item: item,
                  selected: selected,
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                selected
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: selected ? scheme.primary : scheme.outline,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectionTileContent<T> extends StatelessWidget {
  const _SelectionTileContent({
    required this.item,
    required this.selected,
    this.compact = false,
  });

  final SelectionSheetItem<T> item;
  final bool selected;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = selected ? scheme.primary : scheme.onSurface;
    final leading = item.iconData ??
        (item.iconKey != null ? IconMapper.getIcon(item.iconKey) : null);

    return Row(
      children: [
        if (leading != null) ...[
          Container(
            width: compact ? 32 : 40,
            height: compact ? 32 : 40,
            decoration: BoxDecoration(
              color: selected
                  ? scheme.surface.withValues(alpha: 0.55)
                  : scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(compact ? 10 : 14),
            ),
            child: Icon(
              leading,
              size: compact ? 18 : 20,
              color: accent,
            ),
          ),
          SizedBox(width: compact ? 10 : 12),
        ],
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: accent,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    ),
              ),
              if (item.subtitle != null && item.subtitle!.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  item.subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: selected
                            ? accent.withValues(alpha: 0.78)
                            : scheme.onSurfaceVariant,
                      ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
