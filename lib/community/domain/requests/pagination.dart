// community/domain/requests/pagination.dart
class PaginationQuery {
  final int page;
  final int size;

  const PaginationQuery({this.page = 0, this.size = 20});
}

class OffsetQuery {
  final int limit;
  final int offset;

  const OffsetQuery({this.limit = 20, this.offset = 0});
}
