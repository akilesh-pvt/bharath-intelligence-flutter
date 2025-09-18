import 'package:flutter/material.dart';
import '../models/farmer_model.dart';
import '../services/database_service.dart';

/// Farmer Provider for Farmer Management
class FarmerProvider with ChangeNotifier {
  List<FarmerModel> _farmers = [];
  List<FarmerModel> _searchResults = [];
  bool _isLoading = false;
  bool _isSearching = false;
  String? _error;
  String _currentSearchQuery = '';
  
  /// Getters
  List<FarmerModel> get farmers => _farmers;
  List<FarmerModel> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String? get error => _error;
  String get currentSearchQuery => _currentSearchQuery;
  
  /// Load farmers with pagination
  Future<void> loadFarmers({bool refresh = false}) async {
    if (refresh) {
      _farmers.clear();
    }
    
    _setLoading(true);
    _clearError();
    
    try {
      final newFarmers = await DatabaseService.getFarmers(
        limit: 50,
        offset: refresh ? 0 : _farmers.length,
      );
      
      if (refresh) {
        _farmers = newFarmers;
      } else {
        _farmers.addAll(newFarmers);
      }
    } catch (e) {
      _setError('Failed to load farmers: ${e.toString()}');
    }
    
    _setLoading(false);
  }
  
  /// Search farmers
  Future<void> searchFarmers(String query) async {
    _currentSearchQuery = query;
    
    if (query.trim().isEmpty) {
      _searchResults.clear();
      _isSearching = false;
      notifyListeners();
      return;
    }
    
    _isSearching = true;
    _clearError();
    notifyListeners();
    
    try {
      _searchResults = await DatabaseService.searchFarmers(query.trim());
    } catch (e) {
      _setError('Failed to search farmers: ${e.toString()}');
    }
    
    _isSearching = false;
    notifyListeners();
  }
  
  /// Get farmer by ID
  Future<FarmerModel?> getFarmerById(int id) async {
    try {
      return await DatabaseService.getFarmerById(id);
    } catch (e) {
      _setError('Failed to get farmer: ${e.toString()}');
      return null;
    }
  }
  
  /// Create new farmer
  Future<bool> createFarmer({
    required String name,
    String? phone,
    String? village,
    String? district,
    String? crops,
    bool isPrefilled = false,
    String? createdBy,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final farmerData = {
        'name': name,
        'phone': phone,
        'village': village,
        'district': district,
        'crops': crops,
        'is_prefilled': isPrefilled,
        'created_by': createdBy,
      };
      
      final newFarmer = await DatabaseService.createFarmer(farmerData);
      _farmers.insert(0, newFarmer);
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to create farmer: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }
  
  /// Update farmer
  Future<bool> updateFarmer(int id, {
    String? name,
    String? phone,
    String? village,
    String? district,
    String? crops,
    bool? isPrefilled,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final updateData = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      if (name != null) updateData['name'] = name;
      if (phone != null) updateData['phone'] = phone;
      if (village != null) updateData['village'] = village;
      if (district != null) updateData['district'] = district;
      if (crops != null) updateData['crops'] = crops;
      if (isPrefilled != null) updateData['is_prefilled'] = isPrefilled;
      
      final updatedFarmer = await DatabaseService.updateFarmer(id, updateData);
      
      final index = _farmers.indexWhere((farmer) => farmer.id == id);
      if (index != -1) {
        _farmers[index] = updatedFarmer;
      }
      
      // Update search results if needed
      final searchIndex = _searchResults.indexWhere((farmer) => farmer.id == id);
      if (searchIndex != -1) {
        _searchResults[searchIndex] = updatedFarmer;
      }
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to update farmer: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }
  
  /// Delete farmer
  Future<bool> deleteFarmer(int id) async {
    _setLoading(true);
    _clearError();
    
    try {
      await DatabaseService.deleteFarmer(id);
      _farmers.removeWhere((farmer) => farmer.id == id);
      _searchResults.removeWhere((farmer) => farmer.id == id);
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to delete farmer: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }
  
  /// Get farmers by village
  List<FarmerModel> getFarmersByVillage(String village) {
    return _farmers.where((farmer) => 
        farmer.village?.toLowerCase() == village.toLowerCase()
    ).toList();
  }
  
  /// Get farmers by district
  List<FarmerModel> getFarmersByDistrict(String district) {
    return _farmers.where((farmer) => 
        farmer.district?.toLowerCase() == district.toLowerCase()
    ).toList();
  }
  
  /// Clear search
  void clearSearch() {
    _currentSearchQuery = '';
    _searchResults.clear();
    _isSearching = false;
    notifyListeners();
  }
  
  /// Clear error message
  void clearError() {
    _clearError();
  }
  
  /// Refresh farmers list
  Future<void> refresh() async {
    await loadFarmers(refresh: true);
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