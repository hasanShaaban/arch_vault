import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repo/home_repo.dart';
import 'get_models_state.dart';

/// Number of items the API returns per page.
const int _kPageSize = 20;

class GetModelsCubit extends Cubit<GetModelsState> {
  GetModelsCubit(this._homeRepo) : super(const GetModelsInitial());

  final HomeRepo _homeRepo;

  Future<void> loadInitial() async {
    emit(const GetModelsLoading());
    await _fetchPage(page: 1, isLoadMore: false);
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! GetModelsLoaded) return;
    if (current.isLoadingMore || !current.hasMore) return;

    emit(current.copyWith(isLoadingMore: true));
    await _fetchPage(page: current.currentPage + 1, isLoadMore: true);
  }

  Future<void> _fetchPage({required int page, required bool isLoadMore}) async {
    final result = await _homeRepo.getAllModels(page: page);

    result.fold(
      (failure) {
        if (isLoadMore) {
          final current = state;
          if (current is GetModelsLoaded) {
            emit(current.copyWith(isLoadingMore: false));
          }
        }
        emit(GetModelsFailure(failure.message));
      },
      (response) {
        final totalPages = _calculateTotalPages(response.count);
        final previousModels = isLoadMore && state is GetModelsLoaded
            ? (state as GetModelsLoaded).models
            : <dynamic>[];

        emit(
          GetModelsLoaded(
            models: [...previousModels, ...response.results],
            currentPage: page,
            totalPages: totalPages,
          ),
        );
      },
    );
  }

  int _calculateTotalPages(int count) => (count / _kPageSize).ceil();
}
