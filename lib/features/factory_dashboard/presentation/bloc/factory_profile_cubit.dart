import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/usecases/get_my_profile_usecase.dart';
import '../../domain/usecases/update_factory_profile_usecase.dart';
import '../../domain/repositories/factory_profile_repository.dart';
import 'factory_profile_state.dart';

class FactoryProfileCubit extends Cubit<FactoryProfileState> {
  final GetMyProfileUseCase getMyProfileUseCase;
  final UpdateFactoryProfileUseCase updateFactoryProfileUseCase;
  final FactoryProfileRepository repository;

  FactoryProfileCubit({
    required this.getMyProfileUseCase,
    required this.updateFactoryProfileUseCase,
    required this.repository,
  }) : super(FactoryProfileInitial());

  Future<void> loadProfile() async {
    emit(FactoryProfileLoading());

    final result = await getMyProfileUseCase();

    result.fold(
      (failure) => emit(FactoryProfileError(failure.message)),
      (profile) => emit(FactoryProfileLoaded(profile: profile)),
    );
  }

  Future<void> saveProfile({
    required String name,
    required String location,
    required List<String> specialization,
    required int moq,
    required int avgLeadTime,
  }) async {
    if (state is! FactoryProfileLoaded) return;
    final currentState = state as FactoryProfileLoaded;

    emit(currentState.copyWith(isSaving: true));

    final result = await updateFactoryProfileUseCase(
      name: name,
      location: location,
      specialization: specialization,
      moq: moq,
      avgLeadTime: avgLeadTime,
    );

    result.fold(
      (failure) {
        emit(FactoryProfileError(failure.message));
        emit(currentState.copyWith(isSaving: false));
      },
      (profile) {
        emit(FactoryProfileSaved(profile));
        // Reset to loaded after emitting saved
        emit(FactoryProfileLoaded(profile: profile));
      },
    );
  }

  Future<void> uploadPhotos(List<XFile> images) async {
    if (state is! FactoryProfileLoaded) return;
    final currentState = state as FactoryProfileLoaded;

    emit(currentState.copyWith(isSaving: true));

    final result = await repository.uploadPhotos(images);

    result.fold(
      (failure) {
        emit(
          FactoryProfileError('Failed to upload photos: ${failure.message}'),
        );
        emit(currentState.copyWith(isSaving: false));
      },
      (urls) {
        // Reload profile to get updated photos
        loadProfile();
      },
    );
  }

  Future<void> deletePhoto(String url) async {
    if (state is! FactoryProfileLoaded) return;
    final currentState = state as FactoryProfileLoaded;

    emit(currentState.copyWith(isSaving: true));

    final result = await repository.deletePhoto(url);

    result.fold(
      (failure) {
        emit(FactoryProfileError('Failed to delete photo: ${failure.message}'));
        emit(currentState.copyWith(isSaving: false));
      },
      (_) {
        // Reload profile to get updated photos
        loadProfile();
      },
    );
  }
}
