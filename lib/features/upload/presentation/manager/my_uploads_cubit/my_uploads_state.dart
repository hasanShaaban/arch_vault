import 'package:equatable/equatable.dart';

import '../../../domain/entities/upload_draft_entity.dart';

sealed class MyUploadsState extends Equatable {
  const MyUploadsState();

  @override
  List<Object?> get props => [];
}

class MyUploadsInitial extends MyUploadsState {
  const MyUploadsInitial();
}

class MyUploadsLoading extends MyUploadsState {
  const MyUploadsLoading();
}

class MyUploadsLoaded extends MyUploadsState {
  const MyUploadsLoaded(this.uploads);

  final List<MyUploadEntity> uploads;

  @override
  List<Object?> get props => [uploads];
}

class MyUploadsFailureState extends MyUploadsState {
  const MyUploadsFailureState(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
