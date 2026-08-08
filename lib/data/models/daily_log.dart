import 'package:equatable/equatable.dart';

class DailyLog extends Equatable {
  final String dateKey;
  final int count;

  const DailyLog({required this.dateKey, required this.count});

  @override
  List<Object> get props => [dateKey, count];

  DailyLog copyWith({String? dateKey, int? count}) {
    return DailyLog(
      dateKey: dateKey ?? this.dateKey,
      count: count ?? this.count,
    );
  }
}
