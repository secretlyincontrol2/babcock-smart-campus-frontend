class UserModel {
  final int id;
  final String studentId;
  final String email;
  final String fullName;
  final String department;
  final String level;
  final String? phoneNumber;
  final String? profilePicture;
  final bool isActive;
  final bool isVerified;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.studentId,
    required this.email,
    required this.fullName,
    required this.department,
    required this.level,
    this.phoneNumber,
    this.profilePicture,
    required this.isActive,
    required this.isVerified,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      studentId: json['student_id'],
      email: json['email'],
      fullName: json['full_name'],
      department: json['department'],
      level: json['level'],
      phoneNumber: json['phone_number'],
      profilePicture: json['profile_picture'],
      isActive: json['is_active'],
      isVerified: json['is_verified'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'email': email,
      'full_name': fullName,
      'department': department,
      'level': level,
      'phone_number': phoneNumber,
      'profile_picture': profilePicture,
      'is_active': isActive,
      'is_verified': isVerified,
      'created_at': createdAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    int? id,
    String? studentId,
    String? email,
    String? fullName,
    String? department,
    String? level,
    String? phoneNumber,
    String? profilePicture,
    bool? isActive,
    bool? isVerified,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      department: department ?? this.department,
      level: level ?? this.level,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      isActive: isActive ?? this.isActive,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, studentId: $studentId, email: $email, fullName: $fullName, department: $department, level: $level)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class RegisterRequest {
  final String studentId;
  final String email;
  final String fullName;
  final String password;
  final String department;
  final String level;
  final String? phoneNumber;

  RegisterRequest({
    required this.studentId,
    required this.email,
    required this.fullName,
    required this.password,
    required this.department,
    required this.level,
    this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'email': email,
      'full_name': fullName,
      'password': password,
      'department': department,
      'level': level,
      'phone_number': phoneNumber,
    };
  }
}

class AuthResponse {
  final String accessToken;
  final String tokenType;
  final UserModel user;

  AuthResponse({
    required this.accessToken,
    required this.tokenType,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'],
      tokenType: json['token_type'],
      user: UserModel.fromJson(json['user']),
    );
  }
} 