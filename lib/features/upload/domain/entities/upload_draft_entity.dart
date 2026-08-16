import 'dart:typed_data';

enum UploadStep { file, details, aiReview }

class AiLabelScore {
  const AiLabelScore({required this.label, required this.confidence});

  final String label;
  final double confidence;
}

class UploadDraftEntity {
  const UploadDraftEntity({
    this.fileName,
    this.title = '',
    this.description = '',
    this.bannerImageName,
    this.tags = const [],
    this.aiLabels = const [],
    this.fileBytes,
    this.bannerImageBytes,
  });

  final String? fileName;
  final String title;
  final String description;
  final String? bannerImageName;
  final List<String> tags;
  final List<AiLabelScore> aiLabels;
  final Uint8List? fileBytes;
  final Uint8List? bannerImageBytes;

  UploadDraftEntity copyWith({
    String? fileName,
    String? title,
    String? description,
    String? bannerImageName,
    List<String>? tags,
    List<AiLabelScore>? aiLabels,
    Uint8List? fileBytes,
    Uint8List? bannerImageBytes,
  }) {
    return UploadDraftEntity(
      fileName: fileName ?? this.fileName,
      title: title ?? this.title,
      description: description ?? this.description,
      bannerImageName: bannerImageName ?? this.bannerImageName,
      tags: tags ?? this.tags,
      aiLabels: aiLabels ?? this.aiLabels,
      fileBytes: fileBytes ?? this.fileBytes,
      bannerImageBytes: bannerImageBytes ?? this.bannerImageBytes,
    );
  }
}

class MyUploadEntity {
  const MyUploadEntity({
    required this.id,
    required this.title,
    required this.fileName,
    required this.status,
    required this.category,
    required this.uploadedAt,
  });

  final String id;
  final String title;
  final String fileName;
  final String status;
  final String category;
  final DateTime uploadedAt;
}
