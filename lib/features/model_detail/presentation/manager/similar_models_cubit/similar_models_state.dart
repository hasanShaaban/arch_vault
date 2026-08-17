import 'package:arch_vault/features/home/domain/entities/model_3d_entity.dart';
import 'package:equatable/equatable.dart';

abstract class SimilarModelsState extends Equatable {
  const SimilarModelsState();

  @override
  List<Object> get props => [];
}

class SimilarModelsInitial extends SimilarModelsState {}

class SimilarModelsLoading extends SimilarModelsState {}

class SimilarModelsSuccess extends SimilarModelsState {
  final List<Model3dEntity> models;

  const SimilarModelsSuccess(this.models);

  @override
  List<Object> get props => [models];
}

class SimilarModelsFailure extends SimilarModelsState {
  final String message;

  const SimilarModelsFailure(this.message);

  @override
  List<Object> get props => [message];
}
