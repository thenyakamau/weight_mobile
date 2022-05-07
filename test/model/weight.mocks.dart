// Mocks generated by Mockito 5.1.0 from annotations
// in weighter/test/model/weight.dart.
// Do not manually edit this file.

import 'package:mockito/mockito.dart' as _i1;
import 'package:weighter/model/weight.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeDateTime_0 extends _i1.Fake implements DateTime {}

class _FakeWeight_1 extends _i1.Fake implements _i2.Weight {}

/// A class which mocks [Weight].
///
/// See the documentation for Mockito's code generation for more information.
class MockWeight extends _i1.Mock implements _i2.Weight {
  MockWeight() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get id =>
      (super.noSuchMethod(Invocation.getter(#id), returnValue: '') as String);
  @override
  DateTime get time => (super.noSuchMethod(Invocation.getter(#time),
      returnValue: _FakeDateTime_0()) as DateTime);
  @override
  double get weight =>
      (super.noSuchMethod(Invocation.getter(#weight), returnValue: 0.0)
          as double);
  @override
  _i2.Weight copyWith(
          {String? id, DateTime? time, double? weight, String? uuid}) =>
      (super.noSuchMethod(
          Invocation.method(#copyWith, [],
              {#id: id, #time: time, #weight: weight, #uuid: uuid}),
          returnValue: _FakeWeight_1()) as _i2.Weight);
  @override
  Map<String, dynamic> toMap() =>
      (super.noSuchMethod(Invocation.method(#toMap, []),
          returnValue: <String, dynamic>{}) as Map<String, dynamic>);
  @override
  String toJson() =>
      (super.noSuchMethod(Invocation.method(#toJson, []), returnValue: '')
          as String);
}