import '../../domain/entities/rfq_request.dart';

class RfqRequestModel extends RfqRequest {
  const RfqRequestModel({
    required super.id,
    required super.brandId,
    super.factoryId,
    required super.title,
    required super.description,
    required super.quantity,
    required super.photoUrls,
    required super.createdAt,
  });

  factory RfqRequestModel.fromJson(Map<String, dynamic> json) {
    return RfqRequestModel(
      id: json['id'] as String,
      brandId: json['brand_id'] as String,
      factoryId: json['factory_id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      quantity: json['quantity'] as int,
      photoUrls: List<String>.from(json['photo_urls'] ?? []),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand_id': brandId,
      if (factoryId != null) 'factory_id': factoryId,
      'title': title,
      'description': description,
      'quantity': quantity,
      'photo_urls': photoUrls,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
