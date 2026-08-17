import 'package:equatable/equatable.dart';

import '../../domain/entities/get_reports_response_entity.dart';

sealed class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object?> get props => [];
}

class AdminInitial extends AdminState {
  const AdminInitial();
}

class AdminLoading extends AdminState {
  const AdminLoading();
}

class AdminLoaded extends AdminState {
  const AdminLoaded({
    required this.reportsResponse,
  });

  final GetReportsResponseEntity reportsResponse;

  @override
  List<Object?> get props => [reportsResponse];
}

class AdminFailure extends AdminState {
  const AdminFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
