class HistoryModel {
  final int id;
  final int userId;
  final int reminderId;
  final DateTime scheduledFor;
  final DateTime? takenAt;
  final bool taken;

  HistoryModel({
    required this.id,
    required this.userId,
    required this.reminderId,
    required this.scheduledFor,
    this.takenAt,
    required this.taken,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      id: json['id'],
      userId: json['userId'],
      reminderId: json['reminderId'],
      scheduledFor: DateTime.parse(json['scheduledFor']),
      takenAt: json['takenAt'] != null
          ? DateTime.parse(json['takenAt'])
          : null,
      taken: json['taken'],
    );
  }
}