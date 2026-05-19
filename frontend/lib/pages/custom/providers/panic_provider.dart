import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'panic_provider.g.dart';

@riverpod
class PanicAction extends _$PanicAction {
  @override
  void build() {}

  void execute() {
    // TODO: stop all sounds
    // ignore: avoid_print
    print("PANIC BUTTON PRESSED");
  }
}
