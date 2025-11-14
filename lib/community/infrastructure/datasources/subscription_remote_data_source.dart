// community/infrastructure/datasources/subscription_remote_data_source.dart
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../shared/environments/environment.dart';
import '../../../shared/services/base_service.dart';
import '../../domain/requests/subscription_requests.dart';
import '../dtos/paginated_response_dto.dart';
import '../dtos/subscription_dto.dart';

class SubscriptionRemoteDataSource extends BaseService {
  SubscriptionRemoteDataSource(http.Client client, {required String baseUrl})
    : super(client, baseUrl: baseUrl);

  Future<SubscriptionDto> createSubscription({
    required String token,
    required CreateSubscriptionRequest request,
  }) async {
    final response = await client.post(
      buildUri(Environment.subscriptionsEndpoint),
      headers: authorizedHeaders(token),
      body: jsonEncode({'communityId': request.communityId}),
    );
    ensureSuccess(response, allowedStatusCodes: const [200, 201]);
    return SubscriptionDto.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<bool> deleteSubscription(String subscriptionId, String token) async {
    final response = await client.delete(
      buildUri('${Environment.subscriptionsEndpoint}/$subscriptionId'),
      headers: authorizedHeaders(token),
    );

    if (response.statusCode == 404) {
      return false;
    }

    ensureSuccess(response, allowedStatusCodes: const [200, 204]);
    return true;
  }

  Future<List<SubscriptionDto>> getSubscriptionsByCommunity(
    String communityId,
    String token,
  ) async {
    final response = await client.get(
      buildUri(Environment.subscriptionsByCommunity(communityId)),
      headers: authorizedHeaders(token),
    );
    ensureSuccess(response, allowedStatusCodes: const [200]);
    final data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((json) => SubscriptionDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<PaginatedResponseDto<SubscriptionDto>> getSubscriptionsByUser(
    SubscriptionByUserQuery query,
    String token,
  ) async {
    final response = await client.get(
      buildUri(
        Environment.subscriptionsByUser(query.userId),
        queryParameters: {
          'page': query.pagination.page.toString(),
          'size': query.pagination.size.toString(),
        },
      ),
      headers: authorizedHeaders(token),
    );
    ensureSuccess(response, allowedStatusCodes: const [200]);
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return PaginatedResponseDto<SubscriptionDto>.fromJson(
      data,
      (json) => SubscriptionDto.fromJson(json),
    );
  }
}
