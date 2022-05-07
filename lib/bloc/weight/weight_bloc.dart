import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:weighter/model/weight.dart';
import 'package:flutter/foundation.dart';

import 'package:weighter/repo/repo.dart';

part 'weight_event.dart';
part 'weight_state.dart';

@injectable
class WeightBloc extends Bloc<WeightEvent, WeightState> {
  final RepoInterface _repo;
  WeightBloc(this._repo) : super(WeightState()) {
    on<WatchWeightEvent>((event, emit) async {
      await emit.onEach<Either<String, List<Weight>>>(_repo.watchWeight(),
          onData: (data) => add(_GetWeightEvent(data)),
          onError: (e, s) {
            log("Weight Stream Error", error: e, stackTrace: s);
            emit(
              state.copyWith(
                status: WeightStatus.error,
                error: e.toString(),
              ),
            );
          });
    });
    on<_GetWeightEvent>(
      (event, emit) => emit(
        event.data.fold(
          (error) => state.copyWith(
            status: WeightStatus.error,
            error: error,
          ),
          (weight) => state.copyWith(
            status: WeightStatus.success,
            weight: weight,
          ),
        ),
      ),
    );
  }
}
