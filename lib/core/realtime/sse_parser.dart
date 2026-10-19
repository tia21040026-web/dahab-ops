import 'dart:async';
import 'dart:convert';

import 'server_event.dart';

/// Parses a `text/event-stream` byte stream into [SseFrame]s per the WHATWG
/// spec: `field: value` lines, blank line dispatches, `:` lines are comments
/// (the server's 25 s heartbeat), multi-line `data` is joined with `\n`.
class SseParser extends StreamTransformerBase<List<int>, SseFrame> {
  const SseParser();

  @override
  Stream<SseFrame> bind(Stream<List<int>> stream) async* {
    String? id;
    String? event;
    int? retry;
    final data = <String>[];

    await for (final line in stream.transform(utf8.decoder).transform(const LineSplitter())) {
      if (line.isEmpty) {
        if (data.isNotEmpty || event != null) {
          yield SseFrame(id: id, event: event, data: data.join('\n'), retry: retry);
        }
        event = null;
        retry = null;
        data.clear();
        continue;
      }
      if (line.startsWith(':')) continue;
      final colon = line.indexOf(':');
      final field = colon == -1 ? line : line.substring(0, colon);
      var value = colon == -1 ? '' : line.substring(colon + 1);
      if (value.startsWith(' ')) value = value.substring(1);
      switch (field) {
        case 'id':
          if (!value.contains('\u0000')) id = value;
        case 'event':
          event = value;
        case 'data':
          data.add(value);
        case 'retry':
          retry = int.tryParse(value);
      }
    }
    if (data.isNotEmpty) {
      yield SseFrame(id: id, event: event, data: data.join('\n'), retry: retry);
    }
  }
}
