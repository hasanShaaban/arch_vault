import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/browse_asset_entity.dart';
import '../../../domain/repo/browse_repo.dart';
import 'browse_state.dart';

class BrowseCubit extends Cubit<BrowseState> {
  BrowseCubit(this._browseRepo) : super(const BrowseInitial());

  final BrowseRepo _browseRepo;

  Future<void> loadAssets() async {
    emit(const BrowseLoading());
    try {
      final assets = await _browseRepo.getAssets();
      emit(
        BrowseLoaded(
          allAssets: assets,
          visibleAssets: _applyFilters(
            assets: assets,
            query: '',
            label: 'All',
            fileFormat: 'All',
            sortOption: BrowseSortOption.topRated,
          ),
          query: '',
          label: 'All',
          fileFormat: 'All',
          sortOption: BrowseSortOption.topRated,
        ),
      );
    } catch (e) {
      emit(BrowseFailureState(e.toString()));
    }
  }

  void search(String query) {
    final current = state;
    if (current is! BrowseLoaded) return;
    emit(
      current.copyWith(
        query: query,
        visibleAssets: _applyFilters(
          assets: current.allAssets,
          query: query,
          label: current.label,
          fileFormat: current.fileFormat,
          sortOption: current.sortOption,
          superCategory: current.superCategory,
          subCategory: current.subCategory,
          styleClass: current.styleClass,
        ),
      ),
    );
  }

  void filterByLabel(String label) {
    final current = state;
    if (current is! BrowseLoaded) return;
    emit(
      current.copyWith(
        label: label,
        visibleAssets: _applyFilters(
          assets: current.allAssets,
          query: current.query,
          label: label,
          fileFormat: current.fileFormat,
          sortOption: current.sortOption,
          superCategory: current.superCategory,
          subCategory: current.subCategory,
          styleClass: current.styleClass,
        ),
      ),
    );
  }

  void filterByFormat(String fileFormat) {
    final current = state;
    if (current is! BrowseLoaded) return;
    emit(
      current.copyWith(
        fileFormat: fileFormat,
        visibleAssets: _applyFilters(
          assets: current.allAssets,
          query: current.query,
          label: current.label,
          fileFormat: fileFormat,
          sortOption: current.sortOption,
          superCategory: current.superCategory,
          subCategory: current.subCategory,
          styleClass: current.styleClass,
        ),
      ),
    );
  }

  void sortBy(BrowseSortOption sortOption) {
    final current = state;
    if (current is! BrowseLoaded) return;
    emit(
      current.copyWith(
        sortOption: sortOption,
        visibleAssets: _applyFilters(
          assets: current.allAssets,
          query: current.query,
          label: current.label,
          fileFormat: current.fileFormat,
          sortOption: sortOption,
          superCategory: current.superCategory,
          subCategory: current.subCategory,
          styleClass: current.styleClass,
        ),
      ),
    );
  }

  /// Filter by super category. Clears sub-category when super category changes.
  void filterBySuperCategory(String? superCategory) {
    final current = state;
    if (current is! BrowseLoaded) return;
    emit(
      current.copyWith(
        superCategory: superCategory,
        subCategory: null,
        visibleAssets: _applyFilters(
          assets: current.allAssets,
          query: current.query,
          label: current.label,
          fileFormat: current.fileFormat,
          sortOption: current.sortOption,
          superCategory: superCategory,
          subCategory: null,
          styleClass: current.styleClass,
        ),
      ),
    );
  }

  void filterBySubCategory(String? subCategory) {
    final current = state;
    if (current is! BrowseLoaded) return;
    emit(
      current.copyWith(
        subCategory: subCategory,
        visibleAssets: _applyFilters(
          assets: current.allAssets,
          query: current.query,
          label: current.label,
          fileFormat: current.fileFormat,
          sortOption: current.sortOption,
          superCategory: current.superCategory,
          subCategory: subCategory,
          styleClass: current.styleClass,
        ),
      ),
    );
  }

  void filterByStyleClass(String? styleClass) {
    final current = state;
    if (current is! BrowseLoaded) return;
    emit(
      current.copyWith(
        styleClass: styleClass,
        visibleAssets: _applyFilters(
          assets: current.allAssets,
          query: current.query,
          label: current.label,
          fileFormat: current.fileFormat,
          sortOption: current.sortOption,
          superCategory: current.superCategory,
          subCategory: current.subCategory,
          styleClass: styleClass,
        ),
      ),
    );
  }

  List<BrowseAssetEntity> _applyFilters({
    required List<BrowseAssetEntity> assets,
    required String query,
    required String label,
    required String fileFormat,
    required BrowseSortOption sortOption,
    String? superCategory,
    String? subCategory,
    String? styleClass,
  }) {
    var result = assets;
    final q = query.trim().toLowerCase();
    if (q.isNotEmpty) {
      result = result
          .where(
            (a) =>
                a.title.toLowerCase().contains(q) ||
                a.label.toLowerCase().contains(q),
          )
          .toList();
    }
    if (label != 'All') {
      result = result.where((a) => a.label == label).toList();
    }
    if (fileFormat != 'All') {
      result = result.where((a) => a.fileFormat == fileFormat).toList();
    }
    // NOTE: superCategory / subCategory / styleClass filtering will be wired
    // once the Browse API returns the full Model3dEntity fields. For now the
    // local BrowseAssetEntity doesn't carry those fields, so we skip silently.
    result = [...result];
    switch (sortOption) {
      case BrowseSortOption.topRated:
        result.sort((a, b) => b.rating.compareTo(a.rating));
      case BrowseSortOption.mostDownloaded:
        result.sort((a, b) => b.downloadCount.compareTo(a.downloadCount));
    }
    return result;
  }
}
