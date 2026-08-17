import 'package:equatable/equatable.dart';

import '../../../domain/entities/browse_asset_entity.dart';

sealed class BrowseState extends Equatable {
  const BrowseState();

  @override
  List<Object?> get props => [];
}

class BrowseInitial extends BrowseState {
  const BrowseInitial();
}

class BrowseLoading extends BrowseState {
  const BrowseLoading();
}

class BrowseLoaded extends BrowseState {
  const BrowseLoaded({
    required this.allAssets,
    required this.visibleAssets,
    required this.query,
    required this.label,
    required this.fileFormat,
    required this.sortOption,
    this.superCategory,
    this.subCategory,
    this.styleClass,
  });

  final List<BrowseAssetEntity> allAssets;
  final List<BrowseAssetEntity> visibleAssets;
  final String query;
  final String label;
  final String fileFormat;
  final BrowseSortOption sortOption;

  /// Selected super category, null means "All"
  final String? superCategory;

  /// Selected sub-family / object category, null means "All"
  final String? subCategory;

  /// Selected style class, null means "All"
  final String? styleClass;

  @override
  List<Object?> get props => [
        allAssets,
        visibleAssets,
        query,
        label,
        fileFormat,
        sortOption,
        superCategory,
        subCategory,
        styleClass,
      ];

  BrowseLoaded copyWith({
    List<BrowseAssetEntity>? allAssets,
    List<BrowseAssetEntity>? visibleAssets,
    String? query,
    String? label,
    String? fileFormat,
    BrowseSortOption? sortOption,
    Object? superCategory = _sentinel,
    Object? subCategory = _sentinel,
    Object? styleClass = _sentinel,
  }) {
    return BrowseLoaded(
      allAssets: allAssets ?? this.allAssets,
      visibleAssets: visibleAssets ?? this.visibleAssets,
      query: query ?? this.query,
      label: label ?? this.label,
      fileFormat: fileFormat ?? this.fileFormat,
      sortOption: sortOption ?? this.sortOption,
      superCategory:
          superCategory == _sentinel ? this.superCategory : superCategory as String?,
      subCategory:
          subCategory == _sentinel ? this.subCategory : subCategory as String?,
      styleClass:
          styleClass == _sentinel ? this.styleClass : styleClass as String?,
    );
  }
}

// Sentinel to distinguish "not provided" from explicit null in copyWith
const _sentinel = Object();

class BrowseFailureState extends BrowseState {
  const BrowseFailureState(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
