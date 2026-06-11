// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_mode_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(storageMode)
final storageModeProvider = StorageModeProvider._();

final class StorageModeProvider
    extends
        $FunctionalProvider<
          AsyncValue<StorageMode>,
          StorageMode,
          FutureOr<StorageMode>
        >
    with $FutureModifier<StorageMode>, $FutureProvider<StorageMode> {
  StorageModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storageModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storageModeHash();

  @$internal
  @override
  $FutureProviderElement<StorageMode> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<StorageMode> create(Ref ref) {
    return storageMode(ref);
  }
}

String _$storageModeHash() => r'19a0938685af01e41cb4ea875c345a41810d8d23';
