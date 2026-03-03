import '../../domain/entities/rfq_quote.dart';

class RfqQuoteModel extends RfqQuote {
  const RfqQuoteModel({
    required super.id,
    required super.rfqId,
    required super.factoryId,
    required super.price,
    required super.leadTime,
    super.notes,
    required super.status,
    required super.createdAt,
  });

  factory RfqQuoteModel.fromJson(Map<String, dynamic> json) {
    return RfqQuoteModel(
      id: json['id'] as String,
      rfqId: json['rfq_id'] as String,
      factoryId: json['factory_id'] as String,
      price: (json['price'] as num).toDouble(),
      leadTime: json['lead_time'] as int,
      notes: json['notes'] as String?,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rfq_id': rfqId,
      'factory_id': factoryId,
      'price': price,
      'lead_time': leadTime,
      'notes': notes,
      'status': status,
    };
  }
}
