import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/admin_repo.dart';
import 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminCubit(this._repo) : super(const AdminInitial());

  final AdminRepo _repo;

  Future<void> loadDashboard() async {
    emit(const AdminLoading());
    try {
      final dashboard = await _repo.getDashboard();
      emit(AdminLoaded(dashboard));
    } catch (e) {
      emit(AdminFailure(e.toString()));
    }
  }

  Future<void> resolveReport(String id) => _runAction(
        () => _repo.resolveReport(id),
      );

  Future<void> dismissReport(String id) => _runAction(
        () => _repo.dismissReport(id),
      );

  Future<void> setUserRole(String id, String role) => _runAction(
        () => _repo.setUserRole(id, role),
      );

  Future<void> updateModelLabel(String modelId, String label) => _runAction(
        () => _repo.updateModelLabel(modelId, label),
      );

  Future<void> _runAction(Future<void> Function() action) async {
    final current = state;
    if (current is! AdminLoaded) return;

    emit(AdminLoaded(current.dashboard, actionInProgress: true));
    try {
      await action();
      final dashboard = await _repo.getDashboard();
      emit(AdminLoaded(dashboard));
    } catch (e) {
      emit(
        AdminLoaded(
          current.dashboard,
          actionError: e.toString(),
        ),
      );
    }
  }
}
