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
  });

  final List<BrowseAssetEntity> allAssets;
  final List<BrowseAssetEntity> visibleAssets;
  final String query;
  final String label;
  final String fileFormat;
  final BrowseSortOption sortOption;

  @override
  List<Object?> get props => [
        allAssets,
        visibleAssets,
        query,
        label,
        fileFormat,
        sortOption,
      ];

  BrowseLoaded copyWith({
    List<BrowseAssetEntity>? allAssets,
    List<BrowseAssetEntity>? visibleAssets,
    String? query,
    String? label,
    String? fileFormat,
    BrowseSortOption? sortOption,
  }) {
    return BrowseLoaded(
      allAssets: allAssets ?? this.allAssets,
      visibleAssets: visibleAssets ?? this.visibleAssets,
      query: query ?? this.query,
      label: label ?? this.label,
      fileFormat: fileFormat ?? this.fileFormat,
      sortOption: sortOption ?? this.sortOption,
    );
  }
}

class BrowseFailureState extends BrowseState {
  const BrowseFailureState(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
