import 'dart:math';

import 'package:asyncvalue_practice/async_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: _MainApp()));
}

class _MainApp extends ConsumerStatefulWidget {
  const _MainApp();

  @override
  ConsumerState createState() {
    return _MainAppState();
  }
}

class _MainAppState extends ConsumerState<_MainApp> {
  var _skipLoadingOnRefresh = false;
  var _skipLoadingOnReload = true;

  @override
  Widget build(BuildContext context) {
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
                  skipLoadingOnRefresh: _skipLoadingOnRefresh,
                  skipLoadingOnReload: _skipLoadingOnReload,
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
              const SizedBox(height: 32),
              _CheckRow(
                label: 'skipLoadingOnRefresh',
                value: _skipLoadingOnRefresh,
                onChanged: (value) {
                  setState(() => _skipLoadingOnRefresh = value);
                },
              ),
              _CheckRow(
                label: 'skipLoadingOnReload',
                value: _skipLoadingOnReload,
                onChanged: (value) {
                  setState(() => _skipLoadingOnReload = value);
                },
              ),
              const SizedBox(height: 60),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () =>
                          notifier.updateData(Random().nextInt(100)),
                      child: const Text('Data'),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => notifier.updateLoading(),
                      child: const Text('Loading'),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      onPressed: () => notifier.updateError(),
                      child: const Text('Error'),
                    ),
                  ),
                ],
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

class _CheckRow extends StatelessWidget {
  const _CheckRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

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
        Checkbox(
          value: value,
          onChanged: (value) => onChanged(value ?? false),
        ),
      ],
    );
  }
}
