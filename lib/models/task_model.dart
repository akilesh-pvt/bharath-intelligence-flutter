import '../utils/constants.dart';
import 'farmer_model.dart';
import 'user_model.dart';

/// Task Model for Field Management
class TaskModel {
  final int id;
  final String title;
  final int farmerId;
  final String assignedTo;
  final String? createdBy;
  final String status;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Related models (populated when needed)
  final FarmerModel? farmer;
  final UserModel? assignedUser;
  final UserModel? createdByUser;

  const TaskModel({
    required this.id,
    required this.title,
    required this.farmerId,
    required this.assignedTo,
    this.createdBy,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.farmer,
    this.assignedUser,
    this.createdByUser,
  });

  /// Create TaskModel from JSON
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as int,
      title: json['title'] as String,
      farmerId: json['farmer_id'] as int,
      assignedTo: json['assigned_to'] as String,
      createdBy: json['created_by'] as String?,
      status: json['status'] as String? ?? AppConstants.taskPending,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      farmer: json['farmers'] != null 
          ? FarmerModel.fromJson(json['farmers'] as Map<String, dynamic>)
          : null,
      assignedUser: json['assigned_user'] != null 
          ? UserModel.fromJson(json['assigned_user'] as Map<String, dynamic>)
          : null,
      createdByUser: json['created_by_user'] != null 
          ? UserModel.fromJson(json['created_by_user'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Convert TaskModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'farmer_id': farmerId,
      'assigned_to': assignedTo,
      'created_by': createdBy,
      'status': status,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Convert TaskModel to JSON for database insert
  Map<String, dynamic> toInsertJson() {
    return {
      'title': title,
      'farmer_id': farmerId,
      'assigned_to': assignedTo,
      'created_by': createdBy,
      'status': status,
      'notes': notes,
    };
  }

  /// Check if task is pending
  bool get isPending => status == AppConstants.taskPending;

  /// Check if task is completed
  bool get isCompleted => status == AppConstants.taskCompleted;

  /// Get farmer name (from related farmer or empty string)
  String get farmerName => farmer?.name ?? '';

  /// Get assigned user name (from related user or empty string)
  String get assignedUserName => assignedUser?.name ?? '';

  /// Create a copy with updated fields
  TaskModel copyWith({
    int? id,
    String? title,
    int? farmerId,
    String? assignedTo,
    String? createdBy,
    String? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    FarmerModel? farmer,
    UserModel? assignedUser,
    UserModel? createdByUser,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      farmerId: farmerId ?? this.farmerId,
      assignedTo: assignedTo ?? this.assignedTo,
      createdBy: createdBy ?? this.createdBy,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      farmer: farmer ?? this.farmer,
      assignedUser: assignedUser ?? this.assignedUser,
      createdByUser: createdByUser ?? this.createdByUser,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TaskModel &&
        other.id == id &&
        other.title == title &&
        other.farmerId == farmerId &&
        other.assignedTo == assignedTo &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        farmerId.hashCode ^
        assignedTo.hashCode ^
        status.hashCode;
  }

  @override
  String toString() {
    return 'TaskModel(id: $id, title: $title, farmerId: $farmerId, status: $status)';
  }
}