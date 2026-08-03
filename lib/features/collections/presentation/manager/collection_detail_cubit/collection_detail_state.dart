import 'package:equatable/equatable.dart';

import '../../../domain/entities/collection_detail_entity.dart';

sealed class CollectionDetailState extends Equatable {
  const CollectionDetailState();

  @override
  List<Object?> get props => [];
}

class CollectionDetailInitial extends CollectionDetailState {
  const CollectionDetailInitial();
}

class CollectionDetailLoading extends CollectionDetailState {
  const CollectionDetailLoading();
}

class CollectionDetailLoaded extends CollectionDetailState {
  const CollectionDetailLoaded(this.detail);

  final CollectionDetailEntity detail;

  @override
  List<Object?> get props => [detail];
}

class CollectionDetailFailureState extends CollectionDetailState {
  const CollectionDetailFailureState(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
