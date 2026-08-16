part of 'visitor_session_cubit.dart';

sealed class VisitorSessionState {
  const VisitorSessionState();
}

/// The user has not logged in — browse-only access.
class VisitorSessionGuest extends VisitorSessionState {
  const VisitorSessionGuest();
}

/// The user has authenticated successfully.
class VisitorSessionAuthenticated extends VisitorSessionState {
  const VisitorSessionAuthenticated({required this.role});

  /// The authenticated role: `'admin'` or `'user'`.
  final String role;

  bool get isAdmin => role == 'admin';
}
