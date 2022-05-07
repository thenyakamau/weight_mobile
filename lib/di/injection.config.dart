// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:cloud_firestore/cloud_firestore.dart' as _i4;
import 'package:firebase_auth/firebase_auth.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../bloc/auth/auth_cubit.dart' as _i8;
import '../bloc/weight/weight_bloc.dart' as _i6;
import '../bloc/weight_crud/weight_crud_cubit.dart' as _i7;
import '../repo/repo.dart' as _i5;
import 'module_injection.dart' as _i9; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final moduleInjection = _$ModuleInjection();
  gh.factory<_i3.FirebaseAuth>(() => moduleInjection.firebaseAuth);
  gh.factory<_i4.FirebaseFirestore>(() => moduleInjection.firestore);
  gh.lazySingleton<_i5.RepoInterface>(
      () => _i5.Repo(get<_i3.FirebaseAuth>(), get<_i4.FirebaseFirestore>()));
  gh.factory<_i6.WeightBloc>(() => _i6.WeightBloc(get<_i5.RepoInterface>()));
  gh.factory<_i7.WeightCrudCubit>(
      () => _i7.WeightCrudCubit(get<_i5.RepoInterface>()));
  gh.factory<_i8.AuthCubit>(() => _i8.AuthCubit(get<_i5.RepoInterface>()));
  return get;
}

class _$ModuleInjection extends _i9.ModuleInjection {}
