import 'package:equatable/equatable.dart';

sealed class ReportModelState extends Equatable {
  const ReportModelState();

  @override
  List<Object?> get props => [];
}

class ReportModelInitial extends ReportModelState {
  const ReportModelInitial();
}

class ReportModelLoading extends ReportModelState {
  const ReportModelLoading();
}

class ReportModelSuccess extends ReportModelState {
  const ReportModelSuccess();
}

class ReportModelFailure extends ReportModelState {
  const ReportModelFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
