import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';
import 'database_service.dart';
import 'storage_service.dart';

/// Custom Authentication Service (No Supabase Auth)
class AuthService {
  static UserModel? _currentUser;
  
  /// Get current authenticated user
  static UserModel? get currentUser => _currentUser;
  
  /// Check if user is logged in
  static bool get isLoggedIn => _currentUser != null;
  
  /// Login with mobile and password
  static Future<UserModel?> loginWithCredentials(
    String mobile, 
    String password,
  ) async {
    try {
      // Get user by mobile number
      final user = await DatabaseService.getUserByMobile(mobile);
      
      if (user == null) {
        throw Exception(AppConstants.errorUserNotFound);
      }
      
      // Get stored password hash from database
      final storedHash = await _getPasswordHash(user.id);
      
      if (storedHash == null) {
        throw Exception(AppConstants.errorInvalidCredentials);
      }
      
      // Verify password
      if (!_verifyPassword(password, storedHash)) {
        throw Exception(AppConstants.errorInvalidCredentials);
      }
      
      // Store session
      await _storeSession(user);
      _currentUser = user;
      
      return user;
    } catch (e) {
      rethrow;
    }
  }
  
  /// Register new user (Admin only)
  static Future<UserModel> registerUser({
    required String name,
    required String mobile,
    required String password,
    required String role,
  }) async {
    try {
      // Check if user already exists
      final existingUser = await DatabaseService.getUserByMobile(mobile);
      if (existingUser != null) {
        throw Exception('User with this mobile number already exists');
      }
      
      // Hash password
      final passwordHash = _generateHash(password);
      
      // Create user data
      final userData = {
        'name': name,
        'mobile': mobile,
        'password_hash': passwordHash,
        'role': role,
      };
      
      // Create user in database
      final user = await DatabaseService.createUser(userData);
      
      return user;
    } catch (e) {
      rethrow;
    }
  }
  
  /// Update user password
  static Future<void> updatePassword(
    String userId, 
    String newPassword,
  ) async {
    try {
      final passwordHash = _generateHash(newPassword);
      
      await DatabaseService.updateUser(userId, {
        'password_hash': passwordHash,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      rethrow;
    }
  }
  
  /// Logout user
  static Future<void> logout() async {
    try {
      await StorageService.clearAll();
      _currentUser = null;
    } catch (e) {
      rethrow;
    }
  }
  
  /// Initialize auth state from storage
  static Future<void> initializeAuth() async {
    try {
      final userId = await StorageService.getString(AppConstants.storageKeyUserId);
      
      if (userId != null) {
        final user = await DatabaseService.getUserById(userId);
        if (user != null) {
          _currentUser = user;
        } else {
          // User not found, clear storage
          await StorageService.clearAll();
        }
      }
    } catch (e) {
      // If there's an error, clear storage and continue
      await StorageService.clearAll();
    }
  }
  
  /// Generate password hash using SHA-256
  static String _generateHash(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
  
  /// Verify password against hash
  static bool _verifyPassword(String password, String hash) {
    return _generateHash(password) == hash;
  }
  
  /// Get password hash from database
  static Future<String?> _getPasswordHash(String userId) async {
    try {
      final response = await DatabaseService._supabase
          .from(AppConstants.profilesTable)
          .select('password_hash')
          .eq('id', userId)
          .maybeSingle();
      
      return response?['password_hash'] as String?;
    } catch (e) {
      return null;
    }
  }
  
  /// Store user session in local storage
  static Future<void> _storeSession(UserModel user) async {
    await StorageService.setString(AppConstants.storageKeyUserId, user.id);
    await StorageService.setString(AppConstants.storageKeyUserRole, user.role);
    await StorageService.setString(AppConstants.storageKeyUserName, user.name);
    await StorageService.setBool(AppConstants.storageKeyIsLoggedIn, true);
  }
  
  /// Validate user role for authorization
  static bool hasRole(String requiredRole) {
    return _currentUser?.role == requiredRole;
  }
  
  /// Check if current user is admin
  static bool get isAdmin => _currentUser?.isAdmin ?? false;
  
  /// Check if current user is field visitor
  static bool get isFieldVisitor => _currentUser?.isFieldVisitor ?? false;
}