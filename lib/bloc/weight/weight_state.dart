part of 'weight_bloc.dart';

@immutable
class WeightState {
  final WeightStatus status;
  final List<Weight> weight;
  final String? error;

  WeightState({
    this.status = WeightStatus.initial,
    this.weight = const [],
    this.error,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WeightState &&
        other.status == status &&
        listEquals(other.weight, weight) &&
        other.error == error;
  }

  @override
  int get hashCode => status.hashCode ^ weight.hashCode ^ error.hashCode;

  @override
  String toString() =>
      'WeightState(status: $status, weight: $weight, error: $error)';

  WeightState copyWith({
    required WeightStatus? status,
    List<Weight>? weight,
    String? error,
  }) {
    return WeightState(
      status: status ?? this.status,
      weight: weight ?? this.weight,
      error: error ?? this.error,
    );
  }
}

enum WeightStatus { initial, loading, success, error }
