import 'package:equatable/equatable.dart';

import '../../../domain/entities/model_asset_entity.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  const HomeLoaded(this.models);

  final List<ModelAssetEntity> models;

  @override
  List<Object?> get props => [models];
}

class HomeFailureState extends HomeState {
  const HomeFailureState(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
