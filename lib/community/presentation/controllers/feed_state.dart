// community/presentation/controllers/feed_state.dart
import '../../domain/entities/feed_entry.dart';

class FeedState {
  final bool loading;
  final List<FeedEntry> entries;
  final String? error;

  const FeedState({
    this.loading = false,
    this.entries = const [],
    this.error,
  });

  FeedState copyWith({
    bool? loading,
    List<FeedEntry>? entries,
    String? error,
  }) {
    return FeedState(
      loading: loading ?? this.loading,
      entries: entries ?? this.entries,
      error: error,
    );
  }
}
