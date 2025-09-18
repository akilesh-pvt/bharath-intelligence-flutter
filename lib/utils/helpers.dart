import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'constants.dart';

/// Helper Functions for Validation and Utilities
class Helpers {
  
  /// Validate mobile number (10 digits)
  static bool isValidMobile(String mobile) {
    if (mobile.isEmpty) return false;
    final cleanMobile = mobile.replaceAll(RegExp(r'[^0-9]'), '');
    return cleanMobile.length == AppConstants.mobileNumberLength &&
           RegExp(r'^[6-9][0-9]{9}$').hasMatch(cleanMobile);
  }
  
  /// Validate password
  static bool isValidPassword(String password) {
    return password.length >= AppConstants.minPasswordLength &&
           password.length <= AppConstants.maxPasswordLength;
  }
  
  /// Validate name (at least 2 characters, only letters and spaces)
  static bool isValidName(String name) {
    if (name.trim().isEmpty || name.trim().length < 2) return false;
    return RegExp(r'^[a-zA-Z\s]+$').hasMatch(name.trim());
  }
  
  /// Clean and format mobile number
  static String cleanMobileNumber(String mobile) {
    return mobile.replaceAll(RegExp(r'[^0-9]'), '');
  }
  
  /// Format date for display
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }
  
  /// Format date and time for display
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }
  
  /// Format currency amount
  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }
  
  /// Capitalize first letter of each word
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
  
  /// Get status color based on status string
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'approved':
        return Colors.green;
      case 'pending':
      case 'submitted':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
  
  /// Get status icon based on status string
  static IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'approved':
        return Icons.check_circle;
      case 'pending':
      case 'submitted':
        return Icons.access_time;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }
  
  /// Show snackbar message
  static void showSnackBar(
    BuildContext context,
    String message, {
    Color? backgroundColor,
    Color? textColor,
    Duration? duration,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontSize: AppConstants.textSizeMedium,
          ),
        ),
        backgroundColor: backgroundColor,
        duration: duration ?? const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(AppConstants.paddingMedium),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
      ),
    );
  }
  
  /// Show success snackbar
  static void showSuccessSnackBar(BuildContext context, String message) {
    showSnackBar(
      context,
      message,
      backgroundColor: Colors.green,
    );
  }
  
  /// Show error snackbar
  static void showErrorSnackBar(BuildContext context, String message) {
    showSnackBar(
      context,
      message,
      backgroundColor: Colors.red,
    );
  }
  
  /// Show loading dialog
  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
  
  /// Hide loading dialog
  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
  
  /// Generate a simple ID (timestamp-based)
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
  
  /// Check if string is empty or null
  static bool isEmptyOrNull(String? value) {
    return value == null || value.trim().isEmpty;
  }
  
  /// Debounce function for search
  static Timer? _debounceTimer;
  
  static void debounce(Duration duration, VoidCallback callback) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(duration, callback);
  }
}

/// Timer import
import 'dart:async';