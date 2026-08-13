enum ReminderStatus {
  pending,
  taken,
  missed,
}

class ReminderModel {
  final int id;
  final int userId;
  final String name;
  final String dosage;
  final String? desc;
  final String time;
  final String? daysOfWeek;
  final bool active;
  final bool callAlexa;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReminderModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.dosage,
    this.desc,
    required this.time,
    this.daysOfWeek,
    required this.active,
    required this.callAlexa,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      dosage: json['dosage'],
      desc: json['desc'],
      time: json['time'],
      daysOfWeek: json['daysOfWeek'],
      active: json['active'],
      callAlexa: json['callAlexa'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}