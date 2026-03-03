import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/error/failures.dart';
import '../../../brand/domain/entities/factory_entity.dart';

abstract class FactoryProfileRepository {
  Future<Either<Failure, Factory>> getMyProfile();
  Future<Either<Failure, Factory>> updateProfile({
    required String name,
    required String location,
    required List<String> specialization,
    required int moq,
    required int avgLeadTime,
  });
  Future<Either<Failure, List<String>>> uploadPhotos(List<XFile> images);
  Future<Either<Failure, void>> deletePhoto(String photoUrl);
}
