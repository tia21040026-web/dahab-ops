import 'dart:convert';

/// One Server-Sent Events frame as it came off the wire.
class SseFrame {
  const SseFrame({this.id, this.event, this.data = '', this.retry});

  final String? id;
  final String? event;
  final String data;
  final int? retry;
}

/// `event: <topic>` + `data: { type, entityType, entityId, summary, at }`.
class ServerEvent {
  const ServerEvent({
    required this.topic,
    required this.type,
    this.id,
    this.entityType,
    this.entityId,
    this.summary,
    this.at,
    this.synthetic = false,
  });

  /// Topic tick emitted by [PollingFallback] when SSE is unavailable.
  factory ServerEvent.pollTick() =>
      ServerEvent(topic: 'poll', type: 'tick', at: DateTime.now(), synthetic: true);

  factory ServerEvent.fromFrame(SseFrame frame) {
    Map<String, dynamic> data = const {};
    try {
      final decoded = frame.data.isEmpty ? null : jsonDecode(frame.data);
      if (decoded is Map) data = decoded.cast<String, dynamic>();
    } on FormatException {
      data = {'summary': frame.data};
    }
    return ServerEvent(
      id: frame.id,
      topic: frame.event ?? 'message',
      type: '${data['type'] ?? 'event'}',
      entityType: data['entityType'] as String?,
      entityId: data['entityId']?.toString(),
      summary: data['summary'] as String?,
      at: DateTime.tryParse('${data['at']}'),
    );
  }

  final String? id;
  final String topic;
  final String type;
  final String? entityType;
  final String? entityId;
  final String? summary;
  final DateTime? at;

  /// True for locally generated refresh ticks.
  final bool synthetic;

  @override
  String toString() => 'ServerEvent($topic/$type $entityType:$entityId)';
}
