import '../entities/upload_draft_entity.dart';

abstract class UploadRepo {
  Future<List<AiLabelScore>> classifyMock({
    required String fileName,
    required String title,
  });

  Future<void> submitUpload(UploadDraftEntity draft);

  Future<List<MyUploadEntity>> getMyUploads();
}
