// class/domain/entities/live_session.dart
import 'session_participant.dart';

class LiveSession {
  final int id;
  final int quizId;
  final String sessionCode;
  final String state; // STARTING, IN_PROGRESS, FINISHED
  final String hostId;
  final DateTime? startedAt;
  final DateTime? finishedAt;
  final int currentQuestionIndex;
  final DateTime? currentQuestionStartedAt;
  final bool autoAdvanceQuestions;
  final List<SessionParticipant> participants;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LiveSession({
    required this.id,
    required this.quizId,
    required this.sessionCode,
    required this.state,
    required this.hostId,
    this.startedAt,
    this.finishedAt,
    required this.currentQuestionIndex,
    this.currentQuestionStartedAt,
    required this.autoAdvanceQuestions,
    this.participants = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isActive => state == 'IN_PROGRESS';
  bool get isFinished => state == 'FINISHED';
  String get sessionStatus => state;
  int get activeParticipantsCount =>
      participants.where((p) => p.isCurrentlyActive).length;
  List<SessionParticipant> get activeParticipants =>
      participants.where((p) => p.isCurrentlyActive).toList();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is LiveSession && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
