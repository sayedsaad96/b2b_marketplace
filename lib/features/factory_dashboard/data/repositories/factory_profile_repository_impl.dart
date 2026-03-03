import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/error/failures.dart';
import '../../../brand/domain/entities/factory_entity.dart';
import '../../domain/repositories/factory_profile_repository.dart';
import '../datasources/factory_profile_datasource.dart';

class FactoryProfileRepositoryImpl implements FactoryProfileRepository {
  final FactoryProfileDataSource dataSource;
  FactoryProfileRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, Factory>> getMyProfile() async {
    try {
      final result = await dataSource.getMyProfile();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Factory>> updateProfile({
    required String name,
    required String location,
    required List<String> specialization,
    required int moq,
    required int avgLeadTime,
  }) async {
    try {
      final result = await dataSource.updateProfile({
        'name': name,
        'location': location,
        'specialization': specialization,
        'moq': moq,
        'avg_lead_time': avgLeadTime,
      });
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> uploadPhotos(List<XFile> images) async {
    try {
      // First get the factory ID
      final profile = await dataSource.getMyProfile();
      final urls = await dataSource.uploadPhotos(images, profile.id);

      // Update the factory's photos list
      final currentPhotos = List<String>.from(profile.photos);
      currentPhotos.addAll(urls);
      await dataSource.updateProfile({'photos': currentPhotos});

      return Right(urls);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePhoto(String photoUrl) async {
    try {
      await dataSource.deletePhoto(photoUrl);

      // Remove from factory's photos list
      final profile = await dataSource.getMyProfile();
      final updatedPhotos = profile.photos
          .where((url) => url != photoUrl)
          .toList();
      await dataSource.updateProfile({'photos': updatedPhotos});

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
