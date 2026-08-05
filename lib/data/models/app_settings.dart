import 'package:equatable/equatable.dart';

class AppSettings extends Equatable {
  final double? packPrice;
  final int cigarettesPerPack;

  const AppSettings({
    this.packPrice,
    this.cigarettesPerPack = 20,
  });

  @override
  List<Object?> get props => [packPrice, cigarettesPerPack];

  AppSettings copyWith({double? packPrice, int? cigarettesPerPack}) {
    return AppSettings(
      packPrice: packPrice ?? this.packPrice,
      cigarettesPerPack: cigarettesPerPack ?? this.cigarettesPerPack,
    );
  }

  double get costPerCigarette {
    if (packPrice == null || packPrice! <= 0) return 0;
    return packPrice! / cigarettesPerPack;
  }

  bool get isInitialized => packPrice != null && packPrice! > 0;
}