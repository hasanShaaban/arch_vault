import 'package:arch_vault/features/upload/domain/entities/upload_draft_entity.dart';
import 'package:arch_vault/features/upload/domain/entities/upload_model_response_entity.dart';
import 'package:flutter/services.dart';

abstract class UploadRemoteDataSource {
  Future<List<AiLabelScore>> classifyMock({
    required String fileName,
    required String title,
  });

  Future<void> submitUpload(UploadDraftEntity draft);

  Future<List<MyUploadEntity>> getMyUploads();

  Future<UploadModelResponseEntity> uploadModel({
    required String title,
    required String description,
    required Uint8List modelBytes,
    required String modelFileName,
    required Uint8List bannerBytes,
    required String bannerFileName,
  });
}
