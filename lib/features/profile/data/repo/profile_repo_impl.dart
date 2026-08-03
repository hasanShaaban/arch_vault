import '../../domain/entities/profile_entity.dart';
import '../../domain/repo/profile_repo.dart';
import '../data_sources/profile_local_data_source.dart';

class ProfileRepoImpl implements ProfileRepo {
  ProfileRepoImpl(this._localDataSource);

  final ProfileLocalDataSource _localDataSource;

  @override
  Future<ProfileEntity> getProfile() async {
    final model = await _localDataSource.getProfile();
    return model.toEntity();
  }
}
