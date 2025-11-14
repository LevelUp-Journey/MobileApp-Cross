// community/presentation/controllers/feed_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../iam/presentation/controllers/providers.dart';
import '../../application/use_cases/get_user_feed_use_case.dart';
import '../../domain/requests/feed_requests.dart';
import '../../domain/requests/pagination.dart';
import 'feed_state.dart';
import 'providers.dart';

class FeedController extends Notifier<FeedState> {
  @override
  FeedState build() => const FeedState();

  Future<void> fetchUserFeed(String userId, {OffsetQuery offset = const OffsetQuery()}) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final useCase = ref.read(getUserFeedUseCaseProvider);
      final token = _requireToken();
      final entries = await useCase.execute(
        UserFeedQuery(userId: userId, offsetQuery: offset),
        token: token,
      );
      state = state.copyWith(loading: false, entries: entries);
    } catch (error) {
      state = state.copyWith(loading: false, error: error.toString());
    }
  }

  String _requireToken() {
    final authState = ref.read(authControllerProvider);
    final token = authState.token ?? authState.user?.token;
    if (token == null) throw Exception('User not authenticated');
    return token;
  }
}
