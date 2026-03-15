import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/prayer.dart';
import '../datasources/prayer_data_source.dart';

// Provider for the data source
final prayerDataSourceProvider = Provider<PrayerDataSource>((ref) {
  return PrayerDataSource();
});

// Repository class
class PrayerRepository {
  final PrayerDataSource _dataSource;

  PrayerRepository(this._dataSource);

  Future<List<PrayerCategory>> getCategories() => _dataSource.getCategories();
  Future<List<PrayerItem>> getPrayerItems() => _dataSource.getPrayerItems();
  Future<PrayerItem?> getPrayerItemById(String id) => _dataSource.getPrayerItemById(id);
}

// Provider for the repository
final prayerRepositoryProvider = Provider<PrayerRepository>((ref) {
  final dataSource = ref.watch(prayerDataSourceProvider);
  return PrayerRepository(dataSource);
});

// State providers for specific use-cases
final prayerCategoriesProvider = FutureProvider<List<PrayerCategory>>((ref) async {
  final repository = ref.watch(prayerRepositoryProvider);
  return repository.getCategories();
});

final prayerItemsProvider = FutureProvider<List<PrayerItem>>((ref) async {
  final repository = ref.watch(prayerRepositoryProvider);
  return repository.getPrayerItems();
});

final prayerItemFamily = FutureProvider.family<PrayerItem?, String>((ref, id) async {
  final repository = ref.watch(prayerRepositoryProvider);
  return repository.getPrayerItemById(id);
});
