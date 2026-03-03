import 'package:equatable/equatable.dart';
import '../../domain/entities/factory_entity.dart';

sealed class FactorySearchState extends Equatable {
  const FactorySearchState();

  @override
  List<Object?> get props => [];
}

class FactorySearchInitial extends FactorySearchState {}

class FactorySearchLoading extends FactorySearchState {}

class FactorySearchLoaded extends FactorySearchState {
  final List<Factory> topFactories; // For home carousel
  final List<Factory> searchResults;
  final bool hasReachedMax;
  final String? error;

  const FactorySearchLoaded({
    required this.topFactories,
    required this.searchResults,
    required this.hasReachedMax,
    this.error,
  });

  FactorySearchLoaded copyWith({
    List<Factory>? topFactories,
    List<Factory>? searchResults,
    bool? hasReachedMax,
    String? error,
  }) {
    return FactorySearchLoaded(
      topFactories: topFactories ?? this.topFactories,
      searchResults: searchResults ?? this.searchResults,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    topFactories,
    searchResults,
    hasReachedMax,
    error,
  ];
}

class FactoryProfileLoading extends FactorySearchState {}

class FactoryProfileLoaded extends FactorySearchState {
  final Factory factoryEntity;
  const FactoryProfileLoaded(this.factoryEntity);

  @override
  List<Object?> get props => [factoryEntity];
}

class FactoryProfileError extends FactorySearchState {
  final String message;
  const FactoryProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
