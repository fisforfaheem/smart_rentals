enum UserRole {
  user,
  admin,
}

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phoneNumber;
  final String pin;
  final DateTime createdAt;
  final UserRole role;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.pin,
    required this.createdAt,
    this.role = UserRole.user,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'pin': pin,
      'createdAt': createdAt.toIso8601String(),
      'role': role.toString(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      pin: json['pin'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      role: json['role'] == UserRole.admin.toString() 
          ? UserRole.admin 
          : UserRole.user,
    );
  }
}
