import '../../domain/entities/factory_entity.dart';

class FactoryModel extends Factory {
  const FactoryModel({
    required super.id,
    required super.name,
    required super.location,
    required super.specialization,
    required super.moq,
    required super.avgLeadTime,
    required super.rating,
    required super.ownerId,
    required super.photos,
    required super.verified,
    required super.createdAt,
  });

  factory FactoryModel.fromJson(Map<String, dynamic> json) {
    return FactoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      specialization: List<String>.from(json['specialization'] ?? []),
      moq: json['moq'] as int,
      avgLeadTime: json['avg_lead_time'] as int,
      rating: double.parse(json['rating'].toString()),
      ownerId: json['owner_id'] as String,
      photos: List<String>.from(json['photos'] ?? []),
      verified: json['verified'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'specialization': specialization,
      'moq': moq,
      'avg_lead_time': avgLeadTime,
      'rating': rating,
      'owner_id': ownerId,
      'photos': photos,
      'verified': verified,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
