import 'package:equatable/equatable.dart';

class Factory extends Equatable {
  final String id;
  final String name;
  final String location;
  final List<String> specialization;
  final int moq;
  final int avgLeadTime;
  final double rating;
  final String ownerId;
  final List<String> photos;
  final bool verified;
  final DateTime createdAt;

  const Factory({
    required this.id,
    required this.name,
    required this.location,
    required this.specialization,
    required this.moq,
    required this.avgLeadTime,
    required this.rating,
    required this.ownerId,
    required this.photos,
    required this.verified,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    location,
    specialization,
    moq,
    avgLeadTime,
    rating,
    ownerId,
    photos,
    verified,
    createdAt,
  ];
}
