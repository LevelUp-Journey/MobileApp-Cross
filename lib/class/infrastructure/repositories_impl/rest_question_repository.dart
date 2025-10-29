// class/infrastructure/repositories_impl/rest_question_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/question.dart';
import '../../domain/entities/answer.dart';
import '../../domain/repositories/question_repository.dart';

class RestQuestionRepository implements QuestionRepository {
  final http.Client client;
  final String baseUrl;

  RestQuestionRepository(this.client, {required this.baseUrl});

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
  Future<Question> getQuestionById({
    required int quizId,
    required int questionId,
    required String userId,
    required String token,
    required String userRole,
  }) async {
    final uri = Uri.parse(
      '$baseUrl/api/v1/quizzes/$quizId/questions/$questionId',
    ).replace(queryParameters: {'userId': userId});

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
      throw Exception('Failed to get question: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return _parseQuestion(data);
  }

  // Helper methods to parse JSON to domain entities
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