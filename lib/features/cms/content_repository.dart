import 'package:injectable/injectable.dart';

import '../../core/api/api_client.dart';
import '../../core/api/models/json_record.dart';

/// Loading status shared by the content editors (homepage, navigation,
/// programmes list).
enum ContentLoading { loading, ready, failure }

/// One homepage section (cms_homepage_sections). `visible` is 0/1 on the
/// wire; `config` arrives parsed from the server.
class HomepageSection extends JsonRecord {
  const HomepageSection(super.json);

  String get sectionKey => s('section_key');
  String get titleEn => s('title_en');
  String get titleAr => s('title_ar');
  bool get visible => b('visible', true);
  int get sortOrder => i('sort_order');
  Json get config => m('config');
  DateTime? get updatedAt => d('updated_at');

  HomepageSection withJson(Json next) => HomepageSection(next);
}

/// One navigation menu item (cms_navigation).
class NavItem extends JsonRecord {
  const NavItem(super.json);

  String get menuKey => s('menu_key');
  int get itemOrder => i('item_order');
  String get labelEn => s('label_en');
  String get labelAr => s('label_ar');
  String get route => s('route');
  String get externalUrl => s('external_url');
  bool get visible => b('visible', true);
  String get icon => s('icon');
  DateTime? get updatedAt => d('updated_at');
}

/// One ready-made trip programme (content_programmes). The camelCase public
/// contract the web and REHLA speak is what the editor edits.
class Programme extends JsonRecord {
  const Programme(super.json);

  String get destination => s('destination', 'dahab');
  String get titleEn => s('title_en');
  String get titleAr => s('title_ar');
  String get taglineEn => s('tagline_en');
  String get taglineAr => s('tagline_ar');
  int get durationDays => i('duration_days', 1);
  String get idealForEn => s('ideal_for_en');
  String get idealForAr => s('ideal_for_ar');
  String get pace => s('pace', 'Balanced');
  String get paceAr => s('pace_ar');
  int get intensityScore => i('intensity_score', 3);
  int get freeTimeScore => i('free_time_score', 40);
  num get startingPriceEgp => n('starting_price_egp') ?? 0;
  bool get priceIsEstimate => b('price_is_estimate', true);
  String get heroImage => s('hero_image');
  String get badgeEn => s('badge_en');
  String get badgeAr => s('badge_ar');
  List<String> get highlightsEn => strings('highlights_en');
  List<String> get highlightsAr => strings('highlights_ar');
  List<String> get includedEn => strings('included_en');
  List<String> get includedAr => strings('included_ar');
  List<String> get customizableEn => strings('customizable_en');
  List<String> get customizableAr => strings('customizable_ar');
  List<String> get defaultInterests => strings('default_interests');
  String get defaultBudget => s('default_budget', 'Moderate');
  List<Json> get dayByDay => l('day_by_day');
  String get status => s('status', 'draft');
  int get sortOrder => i('sort_order');
  DateTime? get updatedAt => d('updated_at');

  /// A JSON string-array column (highlights_en, day_by_day items are maps).
  List<String> strings(String key) {
    final v = json[key];
    if (v is List) return v.map((e) => e?.toString() ?? '').where((e) => e.isNotEmpty).toList();
    return const [];
  }
}

/// Everything the dashboard controls that is *content* rather than
/// commerce: homepage composition, navigation menus and the ready-made
/// trip programmes both apps render.
@lazySingleton
class ContentRepository {
  ContentRepository(this._api);

  final ApiClient _api;
  static const _base = '/api/admin/content';

  // ── Homepage sections ────────────────────────────────────────────────────

  Future<List<HomepageSection>> homepage() async {
    final json = await _api.get('$_base/homepage');
    return [for (final m in listOfMaps(json['sections'] ?? json['items'])) HomepageSection(m)];
  }

  /// `PATCH /homepage/:sectionKey` is an upsert on the server.
  Future<HomepageSection> saveSection(HomepageSection section) async {
    final json = await _api.patch('$_base/homepage/${section.sectionKey}', body: {
      'section_key': section.sectionKey,
      'title_en': section.titleEn,
      'title_ar': section.titleAr,
      'visible': section.visible ? 1 : 0,
      'sort_order': section.sortOrder,
      'config': section.config,
    });
    return HomepageSection((json['section'] as Map?)?.cast<String, dynamic>() ?? json);
  }

  // ── Navigation menus ─────────────────────────────────────────────────────

  Future<List<NavItem>> navigation(String menuKey) async {
    final json = await _api.get('$_base/navigation/$menuKey');
    return [for (final m in listOfMaps(json['items'] ?? json['navigation'])) NavItem(m)];
  }

  Future<NavItem> createNavItem(NavItem item) async {
    final json = await _api.post('$_base/navigation', body: _navBody(item));
    return NavItem((json['item'] as Map?)?.cast<String, dynamic>() ?? json);
  }

  Future<NavItem> updateNavItem(NavItem item) async {
    final json = await _api.patch('$_base/navigation/${item.id}', body: _navBody(item));
    return NavItem((json['item'] as Map?)?.cast<String, dynamic>() ?? json);
  }

  Future<void> deleteNavItem(String id) => _api.delete('$_base/navigation/$id');

  static Json _navBody(NavItem item) => {
        'menu_key': item.menuKey,
        'item_order': item.itemOrder,
        'label_en': item.labelEn,
        'label_ar': item.labelAr,
        'route': item.route,
        'external_url': item.externalUrl,
        'visible': item.visible ? 1 : 0,
        'icon': item.icon,
      };

  // ── Programmes ───────────────────────────────────────────────────────────

  Future<List<Programme>> programmes({String? status, String? destination, String? q}) async {
    final json = await _api.get('$_base/programmes', query: {
      if (status != null && status.isNotEmpty) 'status': status,
      if (destination != null && destination.isNotEmpty) 'destination': destination,
      if (q != null && q.isNotEmpty) 'q': q,
    });
    return [for (final m in listOfMaps(json['programmes'])) Programme(m)];
  }

  Future<Programme> programme(String id) async {
    final json = await _api.get('$_base/programmes/$id');
    return Programme((json['programme'] as Map?)?.cast<String, dynamic>() ?? json);
  }

  Future<Programme> createProgramme(Json body) async {
    final json = await _api.post('$_base/programmes', body: body);
    return Programme((json['programme'] as Map?)?.cast<String, dynamic>() ?? json);
  }

  Future<Programme> updateProgramme(String id, Json body) async {
    final json = await _api.patch('$_base/programmes/$id', body: body);
    return Programme((json['programme'] as Map?)?.cast<String, dynamic>() ?? json);
  }

  Future<Programme> setProgrammeStatus(String id, String status) async {
    final json = await _api.post('$_base/programmes/$id/$status');
    return Programme((json['programme'] as Map?)?.cast<String, dynamic>() ?? json);
  }

  Future<void> deleteProgramme(String id) => _api.delete('$_base/programmes/$id');
}
