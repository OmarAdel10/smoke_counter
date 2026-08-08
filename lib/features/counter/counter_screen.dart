import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:smoke_counter/data/cubits/logs_cubit.dart';
import 'package:smoke_counter/data/cubits/settings_cubit.dart';
import 'package:smoke_counter/data/models/app_settings.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<LogsCubit>(),
      child: BlocProvider.value(
        value: context.read<SettingsCubit>(),
        child: const CounterView(),
      ),
    );
  }
}

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final today = DateFormat('EEEE, MMM d').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text(today),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                BlocBuilder<LogsCubit, Map<String, int>>(
                  builder: (context, state) {
                    final todayKey = DateFormat(
                      'yyyy-MM-dd',
                    ).format(DateTime.now());
                    final count = state[todayKey] ?? 0;
                    return Column(
                      children: [
                        Text(
                          '$count',
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontSize: 120,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Cigarettes Today',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const Spacer(),
                BlocBuilder<SettingsCubit, AppSettings>(
                  builder: (context, settings) {
                    if (!settings.isInitialized) return const SizedBox.shrink();
                    return BlocBuilder<LogsCubit, Map<String, int>>(
                      builder: (context, state) {
                        final todayKey = DateFormat(
                          'yyyy-MM-dd',
                        ).format(DateTime.now());
                        final count = state[todayKey] ?? 0;
                        final spend = count * settings.costPerCigarette;
                        return Text(
                          'Spent today: EGP ${spend.toStringAsFixed(2)}',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 32),
                BlocBuilder<LogsCubit, Map<String, int>>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: 72,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            context.read<LogsCubit>().logCigarette(),
                        icon: const Icon(Icons.add_rounded, size: 28),
                        label: const Text('Log Cigarette'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                BlocBuilder<LogsCubit, Map<String, int>>(
                  builder: (context, state) {
                    final todayKey = DateFormat(
                      'yyyy-MM-dd',
                    ).format(DateTime.now());
                    final count = state[todayKey] ?? 0;
                    return TextButton.icon(
                      onPressed: count > 0
                          ? () => context.read<LogsCubit>().undoLog()
                          : null,
                      icon: const Icon(Icons.remove_rounded, size: 20),
                      label: const Text('Undo Last'),
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
