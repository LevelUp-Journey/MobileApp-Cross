// iam/infrastructure/repositories_impl/rest_auth_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';
import '../../domain/value_objects/email.dart';
import '../../domain/value_objects/password.dart';

class RestAuthRepository implements AuthRepository {
  final http.Client client;
  final String baseUrl;

  RestAuthRepository(this.client, {required this.baseUrl});

  @override
  Future<User> signUp(Email email, Password password) async {
    final resp = await client.post(
      Uri.parse('$baseUrl/api/v1/authentication/sign-up'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email.value,
        'password': password.value,
      }),
    );

    if (resp.statusCode == 200 || resp.statusCode == 201) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      
      // Validar que al menos el campo id esté presente
      final id = data['id'];
      if (id == null) {
        throw Exception('Invalid response from server: missing id');
      }
      
      // Usar el email de la respuesta si está disponible, sino usar el que se envió
      final emailValue = data['email'] ?? email.value;
      
      return User(
        id: id as String,
        email: Email(emailValue as String),
      );
    } else if (resp.statusCode == 409) {
      throw Exception('User already exists with this email');
    } else if (resp.statusCode == 400) {
      throw Exception('Invalid data provided');
    } else {
      throw Exception('Failed to sign up: Server returned ${resp.statusCode} - ${resp.body}');
    }
  }

  @override
  Future<User> signIn(Email email, Password password) async {
    final resp = await client.post(
      Uri.parse('$baseUrl/api/v1/authentication/sign-in'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email.value,
        'password': password.value,
      }),
    );

    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      
      // Validar que al menos el campo id esté presente
      final id = data['id'];
      if (id == null) {
        throw Exception('Invalid response from server: missing id');
      }
      
      // Usar el email de la respuesta si está disponible, sino usar el que se envió
      final emailValue = data['email'] ?? email.value;
      
      return User(
        id: id as String,
        email: Email(emailValue as String),
      );
    } else if (resp.statusCode == 401) {
      throw Exception('Invalid email or password');
    } else if (resp.statusCode == 400) {
      throw Exception('Invalid data provided');
    } else {
      throw Exception('Failed to sign in: Server returned ${resp.statusCode} - ${resp.body}');
    }
  }

  @override
  Future<User> validateToken(String token) async {
    final resp = await client.get(
      Uri.parse('$baseUrl/api/v1/authentication/validate'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      
      // Validar que los campos requeridos no sean null
      final id = data['id'];
      final emailValue = data['email'];
      
      if (id == null || emailValue == null) {
        throw Exception('Invalid response from server: missing id or email');
      }
      
      return User(
        id: id as String,
        email: Email(emailValue as String),
      );
    } else if (resp.statusCode == 401) {
      throw Exception('Invalid or expired token');
    } else {
      throw Exception('Failed to validate token: Server returned ${resp.statusCode} - ${resp.body}');
    }
  }

  @override
  Future<User> refreshToken(String refreshToken) async {
    final resp = await client.post(
      Uri.parse('$baseUrl/api/v1/authentication/refresh'),
      headers: {
        'Content-Type': 'application/json',
        'refresh_token': refreshToken,
      },
    );

    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      
      // Validar que los campos requeridos no sean null
      final id = data['id'];
      final emailValue = data['email'];
      
      if (id == null || emailValue == null) {
        throw Exception('Invalid response from server: missing id or email');
      }
      
      return User(
        id: id as String,
        email: Email(emailValue as String),
      );
    } else if (resp.statusCode == 401) {
      throw Exception('Invalid or expired refresh token');
    } else {
      throw Exception('Failed to refresh token: Server returned ${resp.statusCode} - ${resp.body}');
    }
  }

  @override
  Future<User?> currentUser() async => null;

  @override
  Future<void> logout() async {
    // Implementar si es necesario limpiar tokens locales
  }
}