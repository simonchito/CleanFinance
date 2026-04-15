import 'package:flutter/material.dart';

import '../../../../core/utils/icon_mapper.dart';

class CategoryOptionLabel extends StatelessWidget {
  const CategoryOptionLabel({
    required this.iconKey,
    required this.label,
    super.key,
  });

  final String iconKey;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(IconMapper.getIcon(iconKey), size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
