import 'dart:typed_data';

import 'package:arch_vault/core/errors/exceptions.dart';
import 'package:arch_vault/core/network/api_service.dart';
import 'package:arch_vault/features/upload/data/models/upload_model_response_model.dart';
import 'package:arch_vault/features/upload/domain/data_source/upload_model_remote_data_source.dart';
import 'package:arch_vault/features/upload/domain/entities/upload_model_response_entity.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../../domain/entities/upload_draft_entity.dart';

class UploadRemoteDataSourceImpl implements UploadRemoteDataSource {
  final ApiService apiService;

  UploadRemoteDataSourceImpl(this.apiService);
  Never _notReady() =>
      throw UnimplementedError('Upload remote API is not connected yet.');

  @override
  Future<List<AiLabelScore>> classifyMock({
    required String fileName,
    required String title,
  }) async => _notReady();

  @override
  Future<void> submitUpload(UploadDraftEntity draft) async => _notReady();

  @override
  Future<List<MyUploadEntity>> getMyUploads() async => _notReady();

  @override
  Future<UploadModelResponseEntity> uploadModel({
    required String title,
    required String description,
    required Uint8List modelBytes,
    required String modelFileName,
    Uint8List? bannerBytes,
    String? bannerFileName,
  }) async {
    final Map<String, dynamic> formMap = {
      'title': title,
      'description': description,
      'model': MultipartFile.fromBytes(
        modelBytes,
        filename: modelFileName,
        contentType: MediaType.parse(_modelMimeType(modelFileName)),
      ),
    };
    if (bannerBytes != null && bannerFileName != null) {
      formMap['banner'] = MultipartFile.fromBytes(
        bannerBytes,
        filename: bannerFileName,
        contentType: MediaType.parse(_imageMimeType(bannerFileName)),
      );
    }
    final formData = FormData.fromMap(formMap);
    try {
      final response = await apiService.post(
        'models/upload-user/',
        body: formData,
      );
      return UploadModelResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    } catch (e) {
      throw ServerException(message: 'Failed to login');
    }
  }

  String _modelMimeType(String fileName) {
    return fileName.toLowerCase().endsWith('.gltf')
        ? 'model/gltf+json'
        : 'model/gltf-binary';
  }

  String _imageMimeType(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    return switch (ext) {
      'png' => 'image/png',
      'webp' => 'image/webp',
      'gif' => 'image/gif',
      _ => 'image/jpeg',
    };
  }
}
