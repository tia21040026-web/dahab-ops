import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

/// `Idempotency-Key` for mutations that move money or send messages.
///
/// Generate one key per user intent and reuse it when the same intent is
/// retried: the server replays the first response (`Idempotent-Replay: true`).
abstract final class Idempotency {
  static const header = 'Idempotency-Key';
  static const replayHeader = 'idempotent-replay';
  static const _uuid = Uuid();

  static String newKey() => _uuid.v4();

  static Options options({String? key, Options? base}) {
    final b = base ?? Options();
    return b.copyWith(headers: {...?b.headers, header: key ?? newKey()});
  }

  static bool wasReplayed(Response<dynamic> response) =>
      response.headers.value(replayHeader) == 'true';
}
