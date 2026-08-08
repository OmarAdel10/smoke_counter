import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../models/app_settings.dart';

class SettingsCubit extends HydratedCubit<AppSettings> {
  SettingsCubit() : super(const AppSettings());

  void setPackPrice(double price) {
    emit(state.copyWith(packPrice: price));
  }

  void setCigarettesPerPack(int count) {
    emit(state.copyWith(cigarettesPerPack: count));
  }

  @override
  AppSettings fromJson(Map<String, dynamic> json) {
    return AppSettings(
      packPrice: json['packPrice'] as double?,
      cigarettesPerPack: json['cigarettesPerPack'] as int? ?? 20,
    );
  }

  @override
  Map<String, dynamic> toJson(AppSettings state) {
    return {
      'packPrice': state.packPrice,
      'cigarettesPerPack': state.cigarettesPerPack,
    };
  }
}
