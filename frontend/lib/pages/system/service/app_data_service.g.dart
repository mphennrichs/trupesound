// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_data_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appDataService)
final appDataServiceProvider = AppDataServiceProvider._();

final class AppDataServiceProvider
    extends $FunctionalProvider<AppDataService, AppDataService, AppDataService>
    with $Provider<AppDataService> {
  AppDataServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDataServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDataServiceHash();

  @$internal
  @override
  $ProviderElement<AppDataService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDataService create(Ref ref) {
    return appDataService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDataService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDataService>(value),
    );
  }
}

String _$appDataServiceHash() => r'94aac09ee588f35d049e4636873234509b75e133';
