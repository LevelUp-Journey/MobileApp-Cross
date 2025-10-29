// class/infrastructure/repositories_impl/rest_quiz_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/repositories/quiz_repository.dart';
import '../../domain/entities/quiz.dart';
import '../../domain/entities/question.dart';
import '../../domain/entities/answer.dart';

class RestQuizRepository implements QuizRepository {
  final http.Client client;
  final String baseUrl;

  RestQuizRepository(this.client, {required this.baseUrl});

  @override
  Future<int> createQuiz({
    required String name,
    required String description,
    required String category,
    String? coverImageUrl,
    required String creatorId,
    required String token,
    required String userRole,
  }) async {
    final url = '$baseUrl/api/v1/quizzes';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'X-User-Id': creatorId,
      'X-User-Role': userRole,
    };
    final bodyData = {
      'name': name,
      'description': description,
      'category': category,
      'coverImageUrl': coverImageUrl,
      'creatorId': creatorId,
    };

    try {
      final response = await client.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(bodyData),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to create quiz: ${response.statusCode} - ${response.body}');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['id'] as int;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Quiz> getQuizById({
    required int quizId,
    required String userId,
    required String token,
    required String userRole,
    bool includeQuestions = true,
  }) async {
    final uri = Uri.parse('$baseUrl/api/v1/quizzes/$quizId').replace(
      queryParameters: {
        'userId': userId,
        'includeQuestions': includeQuestions.toString(),
      },
    );

    final response = await client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'X-User-Id': userId,
        'X-User-Role': userRole,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get quiz: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return _parseQuiz(data);
  }

  @override
  Future<void> updateQuiz({
    required int quizId,
    required String name,
    required String description,
    required String category,
    String? coverImageUrl,
    required String userId,
    required String token,
    required String userRole,
  }) async {
    final url = '$baseUrl/api/v1/quizzes/$quizId';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'X-User-Id': userId,
      'X-User-Role': userRole,
    };
    final bodyData = {
      'name': name,
      'description': description,
      'category': category,
      'coverImageUrl': coverImageUrl,
      'userId': userId,
    };

    final response = await client.put(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(bodyData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update quiz: ${response.statusCode} - ${response.body}');
    }
  }

  @override
  Future<void> deleteQuiz({
    required int quizId,
    required String userId,
    required String token,
    required String userRole,
  }) async {
    final uri = Uri.parse('$baseUrl/api/v1/quizzes/$quizId').replace(
      queryParameters: {'userId': userId},
    );

    final response = await client.delete(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'X-User-Id': userId,
        'X-User-Role': userRole,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete quiz: ${response.statusCode} - ${response.body}');
    }
  }

  @override
  Future<void> addQuestion({
    required int quizId,
    required String questionText,
    required String questionType,
    required int timeLimit,
    required int points,
    required List<String> answers,
    required int correctAnswerIndex,
    String? mediaUrl,
    required String userId,
    required String token,
    required String userRole,
  }) async {
    final response = await client.post(
      Uri.parse('$baseUrl/api/v1/quizzes/$quizId/questions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'X-User-Id': userId,
        'X-User-Role': userRole,
      },
      body: jsonEncode({
        'questionText': questionText,
        'questionType': questionType,
        'timeLimit': timeLimit,
        'points': points,
        'answers': answers,
        'correctAnswerIndex': correctAnswerIndex,
        'mediaUrl': mediaUrl,
        'userId': userId,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add question: ${response.statusCode}');
    }

    // Question added successfully, no need to return id since it's not used
  }

  @override
  Future<void> updateQuestion({
    required int quizId,
    required int questionId,
    required String questionText,
    required String questionType,
    required int timeLimit,
    required int points,
    required List<String> answers,
    required int correctAnswerIndex,
    String? mediaUrl,
    required String userId,
    required String token,
    required String userRole,
  }) async {
    final response = await client.put(
      Uri.parse('$baseUrl/api/v1/quizzes/$quizId/questions/$questionId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'X-User-Id': userId,
        'X-User-Role': userRole,
      },
      body: jsonEncode({
        'questionText': questionText,
        'questionType': questionType,
        'timeLimit': timeLimit,
        'points': points,
        'answers': answers,
        'correctAnswerIndex': correctAnswerIndex,
        'mediaUrl': mediaUrl,
        'userId': userId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update question: ${response.statusCode}');
    }
  }

  @override
  Future<void> deleteQuestion({
    required int quizId,
    required int questionId,
    required String userId,
    required String token,
    required String userRole,
  }) async {
    final uri = Uri.parse(
      '$baseUrl/api/v1/quizzes/$quizId/questions/$questionId',
    ).replace(queryParameters: {'userId': userId});

    final response = await client.delete(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'X-User-Id': userId,
        'X-User-Role': userRole,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete question: ${response.statusCode}');
    }
  }

  @override
  Future<void> publishQuiz({
    required int quizId,
    required String userId,
    required String token,
    required String userRole,
  }) async {
    final uri = Uri.parse('$baseUrl/api/v1/quizzes/$quizId/publish').replace(
      queryParameters: {'userId': userId},
    );

    final response = await client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'X-User-Id': userId,
        'X-User-Role': userRole,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to publish quiz: ${response.statusCode}');
    }
  }

  @override
  Future<List<Quiz>> getPublicQuizzes({
    String? category,
    String? search,
    int page = 0,
    int size = 20,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'size': size.toString(),
    };

    if (category != null) queryParams['category'] = category;
    if (search != null) queryParams['search'] = search;

    final uri = Uri.parse('$baseUrl/api/v1/quizzes/public').replace(
      queryParameters: queryParams,
    );

    final response = await client.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to get public quizzes: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final content = data['content'] as List<dynamic>;
    return content.map((json) => _parseQuiz(json as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<Quiz>> getMyQuizzes({
    required String userId,
    required String token,
    required String userRole,
    String? category,
    String? search,
    int page = 0,
    int size = 20,
  }) async {
    final queryParams = <String, String>{
      'userId': userId,
      'page': page.toString(),
      'size': size.toString(),
    };

    if (category != null) queryParams['category'] = category;
    if (search != null) queryParams['search'] = search;

    final uri = Uri.parse('$baseUrl/api/v1/quizzes/my-quizzes').replace(
      queryParameters: queryParams,
    );

    final response = await client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'X-User-Id': userId,
        'X-User-Role': userRole,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get my quizzes: ${response.statusCode} - ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final content = data['content'] as List<dynamic>;
    return content.map((json) => _parseQuiz(json as Map<String, dynamic>)).toList();
  }

  // Helper methods to parse JSON to domain entities
  Quiz _parseQuiz(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      coverImageUrl: json['coverImageUrl'] as String?,
      category: json['category'] as String,
      visibility: json['visibility'] as String,
      creatorId: (json['creatorId'] as Map<String, dynamic>)['value'] as String,
      questions: (json['questions'] as List<dynamic>?)
              ?.map((q) => _parseQuestion(q as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Question _parseQuestion(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as int,
      content: json['content'] as String,
      contentType: json['contentType'] as String,
      questionType: json['questionType'] as String,
      points: json['points'] as int,
      timeLimitSeconds: json['timeLimitSeconds'] as int,
      questionOrder: json['questionOrder'] as int,
      answers: (json['answers'] as List<dynamic>)
          .map((a) => _parseAnswer(a as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Answer _parseAnswer(Map<String, dynamic> json) {
    return Answer(
      id: json['id'] as int,
      content: json['content'] as String,
      contentType: json['contentType'] as String,
      isCorrect: json['isCorrect'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
