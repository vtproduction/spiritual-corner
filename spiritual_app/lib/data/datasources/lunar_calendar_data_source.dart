import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/models/lunar_date.dart';

class LunarCalendarDataSource {
  Future<List<LunarDate>> getLunarCalendar2026() async {
    final String response = await rootBundle.loadString('assets/data/licham_2026.json');
    final data = await json.decode(response);
    
    if (data['items'] != null) {
      final items = data['items'] as List;
      return items.map((item) => LunarDate.fromRawJson(item as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<LunarDate?> getLunarDateForSolarDate(DateTime solarDate) async {
    final calendar = await getLunarCalendar2026();
    try {
      return calendar.firstWhere((date) => 
        date.solarDate.year == solarDate.year &&
        date.solarDate.month == solarDate.month &&
        date.solarDate.day == solarDate.day,
      );
    } catch (_) {
      return null;
    }
  }

  Future<LunarDate?> getToday() async {
    final today = DateTime.now();
    // Since the data is only for 2026, we'll try to get today if it is 2026,
    // otherwise fallback to a mock "today" in 2026 for demonstration purposes
    if (today.year == 2026) {
      return getLunarDateForSolarDate(today);
    } else {
      // Fallback for demonstration: Jan 1, 2026
      return getLunarDateForSolarDate(DateTime(2026, 1, 1));
    }
  }
}
