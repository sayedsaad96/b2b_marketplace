import 'package:equatable/equatable.dart';
import '../../../brand/domain/entities/factory_entity.dart';

sealed class FactoryProfileState extends Equatable {
  const FactoryProfileState();

  @override
  List<Object?> get props => [];
}

class FactoryProfileInitial extends FactoryProfileState {}

class FactoryProfileLoading extends FactoryProfileState {}

class FactoryProfileLoaded extends FactoryProfileState {
  final Factory profile;
  final bool isSaving; // Used to show loading overlay during save

  const FactoryProfileLoaded({required this.profile, this.isSaving = false});

  @override
  List<Object?> get props => [profile, isSaving];

  FactoryProfileLoaded copyWith({Factory? profile, bool? isSaving}) {
    return FactoryProfileLoaded(
      profile: profile ?? this.profile,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class FactoryProfileError extends FactoryProfileState {
  final String message;

  const FactoryProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

class FactoryProfileSaved extends FactoryProfileState {
  // A temporary state to trigger navigation or a snackbar
  final Factory profile;
  const FactoryProfileSaved(this.profile);

  @override
  List<Object?> get props => [profile];
}
