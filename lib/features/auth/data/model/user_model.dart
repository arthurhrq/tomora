class UserModel {
  final String id;
  final String name;
  final String email;
  final String role; // "MEDICADO" ou "AUXILIAR"
  final String? caregiverId;
  final bool status;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.caregiverId,
    required this.status,
  });

  // Transforma o JSON da API em um objeto UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      caregiverId: json['caregiverId']?.toString(),
      status: json['status'] ?? true,
    );
  }
}