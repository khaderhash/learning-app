import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'profile_state.dart';
import '../../data/profile_data_source.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileDataSource _dataSource = ProfileDataSource();
  final ImagePicker _picker = ImagePicker();

  ProfileCubit() : super(ProfileInitial());

  Future<void> fetchUserProfile() async {
    emit(ProfileLoading());
    try {
      final user = await _dataSource.getUserProfile();
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> updateUserPassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      await _dataSource.changePassword(oldPassword, newPassword);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> uploadProfileImage() async {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      try {
        final XFile? image = await _picker.pickImage(
          source: ImageSource.gallery,
        );
        if (image != null) {
          emit(ProfileLoading());
          final newImageUrl = await _dataSource.updateUserImage(
            File(image.path),
          );
          await fetchUserProfile();
        }
      } catch (e) {
        emit(ProfileError(e.toString()));
        emit(currentState);
      }
    }
  }
}
