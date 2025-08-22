import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';
import '../../data/auth_data_source.dart';
import '../../data/secure_storage_service.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthDataSource _authDataSource = AuthDataSource();
  final SecureStorageService _storageService = SecureStorageService();

  AuthCubit() : super(AuthInitial());

  Future<void> signUpUser({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    emit(AuthLoading());
    try {
      final response = await _authDataSource.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );

      final token = response['token'] as String?;
      if (token != null) {
        await _storageService.saveToken(token);
        emit(AuthSuccess());
      } else {
        emit(const AuthFailure('Token not found in response'));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> loginUser({
    required String phone,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final response = await _authDataSource.login(
        phone: phone,
        password: password,
      );

      final token = response['token'] as String?;
      if (token != null) {
        await _storageService.saveToken(token);
        emit(AuthSuccess());
      } else {
        emit(const AuthFailure('Token not found in login response'));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> logout() async {
    await _storageService.deleteToken();
  }
}
