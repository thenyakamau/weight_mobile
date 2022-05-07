part of 'weight_crud_cubit.dart';

@immutable
class WeightCrudState {
  final WeightCrudStatus status;
  final String? error;
  final String success;
  WeightCrudState({
    this.status = WeightCrudStatus.initial,
    this.error,
    this.success = "",
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WeightCrudState &&
        other.status == status &&
        other.error == error &&
        other.success == success;
  }

  @override
  int get hashCode => status.hashCode ^ error.hashCode ^ success.hashCode;

  @override
  String toString() =>
      'WeightCrudState(status: $status, error: $error, success: $success)';

  WeightCrudState copyWith({
    required WeightCrudStatus? status,
    String? error,
    String? success,
  }) {
    return WeightCrudState(
      status: status ?? this.status,
      error: error ?? this.error,
      success: success ?? this.success,
    );
  }
}

enum WeightCrudStatus { initial, success, error, loading }
