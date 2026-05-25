import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trupe_sound/models/asset_model.dart';

part 'asset_provider.g.dart';

@riverpod
class AssetRepository extends _$AssetRepository {
  @override
  FutureOr<List<AssetModel>> build() async {
    // This acts as your "Source of Truth"
    // Simulating a fetch from a database or API
    await Future.delayed(const Duration(seconds: 1));
    return [
      AssetModel(
        id: '1',
        name: 'Ambient Forest',
        category: 'Nature',
        duration: const Duration(minutes: 2),
        url: '',
        createdAt: DateTime.now(),
      ),
      AssetModel(
        id: '2',
        name: 'Crowd Cheering',
        category: 'Human',
        duration: const Duration(seconds: 45),
        url: '',
        createdAt: DateTime.now(),
      ),
      AssetModel(
        id: '3',
        name: 'Industrial Hum',
        category: 'Machine',
        duration: const Duration(minutes: 5, seconds: 12),
        url: '',
        createdAt: DateTime.now(),
      ),
    ];
  }

  Future<void> deleteAsset(String id) async {
    if (!state.hasValue) return;
    state = AsyncData(state.value!.where((a) => a.id != id).toList());
  }
}

@riverpod
AsyncValue<List<AssetModel>> filteredAssets(Ref ref) {
  final assetsAsync = ref.watch(assetRepositoryProvider);
  // Bridge Layer: Apply search logic or assetStatusFilter here
  return assetsAsync;
}
