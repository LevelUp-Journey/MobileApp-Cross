// community/domain/entities/paginated_result.dart
class PaginatedResult<T> {
  final List<T> items;
  final int page;
  final int size;
  final int totalElements;
  final bool hasNext;
  final bool hasPrevious;

  const PaginatedResult({
    required this.items,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.hasNext,
    required this.hasPrevious,
  });
}
