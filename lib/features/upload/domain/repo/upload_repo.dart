import 'package:arch_vault/core/errors/failure.dart';
import 'package:arch_vault/features/upload/domain/entities/upload_model_response_entity.dart';
import 'package:dartz/dartz.dart';

import '../entities/upload_draft_entity.dart';

abstract class UploadRepo {
  Future<List<AiLabelScore>> classifyMock({
    required String fileName,
    required String title,
  });

  Future<void> submitUpload(UploadDraftEntity draft);

  Future<List<MyUploadEntity>> getMyUploads();

  Future<Either<Failure, UploadModelResponseEntity>> uploadModel(
    UploadDraftEntity draft,
  );
}
