import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:smoke_counter/data/cubits/settings_cubit.dart';
import 'package:smoke_counter/data/models/app_settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<SettingsCubit>(),
      child: const SettingsView(),
    );
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: BlocBuilder<SettingsCubit, AppSettings>(
            builder: (context, settings) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pack Price',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Cost of one pack of cigarettes. Used to calculate daily and total spending.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _PriceField(),
                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 16),
                  Text(
                    'Cigarettes Per Pack',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Number of cigarettes in a pack. Default is 20.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _CigarettesPerPackField(),
                  const SizedBox(height: 32),
                  if (settings.isInitialized) ...[
                    const Divider(),
                    const SizedBox(height: 16),
                    Text(
                      'Current Cost Per Cigarette',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'EGP ${settings.costPerCigarette.toStringAsFixed(4)}',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Based on pack price and cigarettes per pack',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PriceField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = context.read<SettingsCubit>();
    final controller = TextEditingController(
      text: settings.state.packPrice?.toStringAsFixed(2) ?? '',
    );

    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Pack Price',
        hintText: 'e.g. 10.00',
        prefixText: 'EGP ',
        prefixStyle: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: theme.textTheme.headlineSmall,
      onChanged: (value) {
        final price = double.tryParse(value.replaceAll(',', '.'));
        if (price != null && price > 0) {
          settings.setPackPrice(price);
        }
      },
      onSubmitted: (value) {
        final price = double.tryParse(value.replaceAll(',', '.'));
        if (price != null && price > 0) {
          settings.setPackPrice(price);
        }
      },
    );
  }
}

class _CigarettesPerPackField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = context.read<SettingsCubit>();
    final controller = TextEditingController(
      text: settings.state.cigarettesPerPack.toString(),
    );

    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Cigarettes Per Pack',
        hintText: '20',
      ),
      style: theme.textTheme.headlineSmall,
      onChanged: (value) {
        final count = int.tryParse(value);
        if (count != null && count > 0) {
          settings.setCigarettesPerPack(count);
        }
      },
      onSubmitted: (value) {
        final count = int.tryParse(value);
        if (count != null && count > 0) {
          settings.setCigarettesPerPack(count);
        }
      },
    );
  }
}
