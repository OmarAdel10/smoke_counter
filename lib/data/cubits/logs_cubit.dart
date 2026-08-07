import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';

class LogsCubit extends HydratedCubit<Map<String, int>> {
  LogsCubit() : super(<String, int>{});

  String get todayKey => DateFormat('yyyy-MM-dd').format(DateTime.now());

  int get todayCount => state[todayKey] ?? 0;

  void logCigarette() {
    final current = state[todayKey] ?? 0;
    emit({...state, todayKey: current + 1});
  }

  void undoLog() {
    final current = state[todayKey] ?? 0;
    if (current > 0) {
      emit({...state, todayKey: current - 1});
    }
  }

  int get totalCigarettes => state.values.fold(0, (sum, count) => sum + count);

  int get monthTotal {
    final now = DateTime.now();
    final monthKey = DateFormat('yyyy-MM').format(now);
    return state.entries
        .where((entry) => entry.key.startsWith(monthKey))
        .fold(0, (sum, entry) => sum + entry.value);
  }

  double get averagePerDay {
    if (state.isEmpty) return 0;
    return totalCigarettes / state.length;
  }

  List<MapEntry<String, int>> get sortedLogs {
    final entries = state.entries.toList();
    entries.sort((a, b) => b.key.compareTo(a.key));
    return entries;
  }

  @override
  Map<String, int> fromJson(Map<String, dynamic> json) {
    return json.map((key, value) => MapEntry(key, value as int));
  }

  @override
  Map<String, dynamic> toJson(Map<String, int> state) {
    return state;
  }
}
