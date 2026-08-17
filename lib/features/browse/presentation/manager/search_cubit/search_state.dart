import 'package:equatable/equatable.dart';
import 'package:arch_vault/features/home/domain/entities/model_3d_entity.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

/// Before any search has been performed.
class SearchInitial extends SearchState {
  const SearchInitial();
}

/// First page loading.
class SearchLoading extends SearchState {
  const SearchLoading();
}

/// Successfully fetched data, supports pagination.
class SearchLoaded extends SearchState {
  const SearchLoaded({
    required this.models,
    required this.currentPage,
    required this.totalPages,
    this.q,
    this.superCategory,
    this.subFamily,
    this.styleClass,
    this.isLoadingMore = false,
  });

  final List<Model3dEntity> models;
  final int currentPage;
  final int totalPages;
  final String? q;
  final String? superCategory;
  final String? subFamily;
  final String? styleClass;
  final bool isLoadingMore;

  bool get hasMore => currentPage < totalPages;

  SearchLoaded copyWith({
    List<Model3dEntity>? models,
    int? currentPage,
    int? totalPages,
    Object? q = _sentinel,
    Object? superCategory = _sentinel,
    Object? subFamily = _sentinel,
    Object? styleClass = _sentinel,
    bool? isLoadingMore,
  }) {
    return SearchLoaded(
      models: models ?? this.models,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      q: q == _sentinel ? this.q : q as String?,
      superCategory: superCategory == _sentinel
          ? this.superCategory
          : superCategory as String?,
      subFamily:
          subFamily == _sentinel ? this.subFamily : subFamily as String?,
      styleClass:
          styleClass == _sentinel ? this.styleClass : styleClass as String?,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
        models,
        currentPage,
        totalPages,
        q,
        superCategory,
        subFamily,
        styleClass,
        isLoadingMore,
      ];
}

const Object _sentinel = Object();

/// Failed to fetch search results.
class SearchFailure extends SearchState {
  const SearchFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
