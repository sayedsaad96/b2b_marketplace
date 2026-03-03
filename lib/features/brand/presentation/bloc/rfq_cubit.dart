import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/repositories/rfq_repository.dart';
import '../../domain/usecases/get_my_rfqs_usecase.dart';
import '../../domain/usecases/submit_rfq_usecase.dart';
import 'rfq_state.dart';

class RfqCubit extends Cubit<RfqState> {
  final SubmitRfqUseCase _submitRfq;
  final GetMyRfqsUseCase _getMyRfqs;
  final RfqRepository
  _repository; // Needed to call uploadPhotos directly or refactor to usecase

  RfqCubit({
    required SubmitRfqUseCase submitRfq,
    required GetMyRfqsUseCase getMyRfqs,
    required RfqRepository repository,
  }) : _submitRfq = submitRfq,
       _getMyRfqs = getMyRfqs,
       _repository = repository,
       super(RfqInitial());

  Future<void> submitRfqRequest({
    required String title,
    required String description,
    required int quantity,
    String? factoryId,
    List<XFile> images = const [],
  }) async {
    emit(RfqSubmitting());

    List<String> photoUrls = [];

    if (images.isNotEmpty) {
      final uploadResult = await _repository.uploadPhotos(images);
      uploadResult.fold(
        (failure) {
          emit(RfqError('Photo upload failed: ${failure.message}'));
          return;
        },
        (urls) {
          photoUrls = urls;
        },
      );
      if (state is RfqError) return;
    }

    final result = await _submitRfq(
      title: title,
      description: description,
      quantity: quantity,
      factoryId: factoryId,
      photoUrls: photoUrls,
    );

    result.fold(
      (failure) => emit(RfqError(failure.message)),
      (rfq) => emit(RfqSubmittedSuccess(rfq)),
    );
  }

  Future<void> loadMyRfqs() async {
    emit(RfqListLoading());
    final result = await _getMyRfqs();
    result.fold(
      (failure) => emit(RfqListError(failure.message)),
      (rfqs) => emit(RfqListLoaded(rfqs)),
    );
  }
}
