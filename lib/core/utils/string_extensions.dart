import 'dart:math';

/// String extension utilities
extension StringExtensions on String {
  /// Capitalize first letter of string
  String get capitalizeFirstInfo {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Capitalize first letter of each word
  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalizeFirstInfo).join(' ');
  }

  /// Convert to title case
  String get toTitleCase {
    if (isEmpty) return this;
    return split(' ')
        .map((word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
        .join(' ');
  }

  /// Check if string is a valid email
  bool get isValidEmail {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(this);
  }

  /// Check if string is a valid phone number
  bool get isValidPhone {
    return RegExp(r'^\+?[1-9]\d{1,14}$')
        .hasMatch(replaceAll(RegExp(r'\s'), ''));
  }

  /// Check if string contains only letters
  bool get isAlpha {
    return RegExp(r'^[a-zA-Z]+$').hasMatch(this);
  }

  /// Check if string contains only numbers
  bool get isNumeric {
    return RegExp(r'^[0-9]+$').hasMatch(this);
  }

  /// Check if string is alphanumeric
  bool get isAlphanumeric {
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);
  }

  /// Remove all whitespace
  String get removeWhitespace {
    return replaceAll(RegExp(r'\s+'), '');
  }

  /// Reverse the string
  String get reverse {
    return split('').reversed.join('');
  }

  /// Truncate string to length with ellipsis
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }

  /// Check if string is empty or null
  bool get isNullOrEmpty {
    return trim().isEmpty;
  }

  /// Safe substring
  String safeSubstring(int start, [int? end]) {
    if (start < 0 || start >= length) return '';
    final safeEnd = end == null ? length : (end > length ? length : end);
    return substring(start, safeEnd);
  }

  /// Remove special characters
  String get removeSpecialChars {
    return replaceAll(RegExp(r'[^\w\s]'), '');
  }

  /// Convert to snake_case
  String get toSnakeCase {
    return replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    ).replaceFirst(RegExp(r'^_'), '');
  }

  /// Convert to camelCase
  String get toCamelCase {
    if (isEmpty) return this;
    final words = split(RegExp(r'[\s_-]+'));
    if (words.isEmpty) return this;

    return words.first.toLowerCase() +
        words.skip(1).map((w) => w.capitalizeFirstInfo).join('');
  }

  /// Convert to Pascal Case
  String get toPascalCase {
    if (isEmpty) return this;
    return split(RegExp(r'[\s_-]+'))
        .map((word) => word.capitalizeFirstInfo)
        .join('');
  }

  /// Extract numbers from string
  String get extractNumbers {
    return replaceAll(RegExp(r'[^\d]'), '');
  }

  /// Extract letters from string
  String get extractLetters {
    return replaceAll(RegExp(r'[^a-zA-Z]'), '');
  }

  /// Count occurrences of substring
  int countOccurrences(String substring) {
    if (substring.isEmpty) return 0;
    int count = 0;
    int index = 0;
    while ((index = indexOf(substring, index)) != -1) {
      count++;
      index += substring.length;
    }
    return count;
  }

  /// Mask string (for sensitive data)
  String mask(
      {int visibleStart = 0, int visibleEnd = 0, String maskChar = '*'}) {
    if (length <= visibleStart + visibleEnd) return this;

    final start = substring(0, visibleStart);
    final middle = maskChar * (length - visibleStart - visibleEnd);
    final end = substring(length - visibleEnd);

    return '$start$middle$end';
  }

  /// Format as currency
  String toCurrency({String symbol = '\$', int decimals = 2}) {
    final number = double.tryParse(this);
    if (number == null) return this;
    return '$symbol${number.toStringAsFixed(decimals)}';
  }

  /// Wrap text at specified length
  String wrapText(int maxLineLength) {
    if (length <= maxLineLength) return this;

    final words = split(' ');
    final lines = <String>[];
    String currentLine = '';

    for (final word in words) {
      if ((currentLine + word).length <= maxLineLength) {
        currentLine += (currentLine.isEmpty ? '' : ' ') + word;
      } else {
        if (currentLine.isNotEmpty) lines.add(currentLine);
        currentLine = word;
      }
    }

    if (currentLine.isNotEmpty) lines.add(currentLine);
    return lines.join('\n');
  }
}

/// Nullable String extensions
extension NullableStringExtensions on String? {
  /// Safe capitalize first
  String get safecapitalizeFirstInfo {
    if (this == null || this!.isEmpty) return '';
    return this!.capitalizeFirstInfo;
  }

  /// Check if null or empty
  bool get isNullOrEmpty {
    return this == null || this!.trim().isEmpty;
  }

  /// Get value or default
  String orDefault(String defaultValue) {
    return this ?? defaultValue;
  }

  /// Get value or empty string
  String get orEmpty {
    return this ?? '';
  }
}

/// Number formatting extensions
extension DoubleExtensions on double {
  /// Format as currency
  String toCurrency({String symbol = '\$', int decimals = 2}) {
    return '$symbol${toStringAsFixed(decimals)}';
  }

  /// Format with commas
  String toFormattedString({int decimals = 2}) {
    final formatted = toStringAsFixed(decimals);
    final parts = formatted.split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
    return decimals > 0 ? '$intPart.${parts[1]}' : intPart;
  }

  /// Convert to percentage string
  String toPercentage({int decimals = 1}) {
    return '${(this * 100).toStringAsFixed(decimals)}%';
  }

  /// Round to nearest
  double roundTo(int decimals) {
    final factor = pow(10, decimals);
    return (this * factor).round() / factor;
  }
}

extension IntExtensions on int {
  /// Format with commas
  String get withCommas {
    return toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
  }

  /// Ordinal suffix (1st, 2nd, 3rd, etc.)
  String get ordinal {
    if (this >= 11 && this <= 13) return '${this}th';
    switch (this % 10) {
      case 1:
        return '${this}st';
      case 2:
        return '${this}nd';
      case 3:
        return '${this}rd';
      default:
        return '${this}th';
    }
  }

  /// Pluralize word based on count
  String pluralize(String singular, {String? plural}) {
    if (this == 1) return singular;
    return plural ?? '${singular}s';
  }
}

/// List extensions
extension ListExtensions<T> on List<T> {
  /// Get first or null
  T? get firstOrNull {
    return isEmpty ? null : first;
  }

  /// Get last or null
  T? get lastOrNull {
    return isEmpty ? null : last;
  }

  /// Safe get at index
  T? getAt(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }

  /// Chunk list into smaller lists
  List<List<T>> chunk(int size) {
    final chunks = <List<T>>[];
    for (int i = 0; i < length; i += size) {
      chunks.add(sublist(i, i + size > length ? length : i + size));
    }
    return chunks;
  }
}

/// DateTime extensions
extension DateTimeExtensions on DateTime {
  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Check if date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Check if date is in the past
  bool get isPast {
    return isBefore(DateTime.now());
  }

  /// Check if date is in the future
  bool get isFuture {
    return isAfter(DateTime.now());
  }

  /// Get start of day
  DateTime get startOfDay {
    return DateTime(year, month, day);
  }

  /// Get end of day
  DateTime get endOfDay {
    return DateTime(year, month, day, 23, 59, 59, 999);
  }

  /// Add days
  DateTime addDays(int days) {
    return add(Duration(days: days));
  }

  /// Subtract days
  DateTime subtractDays(int days) {
    return subtract(Duration(days: days));
  }

  /// Get age in years
  int get ageInYears {
    final now = DateTime.now();
    int age = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }
    return age;
  }
}
