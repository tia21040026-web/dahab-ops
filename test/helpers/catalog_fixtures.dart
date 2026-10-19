import 'package:dahab_ops/features/catalog/data/catalog_models.dart';

/// A schema with one field of every kind (contract § Schema endpoint).
const sampleSchemaJson = <String, dynamic>{
  'type': 'hotel',
  'label': {'en': 'Hotels & stays', 'ar': 'الفنادق والإقامات'},
  'icon': 'bed',
  'sections': [
    {
      'key': 'basics',
      'label': {'en': 'Basics', 'ar': 'الأساسيات'},
      'fields': [
        {'key': 'title', 'kind': 'i18nText', 'required': true, 'max': 120, 'label': {'en': 'Title', 'ar': 'العنوان'}},
        {'key': 'summary', 'kind': 'i18nTextarea', 'max': 600, 'label': {'en': 'Summary', 'ar': 'الملخص'}},
        {'key': 'code', 'kind': 'text', 'label': {'en': 'Code'}},
        {
          'key': 'area',
          'kind': 'select',
          'required': true,
          'label': {'en': 'Area'},
          'options': [
            {'value': 'lighthouse', 'label': {'en': 'Lighthouse', 'ar': 'الفنار'}},
            {'value': 'mashraba', 'label': {'en': 'Mashraba', 'ar': 'المشربة'}},
          ],
        },
        {
          'key': 'languages',
          'kind': 'multiselect',
          'label': {'en': 'Languages'},
          'options': [
            {'value': 'en', 'label': {'en': 'English'}},
            {'value': 'ar', 'label': {'en': 'Arabic'}},
          ],
        },
        {'key': 'amenities', 'kind': 'tags', 'suggestions': ['wifi', 'pool'], 'label': {'en': 'Amenities'}},
        {'key': 'location', 'kind': 'geo', 'label': {'en': 'Location'}},
        {'key': 'supplierId', 'kind': 'supplier', 'label': {'en': 'Supplier'}},
        {'key': 'extra', 'kind': 'json', 'label': {'en': 'Extra'}},
      ],
    },
    {
      'key': 'media',
      'label': {'en': 'Photos'},
      'fields': [
        {'key': 'images', 'kind': 'gallery', 'min': 1, 'max': 20, 'label': {'en': 'Photos'}},
      ],
    },
    {
      'key': 'pricing',
      'label': {'en': 'Price & availability'},
      'fields': [
        {'key': 'priceFromEGP', 'kind': 'money', 'required': true, 'label': {'en': 'Price from'}},
        {'key': 'rooms', 'kind': 'number', 'label': {'en': 'Rooms'}},
        {'key': 'instant', 'kind': 'boolean', 'label': {'en': 'Instant confirm'}},
        {'key': 'checkIn', 'kind': 'time', 'label': {'en': 'Check-in'}},
        {'key': 'departures', 'kind': 'timeList', 'label': {'en': 'Departures'}},
        {'key': 'duration', 'kind': 'duration', 'label': {'en': 'Duration'}},
        {'key': 'days', 'kind': 'dayPlan', 'label': {'en': 'Itinerary'}},
      ],
    },
  ],
  'children': [
    {'key': 'rooms', 'label': {'en': 'Rooms'}, 'itemType': 'hotel-room'},
    {'key': 'rates', 'kind': 'rateCalendar'},
  ],
  'listColumns': ['title', 'status', 'priceFromEGP', 'supplierName', 'completeness'],
  'filters': ['status', 'supplierId', 'area'],
};

CatalogTypeSchema sampleSchema() => CatalogTypeSchema.fromJson(sampleSchemaJson);

Map<String, dynamic> envelope({
  String id = 'H1',
  String status = 'draft',
  String updatedAt = '2026-10-01T10:00:00.000Z',
  Map<String, dynamic> fields = const {},
  List<String> images = const [],
  Map<String, String> title = const {'en': 'Lagoon House', 'ar': 'بيت اللاجون'},
}) =>
    {
      'id': id,
      'type': 'hotel',
      'status': status,
      'supplierId': 'SUP-1',
      'supplierName': 'Lagoon Co',
      'title': title,
      'summary': {'en': '', 'ar': ''},
      'coverImage': images.isEmpty ? null : images.first,
      'images': images,
      'priceFromEGP': fields['priceFromEGP'],
      'fields': fields,
      'updatedAt': updatedAt,
      'updatedBy': 'u1',
      'completeness': 0.5,
    };
