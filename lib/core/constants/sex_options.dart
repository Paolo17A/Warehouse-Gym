class SexOptions {
  SexOptions._();

  static const options = ['MALE', 'FEMALE', 'OTHER'];
  static const defaultValue = 'MALE';

  static String normalize(String raw) {
    final upper = raw.trim().toUpperCase();
    if (upper.isEmpty) return defaultValue;
    if (options.contains(upper)) return upper;
    return defaultValue;
  }
}
