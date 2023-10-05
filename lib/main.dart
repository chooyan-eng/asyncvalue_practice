import 'dart:math';

import 'package:asyncvalue_practice/async_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: _MainApp()));
}

class _MainApp extends ConsumerWidget {
  const _MainApp();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(fetchDataProvider);
    final notifier = ref.watch(fetchDataProvider.notifier);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('AsyncValue test'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _InfoRow(
                label: '型',
                content: asyncValue.runtimeType.toString(),
              ),
              const Divider(height: 16),
              _InfoRow(
                label: '.value',
                content: asyncValue.value?.toString() ?? 'null',
              ),
              const Divider(height: 16),
              _InfoRow(
                label: '.isLoading',
                content: asyncValue.isLoading.toString(),
              ),
              const Divider(height: 16),
              _InfoRow(
                label: '.isReloading',
                content: asyncValue.isReloading.toString(),
              ),
              const Divider(height: 16),
              _InfoRow(
                label: '.isRefreshing',
                content: asyncValue.isRefreshing.toString(),
              ),
              const Divider(height: 16),
              _InfoRow(
                label: '.hasError',
                content: asyncValue.hasError.toString(),
              ),
              const Divider(height: 16),
              _InfoRow(
                label: '.when',
                content: asyncValue.when(
                  data: (data) => 'data -> $data',
                  loading: () => 'loading',
                  error: (e, stack) => 'error -> $e',
                ),
              ),
              const Divider(height: 16),
              _InfoRow(
                label: '.valueOrNull',
                content: asyncValue.valueOrNull?.toString() ?? 'null',
              ),
              const SizedBox(height: 60),
              ElevatedButton(
                onPressed: () => notifier.updateData(Random().nextInt(100)),
                child: const Text('state = AsyncData'),
              ),
              const SizedBox(height: 4),
              OutlinedButton(
                onPressed: () => notifier.updateLoading(),
                child: const Text('state = AsyncLoading'),
              ),
              const SizedBox(height: 4),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                onPressed: () => notifier.updateError(),
                child: const Text('state = AsyncError'),
              ),
              const SizedBox(height: 4),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                ),
                onPressed: () => ref.invalidate(fetchDataProvider),
                child: const Text('ref.invalidate(fetchDataProvider)'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[700],
                ),
                onPressed: () => ref.invalidate(baseNumProvider),
                child: const Text('ref.invalidate(baseNumProvider)'),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.content,
  });

  final String label;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 20),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          content,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
