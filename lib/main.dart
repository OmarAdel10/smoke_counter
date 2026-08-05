import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'core/theme/app_theme.dart';
import 'data/cubits/logs_cubit.dart';
import 'data/cubits/settings_cubit.dart';
import 'data/models/app_settings.dart';
import 'features/onboarding/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getApplicationDocumentsDirectory()).path,
    ),
  );
  runApp(const SmokeCounterApp());
}

class SmokeCounterApp extends StatelessWidget {
  const SmokeCounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LogsCubit()),
        BlocProvider(create: (_) => SettingsCubit()),
      ],
      child: MaterialApp(
        title: 'Smoke Counter',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const AppEntryPoint(),
      ),
    );
  }
}

class AppEntryPoint extends StatelessWidget {
  const AppEntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, AppSettings>(
      builder: (context, settings) {
        if (settings.isInitialized) {
          return const PlaceholderScreen();
        }
        return const OnboardingScreen();
      },
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smoke Counter')),
      body: const Center(
        child: Text('Project Setup Complete - Ready for Features'),
      ),
    );
  }
}