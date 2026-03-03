import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/rfq_request.dart';
import '../../domain/repositories/rfq_repository.dart';
import '../datasources/rfq_remote_datasource.dart';

class RfqRepositoryImpl implements RfqRepository {
  final RfqRemoteDataSource _remoteDataSource;

  const RfqRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, RfqRequest>> submitRfq({
    required String title,
    required String description,
    required int quantity,
    String? factoryId,
    List<String> photoUrls = const [],
  }) async {
    try {
      final rfq = await _remoteDataSource.submitRfq(
        title: title,
        description: description,
        quantity: quantity,
        factoryId: factoryId,
        photoUrls: photoUrls,
      );
      return Right(rfq);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RfqRequest>>> getMyRfqs() async {
    try {
      final rfqs = await _remoteDataSource.getMyRfqs();
      return Right(rfqs);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> uploadPhotos(List<XFile> images) async {
    try {
      final urls = await _remoteDataSource.uploadPhotos(images);
      return Right(urls);
    } on StorageException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
