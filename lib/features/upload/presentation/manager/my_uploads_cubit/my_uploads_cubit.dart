import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repo/upload_repo.dart';
import 'my_uploads_state.dart';

class MyUploadsCubit extends Cubit<MyUploadsState> {
  MyUploadsCubit(this._repo) : super(const MyUploadsInitial());

  final UploadRepo _repo;

  Future<void> load() async {
    emit(const MyUploadsLoading());
    try {
      final uploads = await _repo.getMyUploads();
      emit(MyUploadsLoaded(uploads));
    } catch (e) {
      emit(MyUploadsFailureState(e.toString()));
    }
  }
}
