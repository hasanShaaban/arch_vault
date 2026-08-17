import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/admin_repo.dart';
import 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminCubit(this._repo) : super(const AdminInitial());

  final AdminRepo _repo;

  Future<void> getReports() async {
    emit(const AdminLoading());

    final result = await _repo.getReports();

    result.fold(
      (failure) => emit(AdminFailure(failure.message)),
      (response) => emit(AdminLoaded(reportsResponse: response)),
    );
  }
}
