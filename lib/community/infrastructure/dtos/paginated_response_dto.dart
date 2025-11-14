// community/infrastructure/dtos/paginated_response_dto.dart
import '../../domain/entities/paginated_result.dart';

class PaginatedResponseDto<T> {
  final List<T> items;
  final int page;
  final int size;
  final int totalElements;
  final bool hasNext;
  final bool hasPrevious;

  const PaginatedResponseDto({
    required this.items,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory PaginatedResponseDto.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) mapper,
  ) {
    final rawItems = json['items'] as List<dynamic>? ??
        json['content'] as List<dynamic>? ??
        json['data'] as List<dynamic>? ??
        const [];

    return PaginatedResponseDto(
      items: rawItems.map((item) => mapper(item as Map<String, dynamic>)).toList(),
      page: json['page'] == null ? 0 : int.tryParse(json['page'].toString()) ?? 0,
      size: json['size'] == null ? rawItems.length : int.tryParse(json['size'].toString()) ?? rawItems.length,
      totalElements: json['totalElements'] == null
          ? rawItems.length
          : int.tryParse(json['totalElements'].toString()) ?? rawItems.length,
      hasNext: json['hasNext'] == true,
      hasPrevious: json['hasPrevious'] == true,
    );
  }

  PaginatedResult<R> toDomain<R>(List<R> domainItems) => PaginatedResult<R>(
        items: domainItems,
        page: page,
        size: size,
        totalElements: totalElements,
        hasNext: hasNext,
        hasPrevious: hasPrevious,
      );
}
