import 'package:equatable/equatable.dart';

class RfqQuote extends Equatable {
  final String id;
  final String rfqId;
  final String factoryId;
  final double price;
  final int leadTime;
  final String? notes;
  final String status;
  final DateTime createdAt;

  const RfqQuote({
    required this.id,
    required this.rfqId,
    required this.factoryId,
    required this.price,
    required this.leadTime,
    this.notes,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    rfqId,
    factoryId,
    price,
    leadTime,
    notes,
    status,
    createdAt,
  ];
}
