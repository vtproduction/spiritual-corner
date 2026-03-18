import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/lunar_date.dart';
import '../datasources/lunar_calendar_data_source.dart';

// Provider for the data source
final lunarCalendarDataSourceProvider = Provider<LunarCalendarDataSource>((ref) {
  return LunarCalendarDataSource();
});

// Repository class
class LunarCalendarRepository {
  final LunarCalendarDataSource _dataSource;

  LunarCalendarRepository(this._dataSource);

  Future<List<LunarDate>> getLunarCalendar2026() => _dataSource.getLunarCalendar2026();
  Future<LunarDate?> getLunarDateForSolarDate(DateTime date) => _dataSource.getLunarDateForSolarDate(date);
  Future<LunarDate?> getToday() => _dataSource.getToday();
}

// Provider for the repository
final lunarCalendarRepositoryProvider = Provider<LunarCalendarRepository>((ref) {
  final dataSource = ref.watch(lunarCalendarDataSourceProvider);
  return LunarCalendarRepository(dataSource);
});

// State providers
final currentDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

final lunarCalendarProvider = FutureProvider<List<LunarDate>>((ref) async {
  final repository = ref.watch(lunarCalendarRepositoryProvider);
  return repository.getLunarCalendar2026();
});

final lunarDateForDayProvider = FutureProvider.family<LunarDate?, DateTime>((ref, date) async {
  final repository = ref.watch(lunarCalendarRepositoryProvider);
  return repository.getLunarDateForSolarDate(date);
});

final todayLunarDateProvider = FutureProvider<LunarDate?>((ref) async {
  final repository = ref.watch(lunarCalendarRepositoryProvider);
  final currentDate = ref.watch(currentDateProvider);
  return repository.getLunarDateForSolarDate(currentDate);
});
