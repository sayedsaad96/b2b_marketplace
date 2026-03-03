import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/error/failures.dart';
import '../entities/rfq_request.dart';

abstract class RfqRepository {
  Future<Either<Failure, RfqRequest>> submitRfq({
    required String title,
    required String description,
    required int quantity,
    String? factoryId,
    List<String> photoUrls = const [],
  });

  Future<Either<Failure, List<RfqRequest>>> getMyRfqs();

  Future<Either<Failure, List<String>>> uploadPhotos(List<XFile> images);
}
