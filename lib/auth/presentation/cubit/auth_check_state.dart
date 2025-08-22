import 'package:equatable/equatable.dart';

abstract class AuthCheckState extends Equatable {
  const AuthCheckState();
  @override
  List<Object> get props => [];
}

class AuthCheckInitial extends AuthCheckState {}

class Authenticated extends AuthCheckState {}

class Unauthenticated extends AuthCheckState {}
