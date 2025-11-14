// community/infrastructure/datasources/feed_remote_data_source.dart
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../shared/environments/environment.dart';
import '../../../shared/services/base_service.dart';
import '../../domain/requests/feed_requests.dart';
import '../dtos/feed_entry_dto.dart';

class FeedRemoteDataSource extends BaseService {
  FeedRemoteDataSource(http.Client client, {required String baseUrl})
      : super(client, baseUrl: baseUrl);

  Future<List<FeedEntryDto>> getUserFeed(UserFeedQuery query, String token) async {
    final response = await client.get(
      buildUri(
        Environment.feedByUser(query.userId),
        queryParameters: {
          'limit': query.offsetQuery.limit.toString(),
          'offset': query.offsetQuery.offset.toString(),
        },
      ),
      headers: authorizedHeaders(token),
    );
    ensureSuccess(response, allowedStatusCodes: const [200]);
    final data = jsonDecode(response.body) as List<dynamic>;
    return data.map((json) => FeedEntryDto.fromJson(json as Map<String, dynamic>)).toList();
  }
}
