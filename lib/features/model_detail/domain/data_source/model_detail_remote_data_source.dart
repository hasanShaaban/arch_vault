import 'package:arch_vault/features/home/data/models/model_3d_model.dart';

abstract class ModelDetailRemoteDataSource {
  // Future<ModelDetailModel> getById(String id);

  Future<List<Model3dModel>> getSimilar(String ids);

  // Future<void> downloadModel(String id);

  // Future<double> rateModel({required String id, required int stars});
  Future<bool> reportModel({required String id, required String reason});
}
