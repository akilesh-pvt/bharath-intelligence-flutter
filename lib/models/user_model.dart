import '../utils/constants.dart';

/// User Model for Authentication and Profile Management
class UserModel {
  final String id;
  final String name;
  final String mobile;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.mobile,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      mobile: json['mobile'] as String,
      role: json['role'] as String? ?? AppConstants.fieldVisitorRole,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mobile': mobile,
      'role': role,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Convert UserModel to JSON for database insert
  Map<String, dynamic> toInsertJson() {
    return {
      'name': name,
      'mobile': mobile,
      'role': role,
    };
  }

  /// Check if user is admin
  bool get isAdmin => role == AppConstants.adminRole;

  /// Check if user is field visitor
  bool get isFieldVisitor => role == AppConstants.fieldVisitorRole;

  /// Create a copy with updated fields
  UserModel copyWith({
    String? id,
    String? name,
    String? mobile,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.id == id &&
        other.name == name &&
        other.mobile == mobile &&
        other.role == role;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        mobile.hashCode ^
        role.hashCode;
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, mobile: $mobile, role: $role)';
  }
}