// class/domain/entities/session_participant.dart
import 'participant_answer.dart';

class SessionParticipant {
  final int id;
  final String userId;
  final String userRole; // ROLE_ADMIN, ROLE_TEACHER, ROLE_STUDENT
  final DateTime joinedAt;
  final DateTime? leftAt;
  final int totalScore;
  final bool isActive;
  final List<ParticipantAnswer> answers;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SessionParticipant({
    required this.id,
    required this.userId,
    required this.userRole,
    required this.joinedAt,
    this.leftAt,
    required this.totalScore,
    required this.isActive,
    this.answers = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isTeacher => userRole.contains('TEACHER') || userRole.contains('ADMIN');
  bool get isStudent => userRole.contains('STUDENT');
  bool get isCurrentlyActive => isActive && leftAt == null;
  int get totalAnswersCount => answers.length;
  int get correctAnswersCount => answers.where((a) => a.isCorrect).length;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionParticipant && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
