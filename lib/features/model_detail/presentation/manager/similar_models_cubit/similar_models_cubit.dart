import 'package:arch_vault/features/model_detail/domain/repo/model_detail_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'similar_models_state.dart';

class SimilarModelsCubit extends Cubit<SimilarModelsState> {
  final ModelDetailRepo _repo;

  SimilarModelsCubit(this._repo) : super(SimilarModelsInitial());

  Future<void> fetchSimilarModels(String id) async {
    emit(SimilarModelsLoading());
    final result = await _repo.getSimilar(id);
    result.fold(
      (failure) => emit(SimilarModelsFailure(failure.message)),
      (models) => emit(SimilarModelsSuccess(models)),
    );
  }
}
