// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'async_notifier.g.dart';

// @riverpod
// class SomeOtherController extends _$SomeOtherController {
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class SomeOtherController extends AsyncNotifier<String> {
  @override
  FutureOr<String> build() async {
    final someString = await stringAfterThreeSec(20);
    return anotherFutureThatReturnsAString(someString);
  }

  Future<int> someFutureThatReturnsAint(int someValue) async {
    await Future<void>.delayed(const Duration(milliseconds: 3000));
    state = const AsyncLoading();

    return someValue;
  }

  Future<String> stringAfterThreeSec(int someValue) async {
    await Future<void>.delayed(const Duration(milliseconds: 5000));

    return someValue.toString();
  }

  Future<String> anotherFutureThatReturnsAString(String someString) async {
    return someString;
  }
}

final asyncControllerProvider =
    AsyncNotifierProvider<SomeOtherController, String>(SomeOtherController.new);
