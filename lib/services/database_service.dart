import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../models/farmer_model.dart';
import '../models/task_model.dart';
import '../models/claim_model.dart';
import '../utils/constants.dart';

/// Database Service for Supabase Operations
class DatabaseService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  // User Operations
  static Future<List<UserModel>> getUsers() async {
    try {
      final response = await _supabase
          .from(AppConstants.profilesTable)
          .select()
          .order('created_at', ascending: false);
      
      return (response as List)
          .map((user) => UserModel.fromJson(user))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }

  static Future<UserModel?> getUserById(String id) async {
    try {
      final response = await _supabase
          .from(AppConstants.profilesTable)
          .select()
          .eq('id', id)
          .maybeSingle();
      
      return response != null ? UserModel.fromJson(response) : null;
    } catch (e) {
      throw Exception('Failed to fetch user: $e');
    }
  }

  static Future<UserModel?> getUserByMobile(String mobile) async {
    try {
      final response = await _supabase
          .from(AppConstants.profilesTable)
          .select()
          .eq('mobile', mobile)
          .maybeSingle();
      
      return response != null ? UserModel.fromJson(response) : null;
    } catch (e) {
      throw Exception('Failed to fetch user by mobile: $e');
    }
  }

  static Future<UserModel> createUser(Map<String, dynamic> userData) async {
    try {
      final response = await _supabase
          .from(AppConstants.profilesTable)
          .insert(userData)
          .select()
          .single();
      
      return UserModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  static Future<UserModel> updateUser(String id, Map<String, dynamic> userData) async {
    try {
      final response = await _supabase
          .from(AppConstants.profilesTable)
          .update(userData)
          .eq('id', id)
          .select()
          .single();
      
      return UserModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  static Future<void> deleteUser(String id) async {
    try {
      await _supabase
          .from(AppConstants.profilesTable)
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  // Farmer Operations
  static Future<List<FarmerModel>> getFarmers({int? limit, int? offset}) async {
    try {
      var query = _supabase
          .from(AppConstants.farmersTable)
          .select()
          .order('created_at', ascending: false);
      
      if (limit != null) query = query.limit(limit);
      if (offset != null) query = query.range(offset, offset + (limit ?? 20) - 1);
      
      final response = await query;
      
      return (response as List)
          .map((farmer) => FarmerModel.fromJson(farmer))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch farmers: $e');
    }
  }

  static Future<List<FarmerModel>> searchFarmers(String query) async {
    try {
      final response = await _supabase
          .from(AppConstants.farmersTable)
          .select()
          .or('name.ilike.%$query%,village.ilike.%$query%,district.ilike.%$query%')
          .order('name');
      
      return (response as List)
          .map((farmer) => FarmerModel.fromJson(farmer))
          .toList();
    } catch (e) {
      throw Exception('Failed to search farmers: $e');
    }
  }

  static Future<FarmerModel?> getFarmerById(int id) async {
    try {
      final response = await _supabase
          .from(AppConstants.farmersTable)
          .select()
          .eq('id', id)
          .maybeSingle();
      
      return response != null ? FarmerModel.fromJson(response) : null;
    } catch (e) {
      throw Exception('Failed to fetch farmer: $e');
    }
  }

  static Future<FarmerModel> createFarmer(Map<String, dynamic> farmerData) async {
    try {
      final response = await _supabase
          .from(AppConstants.farmersTable)
          .insert(farmerData)
          .select()
          .single();
      
      return FarmerModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create farmer: $e');
    }
  }

  static Future<FarmerModel> updateFarmer(int id, Map<String, dynamic> farmerData) async {
    try {
      final response = await _supabase
          .from(AppConstants.farmersTable)
          .update(farmerData)
          .eq('id', id)
          .select()
          .single();
      
      return FarmerModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update farmer: $e');
    }
  }

  static Future<void> deleteFarmer(int id) async {
    try {
      await _supabase
          .from(AppConstants.farmersTable)
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete farmer: $e');
    }
  }

  // Task Operations
  static Future<List<TaskModel>> getTasks({String? assignedTo, String? status}) async {
    try {
      var query = _supabase
          .from(AppConstants.tasksTable)
          .select('''
            *,
            farmers!inner(
              id, name, village, district, phone, crops
            ),
            assigned_user:profiles!tasks_assigned_to_fkey(
              id, name, mobile, role
            )
          ''')
          .order('created_at', ascending: false);
      
      if (assignedTo != null) query = query.eq('assigned_to', assignedTo);
      if (status != null) query = query.eq('status', status);
      
      final response = await query;
      
      return (response as List)
          .map((task) => TaskModel.fromJson(task))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch tasks: $e');
    }
  }

  static Future<TaskModel?> getTaskById(int id) async {
    try {
      final response = await _supabase
          .from(AppConstants.tasksTable)
          .select('''
            *,
            farmers!inner(
              id, name, village, district, phone, crops
            ),
            assigned_user:profiles!tasks_assigned_to_fkey(
              id, name, mobile, role
            )
          ''')
          .eq('id', id)
          .maybeSingle();
      
      return response != null ? TaskModel.fromJson(response) : null;
    } catch (e) {
      throw Exception('Failed to fetch task: $e');
    }
  }

  static Future<TaskModel> createTask(Map<String, dynamic> taskData) async {
    try {
      final response = await _supabase
          .from(AppConstants.tasksTable)
          .insert(taskData)
          .select()
          .single();
      
      return TaskModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  static Future<TaskModel> updateTask(int id, Map<String, dynamic> taskData) async {
    try {
      final response = await _supabase
          .from(AppConstants.tasksTable)
          .update(taskData)
          .eq('id', id)
          .select()
          .single();
      
      return TaskModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  static Future<void> deleteTask(int id) async {
    try {
      await _supabase
          .from(AppConstants.tasksTable)
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  // Claim Operations
  static Future<List<ClaimModel>> getClaims({String? visitorId, String? status}) async {
    try {
      var query = _supabase
          .from(AppConstants.claimsTable)
          .select('''
            *,
            tasks!inner(
              id, title, farmer_id
            ),
            visitor:profiles!claims_visitor_id_fkey(
              id, name, mobile
            )
          ''')
          .order('created_at', ascending: false);
      
      if (visitorId != null) query = query.eq('visitor_id', visitorId);
      if (status != null) query = query.eq('status', status);
      
      final response = await query;
      
      return (response as List)
          .map((claim) => ClaimModel.fromJson(claim))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch claims: $e');
    }
  }

  static Future<ClaimModel> createClaim(Map<String, dynamic> claimData) async {
    try {
      final response = await _supabase
          .from(AppConstants.claimsTable)
          .insert(claimData)
          .select()
          .single();
      
      return ClaimModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create claim: $e');
    }
  }

  static Future<ClaimModel> updateClaim(int id, Map<String, dynamic> claimData) async {
    try {
      final response = await _supabase
          .from(AppConstants.claimsTable)
          .update(claimData)
          .eq('id', id)
          .select()
          .single();
      
      return ClaimModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update claim: $e');
    }
  }

  // Statistics
  static Future<Map<String, int>> getDashboardStats({String? userId}) async {
    try {
      final List<Future> futures = [
        _supabase.from(AppConstants.profilesTable).select('id', count: CountOption.exact),
        _supabase.from(AppConstants.farmersTable).select('id', count: CountOption.exact),
        _supabase.from(AppConstants.tasksTable).select('id', count: CountOption.exact),
        _supabase.from(AppConstants.tasksTable)
            .select('id', count: CountOption.exact)
            .eq('status', AppConstants.taskPending),
      ];
      
      if (userId != null) {
        futures.addAll([
          _supabase.from(AppConstants.tasksTable)
              .select('id', count: CountOption.exact)
              .eq('assigned_to', userId),
          _supabase.from(AppConstants.claimsTable)
              .select('id', count: CountOption.exact)
              .eq('visitor_id', userId),
        ]);
      }
      
      final results = await Future.wait(futures);
      
      return {
        'totalUsers': results[0].count ?? 0,
        'totalFarmers': results[1].count ?? 0,
        'totalTasks': results[2].count ?? 0,
        'pendingTasks': results[3].count ?? 0,
        if (userId != null) 'myTasks': results[4].count ?? 0,
        if (userId != null) 'myClaims': results[5].count ?? 0,
      };
    } catch (e) {
      throw Exception('Failed to fetch dashboard stats: $e');
    }
  }
}