import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  Never _notReady() =>
      throw UnimplementedError('Profile remote API is not connected yet.');

  @override
  Future<ProfileModel> getProfile() async => _notReady();
}
