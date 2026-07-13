import 'package:the_warehouse_gym/features/client/bmi/domain/entities/bmi_entry.dart';

class BmiEntryModel {
  final DateTime dateTime;
  final double bmiValue;

  const BmiEntryModel({
    required this.dateTime,
    required this.bmiValue,
  });

  factory BmiEntryModel.fromJson(Map<String, dynamic> data) {
    final recordedAt = data['recordedAt'] ?? data['dateTime'];
    return BmiEntryModel(
      dateTime: parseDateTime(recordedAt),
      bmiValue: (data['bmiValue'] as num?)?.toDouble() ?? 0.0,
    );
  }

  factory BmiEntryModel.fromFirestore(Map<String, dynamic> data) {
    return BmiEntryModel.fromJson(data);
  }

  static DateTime parseDateTime(dynamic rawDate) {
    if (rawDate is String && rawDate.isNotEmpty) {
      return DateTime.tryParse(rawDate) ?? DateTime.now();
    }
    if (rawDate is Map) {
      final month = (rawDate['month'] as num?)?.toInt() ?? DateTime.now().month;
      final day = (rawDate['day'] as num?)?.toInt() ?? DateTime.now().day;
      final year = (rawDate['year'] as num?)?.toInt() ?? DateTime.now().year;
      return DateTime(year, month, day);
    }
    return DateTime.now();
  }

  BmiEntry toEntity() {
    return BmiEntry(dateTime: dateTime, bmiValue: bmiValue);
  }

  Map<String, dynamic> toApi() {
    return {
      'bmiValue': bmiValue,
      'recordedAt': dateTime.toIso8601String(),
    };
  }
}
