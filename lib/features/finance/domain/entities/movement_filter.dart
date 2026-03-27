import 'movement.dart';

class MovementFilter {
  const MovementFilter({
    this.startDate,
    this.endDate,
    this.type,
    this.categoryId,
    this.search,
    this.limit,
  });

  final DateTime? startDate;
  final DateTime? endDate;
  final MovementType? type;
  final String? categoryId;
  final String? search;
  final int? limit;

  MovementFilter copyWith({
    DateTime? startDate,
    DateTime? endDate,
    MovementType? type,
    String? categoryId,
    String? search,
    int? limit,
    bool clearDates = false,
    bool clearCategory = false,
    bool clearSearch = false,
    bool clearType = false,
  }) {
    return MovementFilter(
      startDate: clearDates ? null : (startDate ?? this.startDate),
      endDate: clearDates ? null : (endDate ?? this.endDate),
      type: clearType ? null : (type ?? this.type),
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      search: clearSearch ? null : (search ?? this.search),
      limit: limit ?? this.limit,
    );
  }
}
