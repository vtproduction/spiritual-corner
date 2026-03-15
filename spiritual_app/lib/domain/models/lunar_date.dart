import 'package:freezed_annotation/freezed_annotation.dart';

part 'lunar_date.freezed.dart';

@freezed
abstract class LunarDate with _$LunarDate {
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

  const LunarDate._();

  factory LunarDate.fromRawJson(Map<String, dynamic> json) {
    final dateStrList = List<String>.from(json['date'] ?? []);
    final dataStrList = List<String>.from(json['data'] ?? []);

    // date[0]: "1-1-2026"
    int solarDay = 1, solarMonth = 1, solarYear = 2026;
    if (dateStrList.isNotEmpty) {
      final sParts = dateStrList[0].split('-');
      if (sParts.length == 3) {
        solarDay = int.tryParse(sParts[0]) ?? 1;
        solarMonth = int.tryParse(sParts[1]) ?? 1;
        solarYear = int.tryParse(sParts[2]) ?? 2026;
      }
    }

    // date[1]: "13-11-2025" or "13-11-2025 (Nhuận)"
    int parseLunarDay = 1, parseLunarMonth = 1, parseLunarYear = 2026;
    String isLeap = '-';
    if (dateStrList.length > 1) {
      String lDateStr = dateStrList[1];
      if (lDateStr.contains('Nhuận') || lDateStr.contains('nhuận')) {
        isLeap = '1';
        lDateStr = lDateStr.replaceAll(RegExp(r'\(.*?\)'), '').trim();
      }
      final lParts = lDateStr.split('-');
      if (lParts.length >= 3) {
        parseLunarDay = int.tryParse(lParts[0]) ?? 1;
        parseLunarMonth = int.tryParse(lParts[1]) ?? 1;
        parseLunarYear = int.tryParse(lParts[2]) ?? 2026;
      }
    }

    // date[3]: "Ngày Ất Hợi tháng Mậu Tý năm Ất Tỵ"
    String canChiDay = '', canChiMonth = '', canChiYear = '';
    if (dateStrList.length > 3) {
      final rawCanChi = dateStrList[3];
      // simplified split
      final daySplit = rawCanChi.split('tháng');
      if (daySplit.length == 2) {
        canChiDay = daySplit[0].replaceAll('Ngày', '').trim();
        final monthSplit = daySplit[1].split('năm');
        if (monthSplit.length == 2) {
          canChiMonth = monthSplit[0].trim();
          canChiYear = monthSplit[1].trim();
        }
      } else {
        canChiDay = rawCanChi;
      }
    }

    return LunarDate(
      solarDate: DateTime(solarYear, solarMonth, solarDay),
      solarDateString: '$solarDay/$solarMonth/$solarYear',
      lunarDay: parseLunarDay,
      lunarMonth: parseLunarMonth,
      lunarYear: parseLunarYear,
      lunarLeap: isLeap,
      canChiDay: canChiDay,
      canChiMonth: canChiMonth,
      canChiYear: canChiYear,
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
