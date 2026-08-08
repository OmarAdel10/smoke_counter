import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'core/theme/app_theme.dart';
import 'data/cubits/logs_cubit.dart';
import 'data/cubits/settings_cubit.dart';
import 'data/models/app_settings.dart';
import 'features/counter/counter_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/statistics/statistics_screen.dart';

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
        routes: {'/settings': (_) => const SettingsScreen()},
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
          return const MainNavigation();
        }
        return const OnboardingScreen();
      },
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [CounterScreen(), StatisticsScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.all(10),
        clipBehavior: Clip.antiAlias,
        color: Colors.transparent,
        child: ClipRRect(
          clipBehavior: Clip.antiAlias,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 25),
            decoration: BoxDecoration(
              color: AppTheme.ember.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                splashFactory: NoSplash.splashFactory,
                highlightColor: Colors.transparent,
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                currentIndex: _currentIndex,
                onTap: (index) => setState(() => _currentIndex = index),
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.local_fire_department_rounded),
                    label: 'Counter',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.analytics_rounded),
                    label: 'Statistics',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      // bottomNavigationBar: NavigationBar(
      //   selectedIndex: _currentIndex,
      //   onDestinationSelected: (index) => setState(() => _currentIndex = index),
      //   destinations: const [
      //     NavigationDestination(
      //       icon: Icon(Icons.local_fire_department_rounded),
      //       label: 'Counter',
      //     ),
      //     NavigationDestination(
      //       icon: Icon(Icons.analytics_rounded),
      //       label: 'Statistics',
      //     ),
      //   ],
      // ),
    );
  }
}
