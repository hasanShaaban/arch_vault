import 'package:equatable/equatable.dart';

import '../../../domain/entities/model_detail_entity.dart';

sealed class ModelDetailState extends Equatable {
  const ModelDetailState();

  @override
  List<Object?> get props => [];
}

class ModelDetailInitial extends ModelDetailState {
  const ModelDetailInitial();
}

class ModelDetailLoading extends ModelDetailState {
  const ModelDetailLoading();
}

class ModelDetailLoaded extends ModelDetailState {
  const ModelDetailLoaded({
    required this.model,
    required this.similar,
    this.isDownloading = false,
    this.isRating = false,
    this.userRating,
    this.statusMessage,
  });

  final ModelDetailEntity model;
  final List<SimilarModelEntity> similar;
  final bool isDownloading;
  final bool isRating;
  final int? userRating;
  final String? statusMessage;

  @override
  List<Object?> get props => [
        model.id,
        model.rating,
        model.downloadCount,
        similar,
        isDownloading,
        isRating,
        userRating,
        statusMessage,
      ];

  ModelDetailLoaded copyWith({
    ModelDetailEntity? model,
    List<SimilarModelEntity>? similar,
    bool? isDownloading,
    bool? isRating,
    int? userRating,
    String? statusMessage,
    bool clearStatus = false,
  }) {
    return ModelDetailLoaded(
      model: model ?? this.model,
      similar: similar ?? this.similar,
      isDownloading: isDownloading ?? this.isDownloading,
      isRating: isRating ?? this.isRating,
      userRating: userRating ?? this.userRating,
      statusMessage: clearStatus ? null : (statusMessage ?? this.statusMessage),
    );
  }
}

class ModelDetailFailureState extends ModelDetailState {
  const ModelDetailFailureState(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
