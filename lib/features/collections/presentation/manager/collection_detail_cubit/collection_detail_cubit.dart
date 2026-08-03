import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repo/collections_repo.dart';
import 'collection_detail_state.dart';

class CollectionDetailCubit extends Cubit<CollectionDetailState> {
  CollectionDetailCubit(this._repo) : super(const CollectionDetailInitial());

  final CollectionsRepo _repo;

  Future<void> load(String id) async {
    emit(const CollectionDetailLoading());
    try {
      final detail = await _repo.getCollectionDetail(id);
      emit(CollectionDetailLoaded(detail));
    } catch (e) {
      emit(CollectionDetailFailureState(e.toString()));
    }
  }
}
