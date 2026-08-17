import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repo/browse_repo.dart';
import 'search_state.dart';

const int _kPageSize = 20;

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this._browseRepo) : super(const SearchInitial());

  final BrowseRepo _browseRepo;

  /// Trigger a new search with optional query and filters.
  /// Fetches page 1 and resets previous results.
  Future<void> search({
    String? q,
    String? superCategory,
    String? subFamily,
    String? styleClass,
  }) async {
    emit(const SearchLoading());

    final result = await _browseRepo.search(
      q: q ?? '',
      superCategory: superCategory ?? '',
      subFamily: subFamily ?? '',
      styleClass: styleClass ?? '',
      page: 1,
    );

    result.fold((failure) => emit(SearchFailure(failure.message)), (response) {
      final totalPages = _calculateTotalPages(response.count);
      emit(
        SearchLoaded(
          models: response.results,
          currentPage: 1,
          totalPages: totalPages,
          q: q,
          superCategory: superCategory,
          subFamily: subFamily,
          styleClass: styleClass,
        ),
      );
    });
  }

  /// Load next page for the current search query and filters.
  Future<void> loadMore() async {
    final current = state;
    if (current is! SearchLoaded) return;
    if (current.isLoadingMore || !current.hasMore) return;

    emit(current.copyWith(isLoadingMore: true));
    final nextPage = current.currentPage + 1;

    final result = await _browseRepo.search(
      q: current.q,
      superCategory: current.superCategory,
      subFamily: current.subFamily,
      styleClass: current.styleClass,
      page: nextPage,
    );

    result.fold(
      (failure) {
        // Keep current models but stop loading indicator
        emit(current.copyWith(isLoadingMore: false));
      },
      (response) {
        final totalPages = _calculateTotalPages(response.count);
        emit(
          current.copyWith(
            models: [...current.models, ...response.results],
            currentPage: nextPage,
            totalPages: totalPages,
            isLoadingMore: false,
          ),
        );
      },
    );
  }

  int _calculateTotalPages(int count) => (count / _kPageSize).ceil();
}
