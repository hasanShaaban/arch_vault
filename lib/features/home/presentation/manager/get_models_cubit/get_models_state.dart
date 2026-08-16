import 'package:equatable/equatable.dart';

import '../../../domain/entities/model_3d_entity.dart';

sealed class GetModelsState extends Equatable {
  const GetModelsState();

  @override
  List<Object?> get props => [];
}

/// Before any load has been triggered.
class GetModelsInitial extends GetModelsState {
  const GetModelsInitial();
}

/// First-page fetch in progress (no data yet).
class GetModelsLoading extends GetModelsState {
  const GetModelsLoading();
}

/// Loaded successfully; may still be fetching the next page.
class GetModelsLoaded extends GetModelsState {
  const GetModelsLoaded({
    required this.models,
    required this.currentPage,
    required this.totalPages,
    this.isLoadingMore = false,
  });

  /// All accumulated items across fetched pages.
  final List<Model3dEntity> models;

  /// The last page number that was successfully fetched (1-based).
  final int currentPage;

  /// Total number of pages calculated from the API count field.
  final int totalPages;

  /// True while the *next* page is being fetched.
  final bool isLoadingMore;

  bool get hasMore => currentPage < totalPages;

  GetModelsLoaded copyWith({
    List<Model3dEntity>? models,
    int? currentPage,
    int? totalPages,
    bool? isLoadingMore,
  }) =>
      GetModelsLoaded(
        models: models ?? this.models,
        currentPage: currentPage ?? this.currentPage,
        totalPages: totalPages ?? this.totalPages,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      );

  @override
  List<Object?> get props => [models, currentPage, totalPages, isLoadingMore];
}

/// An error occurred (first load or load-more).
class GetModelsFailure extends GetModelsState {
  const GetModelsFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
