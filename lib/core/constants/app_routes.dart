class AppRoutes {
  AppRoutes._();

  static const String roleSelection = '/role-selection';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/';
  static const String browse = '/browse';
  static const String collections = '/collections';
  static const String collectionDetail = '/collections/:id';
  static const String profile = '/profile';
  static const String upload = '/upload';
  static const String uploads = '/uploads';
  static const String modelDetail = '/models/:id';
  static const String admin = '/admin';

  static String collectionDetailPath(String id) => '/collections/$id';
  static String modelDetailPath(String id) => '/models/$id';
}
