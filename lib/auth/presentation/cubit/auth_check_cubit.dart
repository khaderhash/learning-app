import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_check_state.dart';
import '../../data/secure_storage_service.dart';

class AuthCheckCubit extends Cubit<AuthCheckState> {
  final SecureStorageService _storageService = SecureStorageService();

  AuthCheckCubit() : super(AuthCheckInitial());

  Future<void> checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 1));

    final token = await _storageService.getToken();
    if (token != null && token.isNotEmpty) {
      emit(Authenticated());
    } else {
      emit(Unauthenticated());
    }
  }
}
