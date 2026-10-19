// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Paged<T> _$PagedFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => _Paged<T>(
  items: (json['items'] as List<dynamic>?)?.map(fromJsonT).toList() ?? const [],
  nextCursor: json['nextCursor'] as String?,
  total: (json['total'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$PagedToJson<T>(
  _Paged<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'items': instance.items.map(toJsonT).toList(),
  'nextCursor': ?instance.nextCursor,
  'total': instance.total,
};
