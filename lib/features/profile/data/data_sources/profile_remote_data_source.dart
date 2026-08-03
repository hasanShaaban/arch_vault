import '../models/profile_model.dart';

/// Remote profile API contract. Wired when Django endpoints are available.
abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  Never _notReady() =>
      throw UnimplementedError('Profile remote API is not connected yet.');

  @override
  Future<ProfileModel> getProfile() async => _notReady();
}
