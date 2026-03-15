import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/models/prayer.dart';

class PrayerDataSource {
  Future<PrayersData> getPrayersData() async {
    final String response = await rootBundle.loadString('assets/data/prayers.json');
    final data = await json.decode(response);
    return PrayersData.fromJson(data);
  }

  Future<List<PrayerCategory>> getCategories() async {
    final data = await getPrayersData();
    return data.categories;
  }

  Future<List<PrayerItem>> getPrayerItems() async {
    final data = await getPrayersData();
    return data.items;
  }

  Future<PrayerItem?> getPrayerItemById(String id) async {
    final data = await getPrayersData();
    try {
      return data.items.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }
}
