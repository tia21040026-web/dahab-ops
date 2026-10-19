import 'dart:convert';

import 'package:dahab_ops/core/realtime/server_event.dart';
import 'package:dahab_ops/core/realtime/sse_parser.dart';
import 'package:flutter_test/flutter_test.dart';

Future<List<SseFrame>> parse(List<String> chunks) =>
    Stream<List<int>>.fromIterable(chunks.map(utf8.encode)).transform(const SseParser()).toList();

void main() {
  test('parses id, event, data and dispatches on blank line', () async {
    final frames = await parse([
      'id: 7\nevent: ops\ndata: {"type":"booking.created","entityId":"B1"}\n\n',
    ]);
    expect(frames, hasLength(1));
    expect(frames.single.id, '7');
    expect(frames.single.event, 'ops');
    final e = ServerEvent.fromFrame(frames.single);
    expect(e.topic, 'ops');
    expect(e.type, 'booking.created');
    expect(e.entityId, 'B1');
  });

  test('ignores heartbeat comments', () async {
    final frames = await parse([': heartbeat\n\n', ': ping\n', 'data: x\n\n']);
    expect(frames, hasLength(1));
    expect(frames.single.data, 'x');
  });

  test('joins multi-line data with newline', () async {
    final frames = await parse(['data: line one\ndata: line two\n\n']);
    expect(frames.single.data, 'line one\nline two');
  });

  test('handles frames split across chunks', () async {
    final frames = await parse(['event: supp', 'ort\nda', 'ta: {"type":"msg"}\n', '\n']);
    expect(frames.single.event, 'support');
    expect(ServerEvent.fromFrame(frames.single).type, 'msg');
  });

  test('retry is parsed, id persists across frames, value space stripped once', () async {
    final frames = await parse(['id: 1\nretry: 3000\ndata:  two spaces\n\n', 'data: b\n\n']);
    expect(frames[0].retry, 3000);
    expect(frames[0].data, ' two spaces');
    expect(frames[1].id, '1');
    expect(frames[1].retry, isNull);
  });

  test('flushes trailing data without final blank line', () async {
    final frames = await parse(['data: tail']);
    expect(frames.single.data, 'tail');
  });

  test('non-JSON data becomes the summary', () {
    final e = ServerEvent.fromFrame(const SseFrame(event: 'ops', data: 'plain text'));
    expect(e.summary, 'plain text');
    expect(e.type, 'event');
  });
}
