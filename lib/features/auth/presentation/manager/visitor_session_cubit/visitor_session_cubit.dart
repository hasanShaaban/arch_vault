import 'package:flutter_bloc/flutter_bloc.dart';

part 'visitor_session_state.dart';

/// Tracks whether the current user is a guest (visitor) or authenticated.
///
/// Starts as [VisitorSessionGuest] on every cold launch.
/// Call [setLoggedIn] after a successful login/signup to switch to
/// [VisitorSessionAuthenticated].
/// Call [logout] to revert to guest mode.
class VisitorSessionCubit extends Cubit<VisitorSessionState> {
  VisitorSessionCubit() : super(const VisitorSessionGuest());

  /// Mark the session as authenticated (called after successful login/signup).
  /// [role] should be `'admin'` or `'user'`.
  void setLoggedIn({required String role}) =>
      emit(VisitorSessionAuthenticated(role: role));

  /// Revert to visitor/guest mode (called on logout).
  void logout() => emit(const VisitorSessionGuest());

  /// Convenience getters.
  bool get isLoggedIn => state is VisitorSessionAuthenticated;
  bool get isAdmin =>
      state is VisitorSessionAuthenticated &&
      (state as VisitorSessionAuthenticated).isAdmin;
}
