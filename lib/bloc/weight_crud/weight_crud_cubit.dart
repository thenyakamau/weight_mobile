import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import 'package:weighter/repo/repo.dart';

import '../../model/weight.dart';

part 'weight_crud_state.dart';

@injectable
class WeightCrudCubit extends Cubit<WeightCrudState> {
  WeightCrudCubit(this._repo) : super(WeightCrudState());
  final RepoInterface _repo;

  void setWeight(Weight weight) => _actionCallBack(_repo.setWeight(weight));
  void updateWeight(Weight weight) =>
      _actionCallBack(_repo.updateWeight(weight));
  void deleteWeight(Weight weight) =>
      _actionCallBack(_repo.deleteWeight(weight));

  void _actionCallBack(Future<Either<String, String>> action) async {
    // emit(state.copyWith(status: WeightCrudStatus.loading));
    final _res = await action;
    emit(_res.fold(
      (error) => state.copyWith(status: WeightCrudStatus.error, error: error),
      (success) =>
          state.copyWith(status: WeightCrudStatus.success, success: success),
    ));
  }
}
