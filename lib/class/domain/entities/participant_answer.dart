// class/domain/entities/participant_answer.dart
class ParticipantAnswer {
  final int id;
  final int questionId;
  final List<int> selectedAnswerIds;
  final DateTime answeredAt;
  final bool isCorrect;
  final int pointsEarned;
  final double timeTakenSeconds;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ParticipantAnswer({
    required this.id,
    required this.questionId,
    required this.selectedAnswerIds,
    required this.answeredAt,
    required this.isCorrect,
    required this.pointsEarned,
    required this.timeTakenSeconds,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ParticipantAnswer && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
