import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase Configuration
/// IMPORTANT: Replace these with your actual Supabase credentials
class SupabaseConfig {
  // TODO: Replace with your actual Supabase URL
  // Get this from: Supabase Dashboard → Settings → API → Project URL
  static const String supabaseUrl = 'YOUR_SUPABASE_URL_HERE';
  
  // TODO: Replace with your actual Supabase anon key
  // Get this from: Supabase Dashboard → Settings → API → Project API keys → anon public
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY_HERE';
  
  /// Initialize Supabase client
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      debug: false, // Set to true for development debugging
    );
  }
  
  /// Get Supabase client instance
  static SupabaseClient get client => Supabase.instance.client;
  
  /// Check if Supabase is properly configured
  static bool get isConfigured {
    return supabaseUrl != 'YOUR_SUPABASE_URL_HERE' &&
           supabaseAnonKey != 'YOUR_SUPABASE_ANON_KEY_HERE' &&
           supabaseUrl.isNotEmpty &&
           supabaseAnonKey.isNotEmpty;
  }
}