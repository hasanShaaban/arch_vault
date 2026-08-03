import 'package:equatable/equatable.dart';

import '../../../domain/entities/collection_entity.dart';

sealed class CollectionsState extends Equatable {
  const CollectionsState();

  @override
  List<Object?> get props => [];
}

class CollectionsInitial extends CollectionsState {
  const CollectionsInitial();
}

class CollectionsLoading extends CollectionsState {
  const CollectionsLoading();
}

class CollectionsLoaded extends CollectionsState {
  const CollectionsLoaded(this.collections);

  final List<CollectionEntity> collections;

  @override
  List<Object?> get props => [collections];
}

class CollectionsFailureState extends CollectionsState {
  const CollectionsFailureState(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
