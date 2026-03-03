import 'package:equatable/equatable.dart';

class RfqRequest extends Equatable {
  final String id;
  final String brandId;
  final String? factoryId;
  final String title;
  final String description;
  final int quantity;
  final List<String> photoUrls;
  final DateTime createdAt;

  const RfqRequest({
    required this.id,
    required this.brandId,
    this.factoryId,
    required this.title,
    required this.description,
    required this.quantity,
    required this.photoUrls,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    brandId,
    factoryId,
    title,
    description,
    quantity,
    photoUrls,
    createdAt,
  ];
}
