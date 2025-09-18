/// Farmer Model for Agricultural Field Management
class FarmerModel {
  final int id;
  final String name;
  final String? phone;
  final String? village;
  final String? district;
  final String? crops;
  final bool isPrefilled;
  final String? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FarmerModel({
    required this.id,
    required this.name,
    this.phone,
    this.village,
    this.district,
    this.crops,
    required this.isPrefilled,
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create FarmerModel from JSON
  factory FarmerModel.fromJson(Map<String, dynamic> json) {
    return FarmerModel(
      id: json['id'] as int,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      village: json['village'] as String?,
      district: json['district'] as String?,
      crops: json['crops'] as String?,
      isPrefilled: json['is_prefilled'] as bool? ?? false,
      createdBy: json['created_by'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convert FarmerModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'village': village,
      'district': district,
      'crops': crops,
      'is_prefilled': isPrefilled,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Convert FarmerModel to JSON for database insert
  Map<String, dynamic> toInsertJson() {
    return {
      'name': name,
      'phone': phone,
      'village': village,
      'district': district,
      'crops': crops,
      'is_prefilled': isPrefilled,
      'created_by': createdBy,
    };
  }

  /// Get farmer display name with village
  String get displayName {
    if (village != null && village!.isNotEmpty) {
      return '$name, $village';
    }
    return name;
  }

  /// Get farmer location info
  String get locationInfo {
    List<String> location = [];
    if (village != null && village!.isNotEmpty) location.add(village!);
    if (district != null && district!.isNotEmpty) location.add(district!);
    return location.join(', ');
  }

  /// Create a copy with updated fields
  FarmerModel copyWith({
    int? id,
    String? name,
    String? phone,
    String? village,
    String? district,
    String? crops,
    bool? isPrefilled,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FarmerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      village: village ?? this.village,
      district: district ?? this.district,
      crops: crops ?? this.crops,
      isPrefilled: isPrefilled ?? this.isPrefilled,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FarmerModel &&
        other.id == id &&
        other.name == name &&
        other.phone == phone &&
        other.village == village &&
        other.district == district;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        village.hashCode ^
        district.hashCode;
  }

  @override
  String toString() {
    return 'FarmerModel(id: $id, name: $name, village: $village, district: $district)';
  }
}