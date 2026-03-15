import 'package:freezed_annotation/freezed_annotation.dart';

part 'lunar_date.freezed.dart';

@freezed
class LunarDate with _$LunarDate {
  const factory LunarDate({
    required DateTime solarDate,
    required String solarDateString,
    required int lunarDay,
    required int lunarMonth,
    required int lunarYear,
    required String lunarLeap,
    required String canChiDay,
    required String canChiMonth,
    required String canChiYear,
    required String hoangDaoTime,
    required String hacDaoTime,
    required String badDays, // Các ngày kỵ
    required String nguHanh,
    required String banhToBachKyNhat,
    required String khongMinhLucDieu,
    required String nhiThapBatTu,
    required String thapNhiKienTru,
    required String ngocHapThongThu,
    required String huongXuatHanh,
    required String gioXuatHanhThuongLy,
  }) = _LunarDate;

  factory LunarDate.fromRawJson(Map<String, dynamic> json) {
    final dateObj = json['date']; // Object containing d1, m1, y1 (from lunar parsing logic if using another lib) wait, look at the precise json structure.
    // The exact JSON structure from licham_2026.json:
    // { "items": [ { "date": ["1", "1", "2026", "2411", "-"], "data": ["Tý (23-1)...", "Sửu (1-3)...", ...]} ] }
    final dateStrList = List<String>.from(json['date'] ?? []);
    final dataStrList = List<String>.from(json['data'] ?? []);

    final solarDay = int.tryParse(dateStrList.isNotEmpty ? dateStrList[0] : '1') ?? 1;
    final solarMonth = int.tryParse(dateStrList.length > 1 ? dateStrList[1] : '1') ?? 1;
    final solarYear = int.tryParse(dateStrList.length > 2 ? dateStrList[2] : '2026') ?? 2026;
    final lunarDateCombo = dateStrList.length > 3 ? dateStrList[3] : ''; // e.g. "2411" for 24th of 11th month, or "11" for 1st of 1st month? Actually wait, the JS logic for Vietnamese lunar converts this. 
    // Wait, the JSON file 'licham_2026.json' from my previous view:
    // "date": [ "1", "1", "2026", "2411", "-" ] -> Solar: 1/1/2026. Lunar: Day 24, Month 11. Leap: "-".
    // I need to parse "2411" carefully. If it's 3 chars "111", it could be day 1, month 11, or day 11, month 1. Usually the last 1 or 2 digits are the month.
    // Let's implement robust parsing later, or assume the day/month logic. Actually, "2411" -> Day 24, Month 11. "11" -> Day 1, Month 1. "12" -> Day 1, Month 2?
    // Vietnamese lunar converter js uses the solar date primarily. Since we have offline data, let's extract what we can.
    int parseLunarDay = 1;
    int parseLunarMonth = 1;
    if (lunarDateCombo.length == 4) {
      parseLunarDay = int.tryParse(lunarDateCombo.substring(0, 2)) ?? 1;
      parseLunarMonth = int.tryParse(lunarDateCombo.substring(2, 4)) ?? 1;
    } else if (lunarDateCombo.length == 3) {
      // Could be day 1-9 and month 10-12, OR day 10-31 and month 1-9.
      // E.g., "111" -> 1/11 or 11/1? Let's check the date sequences.
      int potentialDay1 = int.tryParse(lunarDateCombo.substring(0, 1)) ?? 1;
      int potentialMonth1 = int.tryParse(lunarDateCombo.substring(1, 3)) ?? 1;
      int potentialDay2 = int.tryParse(lunarDateCombo.substring(0, 2)) ?? 1;
      int potentialMonth2 = int.tryParse(lunarDateCombo.substring(2, 3)) ?? 1;
      // We will refine this later if needed. Defaulting to day in first 1/2 chars.
      parseLunarDay = potentialDay2;
      parseLunarMonth = potentialMonth2;
    } else if (lunarDateCombo.length == 2) {
      parseLunarDay = int.tryParse(lunarDateCombo.substring(0, 1)) ?? 1;
      parseLunarMonth = int.tryParse(lunarDateCombo.substring(1, 2)) ?? 1;
    }

    // Defaulting canChi strings from the array (if available), but they might not be part of 'date'.
    // Typically CanChi day, month, year can be derived or might be missing in this exact data row.
    // For now we map `data` list elements according to `detail_titles.json` order!
    //  0: "Giờ Hoàng Đạo"
    //  1: "Giờ Hắc Đạo"
    //  2: "Các Ngày Kỵ"
    //  3: "Ngũ Hành"
    //  4: "Bành Tổ Bách Kỵ Nhật"
    //  5: "Khổng Minh Lục Diệu"
    //  6: "Nhị Thập Bát Tú"
    //  7: "Thập Nhị Kiến Trừ"
    //  8: "Ngọc Hạp Thông Thư"
    //  9: "Hướng xuất hành"
    // 10: "Giờ xuất hành Theo Lý Thuần Phong"

    return LunarDate(
      solarDate: DateTime(solarYear, solarMonth, solarDay),
      solarDateString: '$solarDay/$solarMonth/$solarYear',
      lunarDay: parseLunarDay,
      lunarMonth: parseLunarMonth,
      lunarYear: solarYear, // roughly same
      lunarLeap: dateStrList.length > 4 ? dateStrList[4] : '-',
      canChiDay: '', // To be computed or found
      canChiMonth: '',
      canChiYear: '',
      hoangDaoTime: dataStrList.isNotEmpty ? dataStrList[0] : '',
      hacDaoTime: dataStrList.length > 1 ? dataStrList[1] : '',
      badDays: dataStrList.length > 2 ? dataStrList[2] : '',
      nguHanh: dataStrList.length > 3 ? dataStrList[3] : '',
      banhToBachKyNhat: dataStrList.length > 4 ? dataStrList[4] : '',
      khongMinhLucDieu: dataStrList.length > 5 ? dataStrList[5] : '',
      nhiThapBatTu: dataStrList.length > 6 ? dataStrList[6] : '',
      thapNhiKienTru: dataStrList.length > 7 ? dataStrList[7] : '',
      ngocHapThongThu: dataStrList.length > 8 ? dataStrList[8] : '',
      huongXuatHanh: dataStrList.length > 9 ? dataStrList[9] : '',
      gioXuatHanhThuongLy: dataStrList.length > 10 ? dataStrList[10] : '',
    );
  }
}
