import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smoke_counter/core/theme/app_theme.dart';

import 'package:smoke_counter/data/cubits/logs_cubit.dart';
import 'package:smoke_counter/data/cubits/settings_cubit.dart';
import 'package:smoke_counter/data/models/app_settings.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<LogsCubit>(),
      child: BlocProvider.value(
        value: context.read<SettingsCubit>(),
        child: const StatisticsView(),
      ),
    );
  }
}

class StatisticsView extends StatelessWidget {
  const StatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildSummaryCards(context),
            Divider(
              color: AppTheme.charcoal.withValues(alpha: 0.3),
              indent: 20,
              endIndent: 20,
            ),
            const SizedBox(height: 16),
            Expanded(child: _buildDayList(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<LogsCubit, Map<String, int>>(
      builder: (context, logsState) {
        return BlocBuilder<SettingsCubit, AppSettings>(
          builder: (context, settingsState) {
            final totalCigarettes = logsState.values.fold(
              0,
              (sum, count) => sum + count,
            );
            final averagePerDay = logsState.isEmpty
                ? 0.0
                : totalCigarettes / logsState.length;

            final now = DateTime.now();
            final monthKey = DateFormat('yyyy-MM').format(now);
            final monthTotal = logsState.entries
                .where((entry) => entry.key.startsWith(monthKey))
                .fold(0, (sum, entry) => sum + entry.value);

            final spentUntilNow = settingsState.isInitialized
                ? totalCigarettes * settingsState.costPerCigarette
                : 0.0;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: .center,
                    children: [
                      Expanded(
                        child: _StatCard(
                          label: 'Cig/day',
                          value: averagePerDay.toStringAsFixed(1),
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _StatCard(
                          label: 'Cig/month',
                          value: monthTotal.toString(),
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          label: 'Spent until now',
                          value: 'EGP ${spentUntilNow.toStringAsFixed(0)}',
                          color: theme.colorScheme.tertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDayList(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<LogsCubit, Map<String, int>>(
      builder: (context, state) {
        if (state.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.analytics_outlined,
                  size: 64,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'No data yet',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Log your first cigarette to see statistics',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        final sortedEntries = state.entries.toList()
          ..sort((a, b) => b.key.compareTo(a.key));

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: sortedEntries.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final entry = sortedEntries[index];
            final date = DateFormat('yyyy-MM-dd').parse(entry.key);
            final formattedDate = DateFormat('EEE, MMM d').format(date);
            final count = entry.value;

            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.primary.withValues(
                    alpha: 0.1,
                  ),
                  child: Text(
                    '$count',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                title: Text(
                  formattedDate,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  '$count cigarette${count == 1 ? '' : 's'}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.charcoal.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          mainAxisAlignment: .center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
