import 'package:equatable/equatable.dart';

import '../../domain/entities/admin_dashboard_entity.dart';

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
  const AdminLoaded(
    this.dashboard, {
    this.actionInProgress = false,
    this.actionError,
  });

  final AdminDashboardEntity dashboard;
  final bool actionInProgress;
  final String? actionError;

  @override
  List<Object?> get props => [dashboard, actionInProgress, actionError];
}

class AdminFailure extends AdminState {
  const AdminFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
