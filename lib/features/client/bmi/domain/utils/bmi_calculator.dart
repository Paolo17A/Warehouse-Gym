class BmiCalculator {
  const BmiCalculator._();

  /// [heightCm] in centimeters, [weightKg] in kilograms.
  static double fromMetric({required double heightCm, required double weightKg}) {
    if (heightCm <= 0 || weightKg <= 0) return 0;
    final heightM = heightCm / 100;
    return double.parse(
      (weightKg / (heightM * heightM)).toStringAsFixed(2),
    );
  }
}
