import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// A canned reply for [FakeAdapter].
class FakeReply {
  const FakeReply(this.status, [this.body, this.headers = const {}]);

  final int status;
  final Object? body;
  final Map<String, List<String>> headers;
}

typedef FakeHandler = Future<FakeReply> Function(RequestOptions options);

/// In-memory [HttpClientAdapter]: every request goes to [handler], and every
/// request is recorded in [requests].
class FakeAdapter implements HttpClientAdapter {
  FakeAdapter(this.handler);

  final FakeHandler handler;
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final reply = await handler(options);
    final body = reply.body == null ? '' : jsonEncode(reply.body);
    return ResponseBody.fromString(
      body,
      reply.status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
        ...reply.headers,
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Dio fakeDio(FakeAdapter adapter) =>
    Dio(BaseOptions(baseUrl: 'https://api.test', contentType: Headers.jsonContentType))
      ..httpClientAdapter = adapter;
