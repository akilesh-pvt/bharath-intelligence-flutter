import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';

/// Authentication Provider for State Management
class AuthProvider with ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;
  
  /// Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.isAdmin ?? false;
  bool get isFieldVisitor => _currentUser?.isFieldVisitor ?? false;
  
  /// Initialize authentication state
  Future<void> initialize() async {
    _setLoading(true);
    try {
      await AuthService.initializeAuth();
      _currentUser = AuthService.currentUser;
      _clearError();
    } catch (e) {
      _setError('Failed to initialize authentication');
    }
    _setLoading(false);
  }
  
  /// Login with credentials
  Future<bool> login(String mobile, String password) async {
    _setLoading(true);
    _clearError();
    
    try {
      final user = await AuthService.loginWithCredentials(mobile, password);
      if (user != null) {
        _currentUser = user;
        _setLoading(false);
        return true;
      } else {
        _setError(AppConstants.errorInvalidCredentials);
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError(_getErrorMessage(e));
      _setLoading(false);
      return false;
    }
  }
  
  /// Register new user (Admin only)
  Future<bool> registerUser({
    required String name,
    required String mobile,
    required String password,
    required String role,
  }) async {
    if (!isAdmin) {
      _setError('Only admins can create users');
      return false;
    }
    
    _setLoading(true);
    _clearError();
    
    try {
      await AuthService.registerUser(
        name: name,
        mobile: mobile,
        password: password,
        role: role,
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(_getErrorMessage(e));
      _setLoading(false);
      return false;
    }
  }
  
  /// Update password
  Future<bool> updatePassword(String newPassword) async {
    if (_currentUser == null) {
      _setError('No user logged in');
      return false;
    }
    
    _setLoading(true);
    _clearError();
    
    try {
      await AuthService.updatePassword(_currentUser!.id, newPassword);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(_getErrorMessage(e));
      _setLoading(false);
      return false;
    }
  }
  
  /// Logout user
  Future<void> logout() async {
    _setLoading(true);
    try {
      await AuthService.logout();
      _currentUser = null;
      _clearError();
    } catch (e) {
      _setError('Failed to logout');
    }
    _setLoading(false);
  }
  
  /// Update current user data
  void updateUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }
  
  /// Clear error message
  void clearError() {
    _clearError();
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
  
  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('User with this mobile number already exists')) {
      return 'User with this mobile number already exists';
    }
    if (error.toString().contains('Invalid mobile number or password')) {
      return AppConstants.errorInvalidCredentials;
    }
    if (error.toString().contains('User not found')) {
      return AppConstants.errorUserNotFound;
    }
    return AppConstants.errorGeneric;
  }
}