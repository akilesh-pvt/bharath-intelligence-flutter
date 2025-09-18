import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../models/claim_model.dart';
import '../services/database_service.dart';
import '../utils/constants.dart';

/// Task Provider for Task Management
class TaskProvider with ChangeNotifier {
  List<TaskModel> _tasks = [];
  List<ClaimModel> _claims = [];
  Map<String, int> _dashboardStats = {};
  bool _isLoading = false;
  bool _isLoadingClaims = false;
  bool _isLoadingStats = false;
  String? _error;
  
  /// Getters
  List<TaskModel> get tasks => _tasks;
  List<ClaimModel> get claims => _claims;
  Map<String, int> get dashboardStats => _dashboardStats;
  bool get isLoading => _isLoading;
  bool get isLoadingClaims => _isLoadingClaims;
  bool get isLoadingStats => _isLoadingStats;
  String? get error => _error;
  
  /// Load tasks
  Future<void> loadTasks({String? assignedTo, String? status}) async {
    _setLoading(true);
    _clearError();
    
    try {
      _tasks = await DatabaseService.getTasks(
        assignedTo: assignedTo,
        status: status,
      );
    } catch (e) {
      _setError('Failed to load tasks: ${e.toString()}');
    }
    
    _setLoading(false);
  }
  
  /// Load user's tasks
  Future<void> loadMyTasks(String userId) async {
    await loadTasks(assignedTo: userId);
  }
  
  /// Load pending tasks
  Future<void> loadPendingTasks() async {
    await loadTasks(status: AppConstants.taskPending);
  }
  
  /// Get task by ID
  Future<TaskModel?> getTaskById(int id) async {
    try {
      return await DatabaseService.getTaskById(id);
    } catch (e) {
      _setError('Failed to get task: ${e.toString()}');
      return null;
    }
  }
  
  /// Create new task
  Future<bool> createTask({
    required String title,
    required int farmerId,
    required String assignedTo,
    String? createdBy,
    String? notes,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final taskData = {
        'title': title,
        'farmer_id': farmerId,
        'assigned_to': assignedTo,
        'created_by': createdBy,
        'status': AppConstants.taskPending,
        'notes': notes,
      };
      
      final newTask = await DatabaseService.createTask(taskData);
      _tasks.insert(0, newTask);
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to create task: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }
  
  /// Update task
  Future<bool> updateTask(int id, {
    String? title,
    String? status,
    String? notes,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final updateData = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      if (title != null) updateData['title'] = title;
      if (status != null) updateData['status'] = status;
      if (notes != null) updateData['notes'] = notes;
      
      final updatedTask = await DatabaseService.updateTask(id, updateData);
      
      final index = _tasks.indexWhere((task) => task.id == id);
      if (index != -1) {
        _tasks[index] = updatedTask;
      }
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to update task: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }
  
  /// Complete task
  Future<bool> completeTask(int id, {String? notes}) async {
    return await updateTask(
      id,
      status: AppConstants.taskCompleted,
      notes: notes,
    );
  }
  
  /// Delete task
  Future<bool> deleteTask(int id) async {
    _setLoading(true);
    _clearError();
    
    try {
      await DatabaseService.deleteTask(id);
      _tasks.removeWhere((task) => task.id == id);
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to delete task: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }
  
  /// Load claims
  Future<void> loadClaims({String? visitorId, String? status}) async {
    _setLoadingClaims(true);
    _clearError();
    
    try {
      _claims = await DatabaseService.getClaims(
        visitorId: visitorId,
        status: status,
      );
    } catch (e) {
      _setError('Failed to load claims: ${e.toString()}');
    }
    
    _setLoadingClaims(false);
  }
  
  /// Load user's claims
  Future<void> loadMyClaims(String userId) async {
    await loadClaims(visitorId: userId);
  }
  
  /// Submit claim
  Future<bool> submitClaim({
    required int taskId,
    required String visitorId,
    required double amount,
  }) async {
    _setLoadingClaims(true);
    _clearError();
    
    try {
      final claimData = {
        'task_id': taskId,
        'visitor_id': visitorId,
        'amount': amount,
        'status': AppConstants.claimSubmitted,
      };
      
      final newClaim = await DatabaseService.createClaim(claimData);
      _claims.insert(0, newClaim);
      
      _setLoadingClaims(false);
      return true;
    } catch (e) {
      _setError('Failed to submit claim: ${e.toString()}');
      _setLoadingClaims(false);
      return false;
    }
  }
  
  /// Update claim status (Admin only)
  Future<bool> updateClaimStatus(int id, String status) async {
    _setLoadingClaims(true);
    _clearError();
    
    try {
      final updateData = {
        'status': status,
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      final updatedClaim = await DatabaseService.updateClaim(id, updateData);
      
      final index = _claims.indexWhere((claim) => claim.id == id);
      if (index != -1) {
        _claims[index] = updatedClaim;
      }
      
      _setLoadingClaims(false);
      return true;
    } catch (e) {
      _setError('Failed to update claim: ${e.toString()}');
      _setLoadingClaims(false);
      return false;
    }
  }
  
  /// Load dashboard statistics
  Future<void> loadDashboardStats({String? userId}) async {
    _setLoadingStats(true);
    _clearError();
    
    try {
      _dashboardStats = await DatabaseService.getDashboardStats(userId: userId);
    } catch (e) {
      _setError('Failed to load dashboard stats: ${e.toString()}');
    }
    
    _setLoadingStats(false);
  }
  
  /// Get tasks by status
  List<TaskModel> getTasksByStatus(String status) {
    return _tasks.where((task) => task.status == status).toList();
  }
  
  /// Get pending tasks
  List<TaskModel> getPendingTasks() {
    return getTasksByStatus(AppConstants.taskPending);
  }
  
  /// Get completed tasks
  List<TaskModel> getCompletedTasks() {
    return getTasksByStatus(AppConstants.taskCompleted);
  }
  
  /// Get claims by status
  List<ClaimModel> getClaimsByStatus(String status) {
    return _claims.where((claim) => claim.status == status).toList();
  }
  
  /// Clear error message
  void clearError() {
    _clearError();
  }
  
  /// Refresh all data
  Future<void> refresh({String? userId}) async {
    await Future.wait([
      loadTasks(),
      loadClaims(),
      loadDashboardStats(userId: userId),
    ]);
  }
  
  /// Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setLoadingClaims(bool loading) {
    _isLoadingClaims = loading;
    notifyListeners();
  }
  
  void _setLoadingStats(bool loading) {
    _isLoadingStats = loading;
    notifyListeners();
  }
  
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }
  
  void _clearError() {
    _error = null;
    notifyListeners();
  }
}