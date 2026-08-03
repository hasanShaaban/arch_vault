import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repo/home_repo.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._homeRepo) : super(const HomeInitial());

  final HomeRepo _homeRepo;

  Future<void> loadFeatured() async {
    emit(const HomeLoading());
    try {
      final models = await _homeRepo.getFeaturedModels();
      emit(HomeLoaded(models));
    } catch (e) {
      emit(HomeFailureState(e.toString()));
    }
  }
}
