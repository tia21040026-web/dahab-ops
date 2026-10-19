import 'package:injectable/injectable.dart';

import '../../../core/api/api_client.dart';

/// `GET /api/search` result. `route` is a web path the app maps to its own
/// routes (`/ops/bookings/:ref` → booking, `/admin/users/:id` → access,
/// `/ops/suppliers/:id` → supplier inbox).
class SearchHit {
  const SearchHit({
    required this.type,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.route,
  });

  final String type;
  final String id;
  final String title;
  final String subtitle;
  final String route;

  factory SearchHit.fromJson(Map<String, dynamic> json) => SearchHit(
        type: '${json['type'] ?? ''}',
        id: '${json['id'] ?? ''}',
        title: '${json['title'] ?? ''}',
        subtitle: '${json['subtitle'] ?? ''}',
        route: '${json['route'] ?? ''}',
      );
}

@lazySingleton
class SearchRepository {
  SearchRepository(this._api);

  final ApiClient _api;

  Future<List<SearchHit>> search(String q) async {
    final query = q.trim();
    if (query.isEmpty) return const [];
    final json = await _api.get('/api/search', query: {'q': query});
    return (((json['items'] as List?) ?? const []).whereType<Map>())
        .map((e) => SearchHit.fromJson(e.cast<String, dynamic>()))
        .toList();
  }
}
