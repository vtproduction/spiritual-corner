class LunarTimeHelper {
  static const Map<String, List<int>> _zodiacHours = {
    'Tý': [23, 0], // 23:00 - 00:59
    'Sửu': [1, 2], // 01:00 - 02:59
    'Dần': [3, 4], // 03:00 - 04:59
    'Mão': [5, 6], // 05:00 - 06:59
    'Thìn': [7, 8], // 07:00 - 08:59
    'Tỵ': [9, 10], // 09:00 - 10:59
    'Ngọ': [11, 12], // 11:00 - 12:59
    'Mùi': [13, 14], // 13:00 - 14:59
    'Thân': [15, 16], // 15:00 - 16:59
    'Dậu': [17, 18], // 17:00 - 18:59
    'Tuất': [19, 20], // 19:00 - 20:59
    'Hợi': [21, 22], // 21:00 - 22:59
  };

  /// Returns the current zodiac hour name (e.g. "Tý", "Sửu") based on the current system time.
  static String getCurrentZodiacHourName({DateTime? time}) {
    final now = time ?? DateTime.now();
    final hour = now.hour;

    for (var entry in _zodiacHours.entries) {
      if (entry.value.contains(hour)) {
        return entry.key;
      }
    }
    return 'Tý'; // Default fallback though it shouldn't happen
  }

  /// Returns a display string for the current time slot, e.g., "Mão (5h-7h)"
  static String getCurrentTimeSlotString({DateTime? time}) {
    final name = getCurrentZodiacHourName(time: time);
    switch (name) {
      case 'Tý':   return 'Tý (23h-1h)';
      case 'Sửu':  return 'Sửu (1h-3h)';
      case 'Dần':  return 'Dần (3h-5h)';
      case 'Mão':  return 'Mão (5h-7h)';
      case 'Thìn': return 'Thìn (7h-9h)';
      case 'Tỵ':   return 'Tỵ (9h-11h)';
      case 'Ngọ':  return 'Ngọ (11h-13h)';
      case 'Mùi':  return 'Mùi (13h-15h)';
      case 'Thân': return 'Thân (15h-17h)';
      case 'Dậu':  return 'Dậu (17h-19h)';
      case 'Tuất': return 'Tuất (19h-21h)';
      case 'Hợi':  return 'Hợi (21h-23h)';
      default:     return '';
    }
  }

  /// Formats the raw "Giờ Hoàng Đạo" or "Giờ Hắc Đạo" strings 
  /// From: "Tý (23-1), Sửu (1-3)" or "Dần (3:00-4:59)"
  /// To:   "Tý (23h-1h), Sửu (1h-3h)"
  static String formatZodiacTimeString(String rawString) {
    if (rawString.isEmpty) return rawString;

    // First replace the complex time formats (e.g. 3:00-4:59 -> 3h-5h)
    // Actually, it's safer and cleaner to just map the zodiac names directly if found,
    // but building a clever Regex is also fine.
    var result = rawString;
    
    // Replace colon times with just the hour prefix
    result = result.replaceAllMapped(RegExp(r'(\d{1,2}):\d{2}-(\d{1,2}):\d{2}'), (match) {
      // Dần (3:00-4:59) -> Dần (3h-5h)
      // Note: 4:59 is essentially 5h in the zodiac context.
      int endHour = int.parse(match.group(2)!);
      // Zodiac hours are 2 hour blocks. If it ends in :59, the mathematical block ends at the next hour.
      if (rawString.contains(':59')) {
        endHour += 1;
      }
      return '${match.group(1)}h-${endHour}h';
    });

    // Replace standard dashed numbers with 'h'
    result = result.replaceAllMapped(RegExp(r'\((\d{1,2})-(\d{1,2})\)'), (match) {
      return '(${match.group(1)}h-${match.group(2)}h)';
    });

    // Ensure there is a space before the bracket, but no space inside the name.
    // e.g., "Tý(23h-1h)" -> "Tý (23h-1h)" or "Tý  (23h-1h)" -> "Tý (23h-1h)"
    result = result.replaceAllMapped(RegExp(r'([a-zA-ZÀ-ỹ])\s*\('), (match) {
      return '${match.group(1)} (';
    });

    return result;
  }

  /// Determines if the current time slot is "Hoàng Đạo" (Auspicious)
  /// Checks if the current zodiac hour name is present in the hoangDaoString.
  static bool isCurrentTimeHoangDao(String hoangDaoString, {DateTime? time}) {
    if (hoangDaoString.isEmpty) return true; // Fail safe

    final currentZodiac = getCurrentZodiacHourName(time: time);
    // A simple contains check is usually enough because the rawData contains comma separated zodiac names
    return hoangDaoString.contains(currentZodiac);
  }
}
