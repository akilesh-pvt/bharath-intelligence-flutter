import '../utils/constants.dart';
import 'task_model.dart';
import 'user_model.dart';

/// Claim Model for Financial Management
class ClaimModel {
  final int id;
  final int taskId;
  final String visitorId;
  final double amount;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Related models (populated when needed)
  final TaskModel? task;
  final UserModel? visitor;

  const ClaimModel({
    required this.id,
    required this.taskId,
    required this.visitorId,
    required this.amount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.task,
    this.visitor,
  });

  /// Create ClaimModel from JSON
  factory ClaimModel.fromJson(Map<String, dynamic> json) {
    return ClaimModel(
      id: json['id'] as int,
      taskId: json['task_id'] as int,
      visitorId: json['visitor_id'] as String,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? AppConstants.claimSubmitted,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      task: json['tasks'] != null 
          ? TaskModel.fromJson(json['tasks'] as Map<String, dynamic>)
          : null,
      visitor: json['visitor'] != null 
          ? UserModel.fromJson(json['visitor'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Convert ClaimModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task_id': taskId,
      'visitor_id': visitorId,
      'amount': amount,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Convert ClaimModel to JSON for database insert
  Map<String, dynamic> toInsertJson() {
    return {
      'task_id': taskId,
      'visitor_id': visitorId,
      'amount': amount,
      'status': status,
    };
  }

  /// Check if claim is submitted
  bool get isSubmitted => status == AppConstants.claimSubmitted;

  /// Check if claim is approved
  bool get isApproved => status == AppConstants.claimApproved;

  /// Check if claim is rejected
  bool get isRejected => status == AppConstants.claimRejected;

  /// Get task title (from related task or empty string)
  String get taskTitle => task?.title ?? '';

  /// Get visitor name (from related visitor or empty string)
  String get visitorName => visitor?.name ?? '';

  /// Create a copy with updated fields
  ClaimModel copyWith({
    int? id,
    int? taskId,
    String? visitorId,
    double? amount,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    TaskModel? task,
    UserModel? visitor,
  }) {
    return ClaimModel(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      visitorId: visitorId ?? this.visitorId,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      task: task ?? this.task,
      visitor: visitor ?? this.visitor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ClaimModel &&
        other.id == id &&
        other.taskId == taskId &&
        other.visitorId == visitorId &&
        other.amount == amount &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        taskId.hashCode ^
        visitorId.hashCode ^
        amount.hashCode ^
        status.hashCode;
  }

  @override
  String toString() {
    return 'ClaimModel(id: $id, taskId: $taskId, amount: $amount, status: $status)';
  }
}