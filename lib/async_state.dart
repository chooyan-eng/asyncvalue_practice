import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'async_state.g.dart';

@Riverpod(keepAlive: true)
int baseNum(BaseNumRef ref) {
  return Random().nextInt(10);
}

@Riverpod(keepAlive: true)
class FetchData extends _$FetchData {
  @override
  Future<int> build() async {
    return Future.delayed(
      const Duration(seconds: 1),
      () => ref.watch(baseNumProvider),
    );
  }

  void updateData(int data) => state = AsyncData(data);
  void updateLoading() => state = const AsyncLoading();
  void updateError() async {
    state = await AsyncValue.guard(
      () => throw UnimplementedError(),
    );
  }
}
