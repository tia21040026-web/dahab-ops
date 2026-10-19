import 'dart:convert' show base64Encode;
import 'dart:typed_data';

import 'package:injectable/injectable.dart';

import '../../core/api/api_client.dart';
import '../../core/api/models/json_record.dart';
import '../../core/api/models/paged.dart';

class CmsPage extends JsonRecord {
  const CmsPage(super.json);

  String title(bool arabic) => arabic ? first(const ['title_ar', 'title_en', 'slug'], id) : first(const ['title_en', 'slug'], id);
  String get slug => s('slug');
  String get type => s('type');
  String get status => s('status', 'draft');
  int get version => i('version', 1);
  DateTime? get updatedAt => d('updated_at');
}

class CmsRevision extends JsonRecord {
  const CmsRevision(super.json);

  int get version => i('version', i('revision'));
  String get actor => first(const ['actor', 'created_by', 'user', 'author']);
  String get action => first(const ['action', 'change_type', 'summary'], 'update');
  DateTime? get at => d('created_at') ?? d('timestamp');
  Object? get snapshot => json['snapshot'] ?? json['data'] ?? json['after'];
}

class MediaAsset extends JsonRecord {
  const MediaAsset(super.json);

  String get url => first(const ['original_url', 'url']);
  String get filename => s('filename');
  int get bytes => i('file_size');
}

/// The editable page fields the web editor sends on `PATCH /pages/:id`.
const cmsPageFields = [
  'title_en',
  'title_ar',
  'subtitle_en',
  'subtitle_ar',
  'description_en',
  'description_ar',
  'body_en',
  'body_ar',
  'hero_image_url',
];

const cmsSeoFields = [
  'title_en',
  'title_ar',
  'description_en',
  'description_ar',
  'canonical_url',
];

/// `/api/admin/content` CMS (pages, SEO, publish, media, revisions).
@lazySingleton
class CmsRepository {
  CmsRepository(this._api);

  final ApiClient _api;
  static const _base = '/api/admin/content';

  Future<Paged<CmsPage>> pages(ListQuery q) async => pagedFrom(
      await _api.get('$_base/pages', query: {if (q.filters['status'] != null) 'status': q.filters['status']}),
      const ['pages'],
      CmsPage.new);

  /// `{ page, blocks, seo }`.
  Future<(Map<String, dynamic>, Map<String, dynamic>)> page(String id) async {
    final json = await _api.get('$_base/pages/$id');
    Map<String, dynamic> m(Object? v) => v is Map ? v.cast<String, dynamic>() : <String, dynamic>{};
    return (m(json['page']), m(json['seo']));
  }

  Future<Map<String, dynamic>> updatePage(String id, Map<String, dynamic> fields) async {
    final json = await _api.patch('$_base/pages/$id', body: fields);
    return (json['page'] as Map?)?.cast<String, dynamic>() ?? json;
  }

  Future<void> updateSeo(String pageId, Map<String, dynamic> fields) =>
      _api.patch('$_base/seo/page/$pageId', body: fields);

  Future<Map<String, dynamic>> publish(String id) async {
    final json = await _api.post('$_base/pages/$id/publish');
    return (json['page'] as Map?)?.cast<String, dynamic>() ?? json;
  }

  Future<List<CmsRevision>> revisions(String pageId) async {
    final json = await _api.get('$_base/revisions', query: {'entityType': 'page', 'entityId': pageId, 'limit': 50});
    return [for (final m in listOfMaps(json['revisions'])) CmsRevision(m)];
  }

  /// The server takes a base64 data URL (not multipart), as the web
  /// MediaLibrary sends it.
  Future<MediaAsset> uploadImage({
    required Uint8List bytes,
    required String filename,
    required String mimeType,
    String altEn = '',
    String altAr = '',
    String category = 'pages',
  }) async {
    final json = await _api.post('$_base/media/upload', body: {
      'dataUrl': 'data:$mimeType;base64,${base64Encode(bytes)}',
      'filename': filename,
      'alt_en': altEn,
      'alt_ar': altAr,
      'category': category,
    });
    return MediaAsset((json['asset'] as Map?)?.cast<String, dynamic>() ?? json);
  }
}
