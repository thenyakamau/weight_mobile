part of 'weight_bloc.dart';

@immutable
abstract class WeightEvent {}

class WatchWeightEvent extends WeightEvent {}

class _GetWeightEvent extends WeightEvent {
  final Either<String, List<Weight>> data;

  _GetWeightEvent(this.data);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _GetWeightEvent && other.data == data;
  }

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => '_GetWeightEvent(data: $data)';
}
