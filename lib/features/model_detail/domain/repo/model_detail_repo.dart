import 'package:arch_vault/core/errors/failure.dart';
import 'package:arch_vault/features/home/domain/entities/model_3d_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ModelDetailRepo {
  // Future<ModelDetailEntity> getById(String id);

  Future<Either<Failure, List<Model3dEntity>>> getSimilar(String ids);

  // Future<void> downloadModel(String id);

  // Future<double> rateModel({required String id, required int stars});
}
