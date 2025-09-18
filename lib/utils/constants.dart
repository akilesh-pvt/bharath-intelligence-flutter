/// App Constants and Configuration
class AppConstants {
  // App Information
  static const String appName = 'Bharath Intelligence';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Agricultural Field Management System';
  
  // Timing Constants
  static const int splashDuration = 3; // seconds
  static const int animationDuration = 300; // milliseconds
  static const int longAnimationDuration = 2000; // milliseconds
  
  // UI Constants
  static const double borderRadius = 12.0;
  static const double cardElevation = 4.0;
  static const double buttonHeight = 48.0;
  static const double iconSize = 24.0;
  static const double largeIconSize = 64.0;
  
  // Spacing Constants
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingExtraLarge = 32.0;
  
  // Text Sizes
  static const double textSizeSmall = 12.0;
  static const double textSizeMedium = 14.0;
  static const double textSizeLarge = 16.0;
  static const double textSizeExtraLarge = 18.0;
  static const double textSizeTitle = 20.0;
  static const double textSizeHeading = 24.0;
  
  // Validation Constants
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 20;
  static const int mobileNumberLength = 10;
  
  // Database Constants
  static const String profilesTable = 'profiles';
  static const String farmersTable = 'farmers';
  static const String tasksTable = 'tasks';
  static const String claimsTable = 'claims';
  
  // User Roles
  static const String adminRole = 'admin';
  static const String fieldVisitorRole = 'field_visitor';
  
  // Task Status
  static const String taskPending = 'pending';
  static const String taskCompleted = 'completed';
  
  // Claim Status
  static const String claimSubmitted = 'submitted';
  static const String claimApproved = 'approved';
  static const String claimRejected = 'rejected';
  
  // Storage Keys
  static const String storageKeyUserId = 'user_id';
  static const String storageKeyUserRole = 'user_role';
  static const String storageKeyUserName = 'user_name';
  static const String storageKeyIsLoggedIn = 'is_logged_in';
  
  // Error Messages
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNetwork = 'Network error. Please check your connection.';
  static const String errorInvalidCredentials = 'Invalid mobile number or password.';
  static const String errorUserNotFound = 'User not found.';
  static const String errorPasswordTooShort = 'Password must be at least 6 characters.';
  static const String errorInvalidMobile = 'Please enter a valid 10-digit mobile number.';
  
  // Success Messages
  static const String successLogin = 'Login successful!';
  static const String successLogout = 'Logged out successfully!';
  static const String successUserCreated = 'User created successfully!';
  static const String successUserUpdated = 'User updated successfully!';
  static const String successUserDeleted = 'User deleted successfully!';
  static const String successFarmerCreated = 'Farmer added successfully!';
  static const String successFarmerUpdated = 'Farmer updated successfully!';
  static const String successFarmerDeleted = 'Farmer deleted successfully!';
  static const String successTaskCreated = 'Task created successfully!';
  static const String successTaskCompleted = 'Task completed successfully!';
  static const String successClaimSubmitted = 'Claim submitted successfully!';
  
  // API Timeouts
  static const int apiTimeout = 30; // seconds
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
}