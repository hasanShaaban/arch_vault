import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/upload_draft_entity.dart';
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

  static const _allowedExtensions = [
    'gltf',
    'glb',
    'obj',
    'fbx',
    'blend',
  ];

  UploadFormState get _form => state as UploadFormState;

  Future<void> pickModelFile() async {
    emit(_form.copyWith(isBusy: true, clearError: true));
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: _allowedExtensions,
        withData: false,
      );
      if (result == null || result.files.isEmpty) {
        emit(_form.copyWith(isBusy: false));
        return;
      }
      final file = result.files.first;
      emit(
        _form.copyWith(
          isBusy: false,
          draft: _form.draft.copyWith(fileName: file.name),
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        _form.copyWith(
          isBusy: false,
          errorMessage: 'Could not pick file: $e',
        ),
      );
    }
  }

  void updateDetails({
    required String title,
    required String description,
    required String tagsCsv,
  }) {
    final tags = tagsCsv
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();
    emit(
      _form.copyWith(
        draft: _form.draft.copyWith(
          title: title,
          description: description,
          tags: tags,
        ),
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
    required String tagsCsv,
  }) async {
    if (title.trim().isEmpty) {
      emit(_form.copyWith(errorMessage: 'Title is required.'));
      return;
    }
    updateDetails(
      title: title,
      description: description,
      tagsCsv: tagsCsv,
    );

    emit(_form.copyWith(isBusy: true, clearError: true));
    try {
      final labels = await _repo.classifyMock(
        fileName: _form.draft.fileName!,
        title: _form.draft.title,
      );
      emit(
        _form.copyWith(
          isBusy: false,
          step: UploadStep.aiReview,
          draft: _form.draft.copyWith(aiLabels: labels),
        ),
      );
    } catch (e) {
      emit(_form.copyWith(isBusy: false, errorMessage: e.toString()));
    }
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
      const UploadFormState(
        step: UploadStep.file,
        draft: UploadDraftEntity(),
      ),
    );
  }
}
