import 'package:freezed_annotation/freezed_annotation.dart';

part 'prayer.freezed.dart';
part 'prayer.g.dart';

@freezed
abstract class Prayer with _$Prayer {
  const factory Prayer({
    required String id,
    required String name,
    required String intro,
    required String content,
  }) = _Prayer;

  const Prayer._();

  factory Prayer.fromJson(Map<String, dynamic> json) => _$PrayerFromJson(json);
}

@freezed
abstract class PrayerItem with _$PrayerItem {
  const factory PrayerItem({
    required String id,
    @JsonKey(name: 'categoryId') required String categoryId,
    required String name,
    required List<Prayer> prayers,
    String? detail,
    String? prepare,
  }) = _PrayerItem;

  const PrayerItem._();

  factory PrayerItem.fromJson(Map<String, dynamic> json) => _$PrayerItemFromJson(json);
}

@freezed
abstract class PrayerCategory with _$PrayerCategory {
  const factory PrayerCategory({
    required String id,
    required String name,
  }) = _PrayerCategory;

  const PrayerCategory._();

  factory PrayerCategory.fromJson(Map<String, dynamic> json) => _$PrayerCategoryFromJson(json);
}

@freezed
abstract class PrayersData with _$PrayersData {
  const factory PrayersData({
    required List<PrayerCategory> categories,
    required List<PrayerItem> items,
  }) = _PrayersData;

  const PrayersData._();

  factory PrayersData.fromJson(Map<String, dynamic> json) =>
      _$PrayersDataFromJson(json);
}
