import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'volume_provider.g.dart';

@riverpod
class Volume extends _$Volume {
  @override
  double build() {
    return 0.5; // Default volume at 50%
  }

  void updateVolume(double value) {
    state = value;
  }
}
