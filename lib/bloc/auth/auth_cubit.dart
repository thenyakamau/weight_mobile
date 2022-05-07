import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import 'package:weighter/repo/repo.dart';

part 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repo) : super(AuthState());
  final RepoInterface _repo;

  void checkAuth() async {
    emit(state.copyWith(status: AuthStatus.loading));
    final _res = await _repo.fetchAuthUser();
    emit(_res.fold(
      (l) => state.copyWith(status: AuthStatus.loggedOut),
      (status) {
        if (status) {
          return state.copyWith(status: AuthStatus.loggedIn);
        } else {
          return state.copyWith(status: AuthStatus.loggedOut);
        }
      },
    ));
  }

  void loginAnonymously() async {
    emit(state.copyWith(status: AuthStatus.loading));
    final _res = await _repo.signInAnonymous();
    emit(_res.fold(
      (error) => state.copyWith(status: AuthStatus.error, error: error),
      (r) => state.copyWith(status: AuthStatus.loggedIn),
    ));
  }

  void logout() async {
    emit(state.copyWith(status: AuthStatus.loading));
    final _res = await _repo.logout();
    emit(_res.fold(
      (l) => state.copyWith(status: AuthStatus.loggedOut),
      (r) => state.copyWith(status: AuthStatus.loggedOut),
    ));
  }
}
