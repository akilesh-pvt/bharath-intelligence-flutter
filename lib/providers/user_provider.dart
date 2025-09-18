import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/database_service.dart';
import '../utils/constants.dart';

/// User Provider for User Management
class UserProvider with ChangeNotifier {
  List<UserModel> _users = [];
  bool _isLoading = false;
  String? _error;
  
  /// Getters
  List<UserModel> get users => _users;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  /// Load all users
  Future<void> loadUsers() async {
    _setLoading(true);
    _clearError();
    
    try {
      _users = await DatabaseService.getUsers();
    } catch (e) {
      _setError('Failed to load users: ${e.toString()}');
    }
    
    _setLoading(false);
  }
  
  /// Get user by ID
  Future<UserModel?> getUserById(String id) async {
    try {
      return await DatabaseService.getUserById(id);
    } catch (e) {
      _setError('Failed to get user: ${e.toString()}');
      return null;
    }
  }
  
  /// Create new user
  Future<bool> createUser({
    required String name,
    required String mobile,
    required String passwordHash,
    required String role,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final userData = {
        'name': name,
        'mobile': mobile,
        'password_hash': passwordHash,
        'role': role,
      };
      
      final newUser = await DatabaseService.createUser(userData);
      _users.insert(0, newUser);
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to create user: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }
  
  /// Update user
  Future<bool> updateUser(String id, {
    String? name,
    String? mobile,
    String? role,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final updateData = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      if (name != null) updateData['name'] = name;
      if (mobile != null) updateData['mobile'] = mobile;
      if (role != null) updateData['role'] = role;
      
      final updatedUser = await DatabaseService.updateUser(id, updateData);
      
      final index = _users.indexWhere((user) => user.id == id);
      if (index != -1) {
        _users[index] = updatedUser;
      }
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to update user: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }
  
  /// Delete user
  Future<bool> deleteUser(String id) async {
    _setLoading(true);
    _clearError();
    
    try {
      await DatabaseService.deleteUser(id);
      _users.removeWhere((user) => user.id == id);
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to delete user: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }
  
  /// Get users by role
  List<UserModel> getUsersByRole(String role) {
    return _users.where((user) => user.role == role).toList();
  }
  
  /// Get field visitors
  List<UserModel> getFieldVisitors() {
    return getUsersByRole(AppConstants.fieldVisitorRole);
  }
  
  /// Get admins
  List<UserModel> getAdmins() {
    return getUsersByRole(AppConstants.adminRole);
  }
  
  /// Search users by name or mobile
  List<UserModel> searchUsers(String query) {
    if (query.isEmpty) return _users;
    
    final lowerQuery = query.toLowerCase();
    return _users.where((user) {
      return user.name.toLowerCase().contains(lowerQuery) ||
          user.mobile.contains(query);
    }).toList();
  }
  
  /// Clear error message
  void clearError() {
    _clearError();
  }
  
  /// Refresh users list
  Future<void> refresh() async {
    await loadUsers();
  }
  
  /// Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
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