import 'package:freezed_annotation/freezed_annotation.dart';

part 'prayer.freezed.dart';
part 'prayer.g.dart';

@freezed
class Prayer with _$Prayer {
  const factory Prayer({
    required String id,
    required String name,
    required String intro,
    required List<String> content,
  }) = _Prayer;

  factory Prayer.fromJson(Map<String, dynamic> json) => _$PrayerFromJson(json);
}

@freezed
class PrayerItem with _$PrayerItem {
  const factory PrayerItem({
    required String id,
    @JsonKey(name: 'categoryId') required String categoryId,
    required String name,
    required List<Prayer> prayers,
    List<String>? detail,
    List<String>? prepare,
  }) = _PrayerItem;

  factory PrayerItem.fromJson(Map<String, dynamic> json) => _$PrayerItemFromJson(json);
}

@freezed
class PrayerCategory with _$PrayerCategory {
  const factory PrayerCategory({
    required String id,
    required String name,
  }) = _PrayerCategory;

  factory PrayerCategory.fromJson(Map<String, dynamic> json) => _$PrayerCategoryFromJson(json);
}

@freezed
class PrayersData with _$PrayersData {
  const factory PrayersData({
    required List<PrayerCategory> categories,
    required List<PrayerItem> items,
  }) = _PrayersData;

  factory PrayersData.fromJson(Map<String, dynamic> json) =>
      _$PrayersDataFromJson(json);
}
