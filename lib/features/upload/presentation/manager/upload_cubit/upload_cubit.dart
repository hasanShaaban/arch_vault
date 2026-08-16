import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/upload_draft_entity.dart';
import '../../../domain/entities/upload_model_response_entity.dart';
import '../../../domain/repo/upload_repo.dart';
import 'upload_state.dart';

class UploadCubit extends Cubit<UploadState> {
  UploadCubit(this._repo)
    : super(
        const UploadFormState(
          step: UploadStep.file,
          draft: UploadDraftEntity(),
        ),
      );

  final UploadRepo _repo;

  static const _allowedExtensions = ['gltf', 'glb'];

  UploadFormState get _form => state as UploadFormState;

  Future<void> pickModelFile() async {
    emit(_form.copyWith(isBusy: true, clearError: true));
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: _allowedExtensions,
        // Needed on Flutter Web: there's no real filesystem path, only
        // in-memory bytes, and the 3D preview needs those bytes to build
        // a blob URL for Flutter3DViewer.
        withData: true,
      );
      if (result == null || result.files.isEmpty) {
        emit(_form.copyWith(isBusy: false));
        return;
      }
      final file = result.files.first;
      if (file.bytes == null) {
        emit(
          _form.copyWith(
            isBusy: false,
            errorMessage: 'Could not read file data.',
          ),
        );
        return;
      }
      emit(
        _form.copyWith(
          isBusy: false,
          draft: _form.draft.copyWith(
            fileName: file.name,
            fileBytes: file.bytes,
          ),
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        _form.copyWith(isBusy: false, errorMessage: 'Could not pick file: $e'),
      );
    }
  }

  Future<void> pickBannerImage() async {
    emit(_form.copyWith(isBusy: true, clearError: true));
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.image,
        // Needed on Flutter Web to get bytes to upload (no filesystem path).
        withData: true,
      );
      if (result == null || result.files.isEmpty) {
        emit(_form.copyWith(isBusy: false));
        return;
      }
      final file = result.files.first;
      if (file.bytes == null) {
        emit(
          _form.copyWith(
            isBusy: false,
            errorMessage: 'Could not read banner image data.',
          ),
        );
        return;
      }
      emit(
        _form.copyWith(
          isBusy: false,
          draft: _form.draft.copyWith(
            bannerImageName: file.name,
            bannerImageBytes: file.bytes,
          ),
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        _form.copyWith(
          isBusy: false,
          errorMessage: 'Could not pick banner image: $e',
        ),
      );
    }
  }

  void updateDetails({required String title, required String description}) {
    emit(
      _form.copyWith(
        draft: _form.draft.copyWith(title: title, description: description),
        clearError: true,
      ),
    );
  }

  void goToDetails() {
    if (_form.draft.fileName == null) {
      emit(_form.copyWith(errorMessage: 'Select a model file first.'));
      return;
    }
    emit(_form.copyWith(step: UploadStep.details, clearError: true));
  }

  Future<void> runAiReview({
    required String title,
    required String description,
  }) async {
    if (title.trim().isEmpty) {
      emit(_form.copyWith(errorMessage: 'Title is required.'));
      return;
    }
    if (_form.draft.fileBytes == null || _form.draft.fileName == null) {
      emit(_form.copyWith(errorMessage: '3D model file is required.'));
      return;
    }
    if (_form.draft.bannerImageBytes == null ||
        _form.draft.bannerImageName == null) {
      emit(_form.copyWith(errorMessage: 'Banner image is required.'));
      return;
    }

    final updatedDraft = _form.draft.copyWith(
      title: title,
      description: description,
    );

    emit(
      _form.copyWith(
        step: UploadStep.aiReview,
        isBusy: true,
        draft: updatedDraft,
        clearError: true,
      ),
    );

    final result = await _repo.uploadModel(updatedDraft);

    result.fold(
      (failure) {
        emit(
          _form.copyWith(
            isBusy: false,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        final labels = _extractAiLabels(response);
        emit(
          _form.copyWith(
            isBusy: false,
            draft: updatedDraft.copyWith(aiLabels: labels),
            responseEntity: response,
          ),
        );
      },
    );
  }

  List<AiLabelScore> _extractAiLabels(UploadModelResponseEntity response) {
    final list = <AiLabelScore>[];
    final pred = response.prediction;
    if (pred != null) {
      if (pred.superCategory != null) {
        list.add(AiLabelScore(
          label: 'Super Category: ${pred.superCategory!.label}',
          confidence: pred.superCategory!.confidence,
        ));
      }
      if (pred.objectCategory != null) {
        list.add(AiLabelScore(
          label: 'Object Category: ${pred.objectCategory!.label}',
          confidence: pred.objectCategory!.confidence,
        ));
      }
      if (pred.materialsPrimary != null) {
        list.add(AiLabelScore(
          label: 'Primary Material: ${pred.materialsPrimary!.label}',
          confidence: pred.materialsPrimary!.confidence,
        ));
      }
      for (final item in pred.styleClass) {
        list.add(AiLabelScore(
          label: 'Style: ${item.label}',
          confidence: item.confidence,
        ));
      }
      for (final item in pred.materialsSecondary) {
        list.add(AiLabelScore(
          label: 'Secondary Material: ${item.label}',
          confidence: item.confidence,
        ));
      }
    }
    return list;
  }

  void back() {
    switch (_form.step) {
      case UploadStep.file:
        break;
      case UploadStep.details:
        emit(_form.copyWith(step: UploadStep.file, clearError: true));
      case UploadStep.aiReview:
        emit(_form.copyWith(step: UploadStep.details, clearError: true));
    }
  }

  Future<void> submit() async {
    emit(_form.copyWith(isBusy: true, clearError: true));
    try {
      await _repo.submitUpload(_form.draft);
      emit(_form.copyWith(isBusy: false, submitted: true));
    } catch (e) {
      emit(_form.copyWith(isBusy: false, errorMessage: e.toString()));
    }
  }

  void reset() {
    emit(
      const UploadFormState(step: UploadStep.file, draft: UploadDraftEntity()),
    );
  }
}
