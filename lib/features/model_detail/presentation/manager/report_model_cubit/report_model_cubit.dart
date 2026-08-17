import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repo/model_detail_repo.dart';
import 'report_model_state.dart';

class ReportModelCubit extends Cubit<ReportModelState> {
  ReportModelCubit(this._repo) : super(const ReportModelInitial());

  final ModelDetailRepo _repo;

  Future<void> reportModel({required String id, required String reason}) async {
    emit(const ReportModelLoading());
    final result = await _repo.reportModel(id: id, reason: reason);
    result.fold(
      (failure) => emit(ReportModelFailure(failure.message)),
      (success) {
        if (success) {
          emit(const ReportModelSuccess());
        } else {
          emit(const ReportModelFailure('Failed to send report. Please try again.'));
        }
      },
    );
  }
}
