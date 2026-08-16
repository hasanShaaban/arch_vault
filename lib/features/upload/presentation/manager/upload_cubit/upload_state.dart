import 'package:equatable/equatable.dart';

import '../../../domain/entities/upload_draft_entity.dart';
import '../../../domain/entities/upload_model_response_entity.dart';

sealed class UploadState extends Equatable {
  const UploadState();

  @override
  List<Object?> get props => [];
}

class UploadFormState extends UploadState {
  const UploadFormState({
    required this.step,
    required this.draft,
    this.isBusy = false,
    this.errorMessage,
    this.submitted = false,
    this.responseEntity,
  });

  final UploadStep step;
  final UploadDraftEntity draft;
  final bool isBusy;
  final String? errorMessage;
  final bool submitted;
  final UploadModelResponseEntity? responseEntity;

  @override
  List<Object?> get props => [
        step,
        draft,
        isBusy,
        errorMessage,
        submitted,
        responseEntity,
      ];

  UploadFormState copyWith({
    UploadStep? step,
    UploadDraftEntity? draft,
    bool? isBusy,
    String? errorMessage,
    bool? submitted,
    UploadModelResponseEntity? responseEntity,
    bool clearError = false,
  }) {
    return UploadFormState(
      step: step ?? this.step,
      draft: draft ?? this.draft,
      isBusy: isBusy ?? this.isBusy,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      submitted: submitted ?? this.submitted,
      responseEntity: responseEntity ?? this.responseEntity,
    );
  }
}
