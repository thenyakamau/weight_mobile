import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weighter/model/weight.dart';

abstract class RepoInterface {
  Future<Either<String, Unit>> signInAnonymous();
  Future<Either<String, bool>> fetchAuthUser();
  Future<Either<String, String>> logout();
  Future<Either<String, String>> setWeight(Weight weight);
  Future<Either<String, String>> updateWeight(Weight weight);
  Future<Either<String, String>> deleteWeight(Weight weight);
  Stream<Either<String, List<Weight>>> watchWeight();
}

const USER_COLLECTION = "user";
const WEIGHT_COLLECTION = "weight";

@LazySingleton(as: RepoInterface)
class Repo implements RepoInterface {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firebaseFirestore;

  Repo(this._auth, this._firebaseFirestore);

  @override
  Future<Either<String, Unit>> signInAnonymous() async {
    try {
      await _auth.signInAnonymously();
      return right(unit);
    } catch (e, s) {
      log("SIgn in error", error: e, stackTrace: s);
      return left("Please Try again");
    }
  }

  @override
  Future<Either<String, bool>> fetchAuthUser() async {
    try {
      final _user = _auth.currentUser;
      print("$_user");
      return right(_user != null);
    } catch (e, s) {
      log("Fetch Auth User error", error: e, stackTrace: s);
      return left("Please Try again");
    }
  }

  @override
  Future<Either<String, String>> logout() async {
    try {
      await _auth.signOut();
      return right("Logged out");
    } catch (e, s) {
      log("Log out error", error: e, stackTrace: s);
      return left("Please Try again");
    }
  }

  @override
  Future<Either<String, String>> setWeight(Weight weight) async {
    try {
      final _user = _auth.currentUser;
      if (_user == null) return left("Unauthenticated");
      await _firebaseFirestore
          .collection(USER_COLLECTION)
          .doc(_user.uid)
          .collection(WEIGHT_COLLECTION)
          .doc(weight.id)
          .set(weight.copyWith(uuid: _user.uid).toMap())
          .onError((error, stackTrace) => throw Exception());
      return right("created");
    } catch (e, s) {
      log("Set Weight error", error: e, stackTrace: s);
      return left("Please Try again");
    }
  }

  @override
  Future<Either<String, String>> updateWeight(Weight weight) async {
    try {
      final _user = _auth.currentUser;
      if (_user == null) return left("Unauthenticated");
      await _firebaseFirestore
          .collection(USER_COLLECTION)
          .doc(_user.uid)
          .collection(WEIGHT_COLLECTION)
          .doc(weight.id)
          .update(weight.copyWith(uuid: _user.uid).toMap())
          .onError((error, stackTrace) => throw Exception());
      return right("Updated");
    } catch (e, s) {
      log("Set Weight error", error: e, stackTrace: s);
      return left("Please Try again");
    }
  }

  @override
  Future<Either<String, String>> deleteWeight(Weight weight) async {
    try {
      final _user = _auth.currentUser;
      if (_user == null) return left("Unauthenticated");
      await _firebaseFirestore
          .collection(USER_COLLECTION)
          .doc(_user.uid)
          .collection(WEIGHT_COLLECTION)
          .doc(weight.id)
          .delete()
          .onError((error, stackTrace) => throw Exception());
      return right("Deleted");
    } catch (e, s) {
      log("Set Weight error", error: e, stackTrace: s);
      return left("Please Try again");
    }
  }

  @override
  Stream<Either<String, List<Weight>>> watchWeight() async* {
    final _user = _auth.currentUser;
    if (_user == null) yield left("Unauthenticated");
    yield* _firebaseFirestore
        .collection(USER_COLLECTION)
        .doc(_user!.uid)
        .collection(WEIGHT_COLLECTION)
        .orderBy("time", descending: true)
        .snapshots()
        .map((snapshots) => right<String, List<Weight>>(snapshots.docs
            .map((doc) => Weight.fromFirestore(doc))
            .where((element) => element.uuid == _user.uid)
            .toList()))
        .onErrorReturnWith((e, s) {
      log("Watch Weight error", error: e, stackTrace: s);
      return left(e.toString());
    });
  }
}
