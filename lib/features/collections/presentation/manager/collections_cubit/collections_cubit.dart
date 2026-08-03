import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/collection_entity.dart';
import '../../../domain/repo/collections_repo.dart';
import 'collections_state.dart';

class CollectionsCubit extends Cubit<CollectionsState> {
  CollectionsCubit(this._repo) : super(const CollectionsInitial());

  final CollectionsRepo _repo;

  Future<void> load() async {
    emit(const CollectionsLoading());
    try {
      final collections = await _repo.getCollections();
      emit(CollectionsLoaded(collections));
    } catch (e) {
      emit(CollectionsFailureState(e.toString()));
    }
  }

  Future<void> create({
    required String name,
    required String description,
  }) async {
    try {
      await _repo.createCollection(name: name, description: description);
      await load();
    } catch (e) {
      emit(CollectionsFailureState(e.toString()));
    }
  }

  Future<void> update({
    required CollectionEntity collection,
    required String name,
    required String description,
  }) async {
    try {
      await _repo.updateCollection(
        id: collection.id,
        name: name,
        description: description,
      );
      await load();
    } catch (e) {
      emit(CollectionsFailureState(e.toString()));
    }
  }

  Future<void> delete(String id) async {
    try {
      await _repo.deleteCollection(id);
      await load();
    } catch (e) {
      emit(CollectionsFailureState(e.toString()));
    }
  }
}
