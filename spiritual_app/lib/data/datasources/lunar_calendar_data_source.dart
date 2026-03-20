import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/models/lunar_date.dart';

class LunarCalendarDataSource {
  List<LunarDate>? _cachedData;

  Future<List<LunarDate>> getAllLunarData() async {
    if (_cachedData != null) return _cachedData!;
    
    final years = [2025, 2026, 2027, 2028];
    final allData = <LunarDate>[];

    for (final year in years) {
      try {
        final String response = await rootBundle.loadString('assets/data/licham_$year.json');
        final data = await json.decode(response);
        if (data['items'] != null) {
          final items = data['items'] as List;
          allData.addAll(items.map((item) => LunarDate.fromRawJson(item as Map<String, dynamic>)));
        }
      } catch (e) {
        // Fallback gracefully if a file doesn't exist
      }
    }
    
    _cachedData = allData;
    return _cachedData!;
  }

  Future<LunarDate?> getLunarDateForSolarDate(DateTime solarDate) async {
    final calendar = await getAllLunarData();
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
    return getLunarDateForSolarDate(today);
  }
}
