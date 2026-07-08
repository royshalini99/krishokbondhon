/// Generic paginated envelope shared by feed, comments, and question lists.
/// Mirrors the `{ items, nextCursor, hasMore }` shape in API_CONTRACT.md.
class Paginated<T> {
  final List<T> items;
  final String? nextCursor;
  final bool hasMore;

  const Paginated({required this.items, this.nextCursor, this.hasMore = false});

  factory Paginated.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return Paginated(
      items: (json['items'] as List? ?? const [])
          .map((e) => fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['nextCursor'] as String?,
      hasMore: json['hasMore'] as bool? ?? false,
    );
  }
}
