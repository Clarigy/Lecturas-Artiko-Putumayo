import 'package:flutter_riverpod/flutter_riverpod.dart';

final closedTerminalStatusProvider =
    StateNotifierProvider.autoDispose<ClosedTerminalStatus, bool>(
        (ref) => ClosedTerminalStatus());

class ClosedTerminalStatus extends StateNotifier<bool> {
  ClosedTerminalStatus() : super(false);

  void changeIsClosed(bool value) => state = value;
}
