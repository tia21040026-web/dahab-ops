// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paged.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Paged<T> {

 List<T> get items; String? get nextCursor; int get total;
/// Create a copy of Paged
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PagedCopyWith<T, Paged<T>> get copyWith => _$PagedCopyWithImpl<T, Paged<T>>(this as Paged<T>, _$identity);

  /// Serializes this Paged to a JSON map.
  Map<String, dynamic> toJson(Object? Function(T) toJsonT);


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Paged<T>&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),nextCursor,total);

@override
String toString() {
  return 'Paged<$T>(items: $items, nextCursor: $nextCursor, total: $total)';
}


}

/// @nodoc
abstract mixin class $PagedCopyWith<T,$Res>  {
  factory $PagedCopyWith(Paged<T> value, $Res Function(Paged<T>) _then) = _$PagedCopyWithImpl;
@useResult
$Res call({
 List<T> items, String? nextCursor, int total
});




}
/// @nodoc
class _$PagedCopyWithImpl<T,$Res>
    implements $PagedCopyWith<T, $Res> {
  _$PagedCopyWithImpl(this._self, this._then);

  final Paged<T> _self;
  final $Res Function(Paged<T>) _then;

/// Create a copy of Paged
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? nextCursor = freezed,Object? total = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<T>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Paged].
extension PagedPatterns<T> on Paged<T> {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Paged<T> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Paged() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Paged<T> value)  $default,){
final _that = this;
switch (_that) {
case _Paged():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Paged<T> value)?  $default,){
final _that = this;
switch (_that) {
case _Paged() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<T> items,  String? nextCursor,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Paged() when $default != null:
return $default(_that.items,_that.nextCursor,_that.total);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<T> items,  String? nextCursor,  int total)  $default,) {final _that = this;
switch (_that) {
case _Paged():
return $default(_that.items,_that.nextCursor,_that.total);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<T> items,  String? nextCursor,  int total)?  $default,) {final _that = this;
switch (_that) {
case _Paged() when $default != null:
return $default(_that.items,_that.nextCursor,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(genericArgumentFactories: true)

class _Paged<T> extends Paged<T> {
  const _Paged({final  List<T> items = const [], this.nextCursor, this.total = 0}): _items = items,super._();
  factory _Paged.fromJson(Map<String, dynamic> json,T Function(Object?) fromJsonT) => _$PagedFromJson(json,fromJsonT);

 final  List<T> _items;
@override@JsonKey() List<T> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  String? nextCursor;
@override@JsonKey() final  int total;

/// Create a copy of Paged
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PagedCopyWith<T, _Paged<T>> get copyWith => __$PagedCopyWithImpl<T, _Paged<T>>(this, _$identity);

@override
Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
  return _$PagedToJson<T>(this, toJsonT);
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Paged<T>&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),nextCursor,total);

@override
String toString() {
  return 'Paged<$T>(items: $items, nextCursor: $nextCursor, total: $total)';
}


}

/// @nodoc
abstract mixin class _$PagedCopyWith<T,$Res> implements $PagedCopyWith<T, $Res> {
  factory _$PagedCopyWith(_Paged<T> value, $Res Function(_Paged<T>) _then) = __$PagedCopyWithImpl;
@override @useResult
$Res call({
 List<T> items, String? nextCursor, int total
});




}
/// @nodoc
class __$PagedCopyWithImpl<T,$Res>
    implements _$PagedCopyWith<T, $Res> {
  __$PagedCopyWithImpl(this._self, this._then);

  final _Paged<T> _self;
  final $Res Function(_Paged<T>) _then;

/// Create a copy of Paged
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = freezed,Object? total = null,}) {
  return _then(_Paged<T>(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<T>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
