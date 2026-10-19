// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminUserRow {

 String get id; String get email; String? get name; String? get phone; String get role; String? get supplierId; String get status;@LenientDateConverter() DateTime? get createdAt;@LenientDateConverter() DateTime? get lastSeenAt; int get deviceCount;
/// Create a copy of AdminUserRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminUserRowCopyWith<AdminUserRow> get copyWith => _$AdminUserRowCopyWithImpl<AdminUserRow>(this as AdminUserRow, _$identity);

  /// Serializes this AdminUserRow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminUserRow&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.role, role) || other.role == role)&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt)&&(identical(other.deviceCount, deviceCount) || other.deviceCount == deviceCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,name,phone,role,supplierId,status,createdAt,lastSeenAt,deviceCount);

@override
String toString() {
  return 'AdminUserRow(id: $id, email: $email, name: $name, phone: $phone, role: $role, supplierId: $supplierId, status: $status, createdAt: $createdAt, lastSeenAt: $lastSeenAt, deviceCount: $deviceCount)';
}


}

/// @nodoc
abstract mixin class $AdminUserRowCopyWith<$Res>  {
  factory $AdminUserRowCopyWith(AdminUserRow value, $Res Function(AdminUserRow) _then) = _$AdminUserRowCopyWithImpl;
@useResult
$Res call({
 String id, String email, String? name, String? phone, String role, String? supplierId, String status,@LenientDateConverter() DateTime? createdAt,@LenientDateConverter() DateTime? lastSeenAt, int deviceCount
});




}
/// @nodoc
class _$AdminUserRowCopyWithImpl<$Res>
    implements $AdminUserRowCopyWith<$Res> {
  _$AdminUserRowCopyWithImpl(this._self, this._then);

  final AdminUserRow _self;
  final $Res Function(AdminUserRow) _then;

/// Create a copy of AdminUserRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? name = freezed,Object? phone = freezed,Object? role = null,Object? supplierId = freezed,Object? status = null,Object? createdAt = freezed,Object? lastSeenAt = freezed,Object? deviceCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,supplierId: freezed == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastSeenAt: freezed == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deviceCount: null == deviceCount ? _self.deviceCount : deviceCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminUserRow].
extension AdminUserRowPatterns on AdminUserRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminUserRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminUserRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminUserRow value)  $default,){
final _that = this;
switch (_that) {
case _AdminUserRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminUserRow value)?  $default,){
final _that = this;
switch (_that) {
case _AdminUserRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String? name,  String? phone,  String role,  String? supplierId,  String status, @LenientDateConverter()  DateTime? createdAt, @LenientDateConverter()  DateTime? lastSeenAt,  int deviceCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminUserRow() when $default != null:
return $default(_that.id,_that.email,_that.name,_that.phone,_that.role,_that.supplierId,_that.status,_that.createdAt,_that.lastSeenAt,_that.deviceCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String? name,  String? phone,  String role,  String? supplierId,  String status, @LenientDateConverter()  DateTime? createdAt, @LenientDateConverter()  DateTime? lastSeenAt,  int deviceCount)  $default,) {final _that = this;
switch (_that) {
case _AdminUserRow():
return $default(_that.id,_that.email,_that.name,_that.phone,_that.role,_that.supplierId,_that.status,_that.createdAt,_that.lastSeenAt,_that.deviceCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String? name,  String? phone,  String role,  String? supplierId,  String status, @LenientDateConverter()  DateTime? createdAt, @LenientDateConverter()  DateTime? lastSeenAt,  int deviceCount)?  $default,) {final _that = this;
switch (_that) {
case _AdminUserRow() when $default != null:
return $default(_that.id,_that.email,_that.name,_that.phone,_that.role,_that.supplierId,_that.status,_that.createdAt,_that.lastSeenAt,_that.deviceCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminUserRow extends AdminUserRow {
  const _AdminUserRow({required this.id, required this.email, this.name, this.phone, this.role = 'Traveler', this.supplierId, this.status = 'active', @LenientDateConverter() this.createdAt, @LenientDateConverter() this.lastSeenAt, this.deviceCount = 0}): super._();
  factory _AdminUserRow.fromJson(Map<String, dynamic> json) => _$AdminUserRowFromJson(json);

@override final  String id;
@override final  String email;
@override final  String? name;
@override final  String? phone;
@override@JsonKey() final  String role;
@override final  String? supplierId;
@override@JsonKey() final  String status;
@override@LenientDateConverter() final  DateTime? createdAt;
@override@LenientDateConverter() final  DateTime? lastSeenAt;
@override@JsonKey() final  int deviceCount;

/// Create a copy of AdminUserRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminUserRowCopyWith<_AdminUserRow> get copyWith => __$AdminUserRowCopyWithImpl<_AdminUserRow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminUserRowToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminUserRow&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.role, role) || other.role == role)&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt)&&(identical(other.deviceCount, deviceCount) || other.deviceCount == deviceCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,name,phone,role,supplierId,status,createdAt,lastSeenAt,deviceCount);

@override
String toString() {
  return 'AdminUserRow(id: $id, email: $email, name: $name, phone: $phone, role: $role, supplierId: $supplierId, status: $status, createdAt: $createdAt, lastSeenAt: $lastSeenAt, deviceCount: $deviceCount)';
}


}

/// @nodoc
abstract mixin class _$AdminUserRowCopyWith<$Res> implements $AdminUserRowCopyWith<$Res> {
  factory _$AdminUserRowCopyWith(_AdminUserRow value, $Res Function(_AdminUserRow) _then) = __$AdminUserRowCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String? name, String? phone, String role, String? supplierId, String status,@LenientDateConverter() DateTime? createdAt,@LenientDateConverter() DateTime? lastSeenAt, int deviceCount
});




}
/// @nodoc
class __$AdminUserRowCopyWithImpl<$Res>
    implements _$AdminUserRowCopyWith<$Res> {
  __$AdminUserRowCopyWithImpl(this._self, this._then);

  final _AdminUserRow _self;
  final $Res Function(_AdminUserRow) _then;

/// Create a copy of AdminUserRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? name = freezed,Object? phone = freezed,Object? role = null,Object? supplierId = freezed,Object? status = null,Object? createdAt = freezed,Object? lastSeenAt = freezed,Object? deviceCount = null,}) {
  return _then(_AdminUserRow(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,supplierId: freezed == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastSeenAt: freezed == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deviceCount: null == deviceCount ? _self.deviceCount : deviceCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PermissionOverride {

 String get permission; String get effect;@StringishConverter() String? get createdBy;@LenientDateConverter() DateTime? get createdAt;
/// Create a copy of PermissionOverride
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PermissionOverrideCopyWith<PermissionOverride> get copyWith => _$PermissionOverrideCopyWithImpl<PermissionOverride>(this as PermissionOverride, _$identity);

  /// Serializes this PermissionOverride to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PermissionOverride&&(identical(other.permission, permission) || other.permission == permission)&&(identical(other.effect, effect) || other.effect == effect)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,permission,effect,createdBy,createdAt);

@override
String toString() {
  return 'PermissionOverride(permission: $permission, effect: $effect, createdBy: $createdBy, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PermissionOverrideCopyWith<$Res>  {
  factory $PermissionOverrideCopyWith(PermissionOverride value, $Res Function(PermissionOverride) _then) = _$PermissionOverrideCopyWithImpl;
@useResult
$Res call({
 String permission, String effect,@StringishConverter() String? createdBy,@LenientDateConverter() DateTime? createdAt
});




}
/// @nodoc
class _$PermissionOverrideCopyWithImpl<$Res>
    implements $PermissionOverrideCopyWith<$Res> {
  _$PermissionOverrideCopyWithImpl(this._self, this._then);

  final PermissionOverride _self;
  final $Res Function(PermissionOverride) _then;

/// Create a copy of PermissionOverride
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? permission = null,Object? effect = null,Object? createdBy = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
permission: null == permission ? _self.permission : permission // ignore: cast_nullable_to_non_nullable
as String,effect: null == effect ? _self.effect : effect // ignore: cast_nullable_to_non_nullable
as String,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PermissionOverride].
extension PermissionOverridePatterns on PermissionOverride {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PermissionOverride value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PermissionOverride() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PermissionOverride value)  $default,){
final _that = this;
switch (_that) {
case _PermissionOverride():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PermissionOverride value)?  $default,){
final _that = this;
switch (_that) {
case _PermissionOverride() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String permission,  String effect, @StringishConverter()  String? createdBy, @LenientDateConverter()  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PermissionOverride() when $default != null:
return $default(_that.permission,_that.effect,_that.createdBy,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String permission,  String effect, @StringishConverter()  String? createdBy, @LenientDateConverter()  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _PermissionOverride():
return $default(_that.permission,_that.effect,_that.createdBy,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String permission,  String effect, @StringishConverter()  String? createdBy, @LenientDateConverter()  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _PermissionOverride() when $default != null:
return $default(_that.permission,_that.effect,_that.createdBy,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PermissionOverride implements PermissionOverride {
  const _PermissionOverride({required this.permission, this.effect = 'grant', @StringishConverter() this.createdBy, @LenientDateConverter() this.createdAt});
  factory _PermissionOverride.fromJson(Map<String, dynamic> json) => _$PermissionOverrideFromJson(json);

@override final  String permission;
@override@JsonKey() final  String effect;
@override@StringishConverter() final  String? createdBy;
@override@LenientDateConverter() final  DateTime? createdAt;

/// Create a copy of PermissionOverride
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PermissionOverrideCopyWith<_PermissionOverride> get copyWith => __$PermissionOverrideCopyWithImpl<_PermissionOverride>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PermissionOverrideToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PermissionOverride&&(identical(other.permission, permission) || other.permission == permission)&&(identical(other.effect, effect) || other.effect == effect)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,permission,effect,createdBy,createdAt);

@override
String toString() {
  return 'PermissionOverride(permission: $permission, effect: $effect, createdBy: $createdBy, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PermissionOverrideCopyWith<$Res> implements $PermissionOverrideCopyWith<$Res> {
  factory _$PermissionOverrideCopyWith(_PermissionOverride value, $Res Function(_PermissionOverride) _then) = __$PermissionOverrideCopyWithImpl;
@override @useResult
$Res call({
 String permission, String effect,@StringishConverter() String? createdBy,@LenientDateConverter() DateTime? createdAt
});




}
/// @nodoc
class __$PermissionOverrideCopyWithImpl<$Res>
    implements _$PermissionOverrideCopyWith<$Res> {
  __$PermissionOverrideCopyWithImpl(this._self, this._then);

  final _PermissionOverride _self;
  final $Res Function(_PermissionOverride) _then;

/// Create a copy of PermissionOverride
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? permission = null,Object? effect = null,Object? createdBy = freezed,Object? createdAt = freezed,}) {
  return _then(_PermissionOverride(
permission: null == permission ? _self.permission : permission // ignore: cast_nullable_to_non_nullable
as String,effect: null == effect ? _self.effect : effect // ignore: cast_nullable_to_non_nullable
as String,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$UserDetail {

 User get user; String? get roleId; List<PermissionOverride> get overrides; List<String> get effectivePermissions; List<DeviceSession> get devices;
/// Create a copy of UserDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserDetailCopyWith<UserDetail> get copyWith => _$UserDetailCopyWithImpl<UserDetail>(this as UserDetail, _$identity);

  /// Serializes this UserDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserDetail&&(identical(other.user, user) || other.user == user)&&(identical(other.roleId, roleId) || other.roleId == roleId)&&const DeepCollectionEquality().equals(other.overrides, overrides)&&const DeepCollectionEquality().equals(other.effectivePermissions, effectivePermissions)&&const DeepCollectionEquality().equals(other.devices, devices));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,roleId,const DeepCollectionEquality().hash(overrides),const DeepCollectionEquality().hash(effectivePermissions),const DeepCollectionEquality().hash(devices));

@override
String toString() {
  return 'UserDetail(user: $user, roleId: $roleId, overrides: $overrides, effectivePermissions: $effectivePermissions, devices: $devices)';
}


}

/// @nodoc
abstract mixin class $UserDetailCopyWith<$Res>  {
  factory $UserDetailCopyWith(UserDetail value, $Res Function(UserDetail) _then) = _$UserDetailCopyWithImpl;
@useResult
$Res call({
 User user, String? roleId, List<PermissionOverride> overrides, List<String> effectivePermissions, List<DeviceSession> devices
});


$UserCopyWith<$Res> get user;

}
/// @nodoc
class _$UserDetailCopyWithImpl<$Res>
    implements $UserDetailCopyWith<$Res> {
  _$UserDetailCopyWithImpl(this._self, this._then);

  final UserDetail _self;
  final $Res Function(UserDetail) _then;

/// Create a copy of UserDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user = null,Object? roleId = freezed,Object? overrides = null,Object? effectivePermissions = null,Object? devices = null,}) {
  return _then(_self.copyWith(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User,roleId: freezed == roleId ? _self.roleId : roleId // ignore: cast_nullable_to_non_nullable
as String?,overrides: null == overrides ? _self.overrides : overrides // ignore: cast_nullable_to_non_nullable
as List<PermissionOverride>,effectivePermissions: null == effectivePermissions ? _self.effectivePermissions : effectivePermissions // ignore: cast_nullable_to_non_nullable
as List<String>,devices: null == devices ? _self.devices : devices // ignore: cast_nullable_to_non_nullable
as List<DeviceSession>,
  ));
}
/// Create a copy of UserDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get user {
  
  return $UserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [UserDetail].
extension UserDetailPatterns on UserDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserDetail value)  $default,){
final _that = this;
switch (_that) {
case _UserDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserDetail value)?  $default,){
final _that = this;
switch (_that) {
case _UserDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( User user,  String? roleId,  List<PermissionOverride> overrides,  List<String> effectivePermissions,  List<DeviceSession> devices)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserDetail() when $default != null:
return $default(_that.user,_that.roleId,_that.overrides,_that.effectivePermissions,_that.devices);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( User user,  String? roleId,  List<PermissionOverride> overrides,  List<String> effectivePermissions,  List<DeviceSession> devices)  $default,) {final _that = this;
switch (_that) {
case _UserDetail():
return $default(_that.user,_that.roleId,_that.overrides,_that.effectivePermissions,_that.devices);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( User user,  String? roleId,  List<PermissionOverride> overrides,  List<String> effectivePermissions,  List<DeviceSession> devices)?  $default,) {final _that = this;
switch (_that) {
case _UserDetail() when $default != null:
return $default(_that.user,_that.roleId,_that.overrides,_that.effectivePermissions,_that.devices);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserDetail implements UserDetail {
  const _UserDetail({required this.user, this.roleId, final  List<PermissionOverride> overrides = const [], final  List<String> effectivePermissions = const [], final  List<DeviceSession> devices = const []}): _overrides = overrides,_effectivePermissions = effectivePermissions,_devices = devices;
  factory _UserDetail.fromJson(Map<String, dynamic> json) => _$UserDetailFromJson(json);

@override final  User user;
@override final  String? roleId;
 final  List<PermissionOverride> _overrides;
@override@JsonKey() List<PermissionOverride> get overrides {
  if (_overrides is EqualUnmodifiableListView) return _overrides;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_overrides);
}

 final  List<String> _effectivePermissions;
@override@JsonKey() List<String> get effectivePermissions {
  if (_effectivePermissions is EqualUnmodifiableListView) return _effectivePermissions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_effectivePermissions);
}

 final  List<DeviceSession> _devices;
@override@JsonKey() List<DeviceSession> get devices {
  if (_devices is EqualUnmodifiableListView) return _devices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_devices);
}


/// Create a copy of UserDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserDetailCopyWith<_UserDetail> get copyWith => __$UserDetailCopyWithImpl<_UserDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserDetail&&(identical(other.user, user) || other.user == user)&&(identical(other.roleId, roleId) || other.roleId == roleId)&&const DeepCollectionEquality().equals(other._overrides, _overrides)&&const DeepCollectionEquality().equals(other._effectivePermissions, _effectivePermissions)&&const DeepCollectionEquality().equals(other._devices, _devices));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,roleId,const DeepCollectionEquality().hash(_overrides),const DeepCollectionEquality().hash(_effectivePermissions),const DeepCollectionEquality().hash(_devices));

@override
String toString() {
  return 'UserDetail(user: $user, roleId: $roleId, overrides: $overrides, effectivePermissions: $effectivePermissions, devices: $devices)';
}


}

/// @nodoc
abstract mixin class _$UserDetailCopyWith<$Res> implements $UserDetailCopyWith<$Res> {
  factory _$UserDetailCopyWith(_UserDetail value, $Res Function(_UserDetail) _then) = __$UserDetailCopyWithImpl;
@override @useResult
$Res call({
 User user, String? roleId, List<PermissionOverride> overrides, List<String> effectivePermissions, List<DeviceSession> devices
});


@override $UserCopyWith<$Res> get user;

}
/// @nodoc
class __$UserDetailCopyWithImpl<$Res>
    implements _$UserDetailCopyWith<$Res> {
  __$UserDetailCopyWithImpl(this._self, this._then);

  final _UserDetail _self;
  final $Res Function(_UserDetail) _then;

/// Create a copy of UserDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user = null,Object? roleId = freezed,Object? overrides = null,Object? effectivePermissions = null,Object? devices = null,}) {
  return _then(_UserDetail(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User,roleId: freezed == roleId ? _self.roleId : roleId // ignore: cast_nullable_to_non_nullable
as String?,overrides: null == overrides ? _self._overrides : overrides // ignore: cast_nullable_to_non_nullable
as List<PermissionOverride>,effectivePermissions: null == effectivePermissions ? _self._effectivePermissions : effectivePermissions // ignore: cast_nullable_to_non_nullable
as List<String>,devices: null == devices ? _self._devices : devices // ignore: cast_nullable_to_non_nullable
as List<DeviceSession>,
  ));
}

/// Create a copy of UserDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get user {
  
  return $UserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// @nodoc
mixin _$InviteResult {

 User get user; String get tempPassword;
/// Create a copy of InviteResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InviteResultCopyWith<InviteResult> get copyWith => _$InviteResultCopyWithImpl<InviteResult>(this as InviteResult, _$identity);

  /// Serializes this InviteResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InviteResult&&(identical(other.user, user) || other.user == user)&&(identical(other.tempPassword, tempPassword) || other.tempPassword == tempPassword));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,tempPassword);

@override
String toString() {
  return 'InviteResult(user: $user, tempPassword: $tempPassword)';
}


}

/// @nodoc
abstract mixin class $InviteResultCopyWith<$Res>  {
  factory $InviteResultCopyWith(InviteResult value, $Res Function(InviteResult) _then) = _$InviteResultCopyWithImpl;
@useResult
$Res call({
 User user, String tempPassword
});


$UserCopyWith<$Res> get user;

}
/// @nodoc
class _$InviteResultCopyWithImpl<$Res>
    implements $InviteResultCopyWith<$Res> {
  _$InviteResultCopyWithImpl(this._self, this._then);

  final InviteResult _self;
  final $Res Function(InviteResult) _then;

/// Create a copy of InviteResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user = null,Object? tempPassword = null,}) {
  return _then(_self.copyWith(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User,tempPassword: null == tempPassword ? _self.tempPassword : tempPassword // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of InviteResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get user {
  
  return $UserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [InviteResult].
extension InviteResultPatterns on InviteResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InviteResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InviteResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InviteResult value)  $default,){
final _that = this;
switch (_that) {
case _InviteResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InviteResult value)?  $default,){
final _that = this;
switch (_that) {
case _InviteResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( User user,  String tempPassword)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InviteResult() when $default != null:
return $default(_that.user,_that.tempPassword);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( User user,  String tempPassword)  $default,) {final _that = this;
switch (_that) {
case _InviteResult():
return $default(_that.user,_that.tempPassword);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( User user,  String tempPassword)?  $default,) {final _that = this;
switch (_that) {
case _InviteResult() when $default != null:
return $default(_that.user,_that.tempPassword);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InviteResult implements InviteResult {
  const _InviteResult({required this.user, required this.tempPassword});
  factory _InviteResult.fromJson(Map<String, dynamic> json) => _$InviteResultFromJson(json);

@override final  User user;
@override final  String tempPassword;

/// Create a copy of InviteResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InviteResultCopyWith<_InviteResult> get copyWith => __$InviteResultCopyWithImpl<_InviteResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InviteResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InviteResult&&(identical(other.user, user) || other.user == user)&&(identical(other.tempPassword, tempPassword) || other.tempPassword == tempPassword));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,tempPassword);

@override
String toString() {
  return 'InviteResult(user: $user, tempPassword: $tempPassword)';
}


}

/// @nodoc
abstract mixin class _$InviteResultCopyWith<$Res> implements $InviteResultCopyWith<$Res> {
  factory _$InviteResultCopyWith(_InviteResult value, $Res Function(_InviteResult) _then) = __$InviteResultCopyWithImpl;
@override @useResult
$Res call({
 User user, String tempPassword
});


@override $UserCopyWith<$Res> get user;

}
/// @nodoc
class __$InviteResultCopyWithImpl<$Res>
    implements _$InviteResultCopyWith<$Res> {
  __$InviteResultCopyWithImpl(this._self, this._then);

  final _InviteResult _self;
  final $Res Function(_InviteResult) _then;

/// Create a copy of InviteResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user = null,Object? tempPassword = null,}) {
  return _then(_InviteResult(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User,tempPassword: null == tempPassword ? _self.tempPassword : tempPassword // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of InviteResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get user {
  
  return $UserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// @nodoc
mixin _$PermissionDef {

 String get key; String get group; String? get labelEn; String? get labelAr; bool get dangerous;
/// Create a copy of PermissionDef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PermissionDefCopyWith<PermissionDef> get copyWith => _$PermissionDefCopyWithImpl<PermissionDef>(this as PermissionDef, _$identity);

  /// Serializes this PermissionDef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PermissionDef&&(identical(other.key, key) || other.key == key)&&(identical(other.group, group) || other.group == group)&&(identical(other.labelEn, labelEn) || other.labelEn == labelEn)&&(identical(other.labelAr, labelAr) || other.labelAr == labelAr)&&(identical(other.dangerous, dangerous) || other.dangerous == dangerous));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,group,labelEn,labelAr,dangerous);

@override
String toString() {
  return 'PermissionDef(key: $key, group: $group, labelEn: $labelEn, labelAr: $labelAr, dangerous: $dangerous)';
}


}

/// @nodoc
abstract mixin class $PermissionDefCopyWith<$Res>  {
  factory $PermissionDefCopyWith(PermissionDef value, $Res Function(PermissionDef) _then) = _$PermissionDefCopyWithImpl;
@useResult
$Res call({
 String key, String group, String? labelEn, String? labelAr, bool dangerous
});




}
/// @nodoc
class _$PermissionDefCopyWithImpl<$Res>
    implements $PermissionDefCopyWith<$Res> {
  _$PermissionDefCopyWithImpl(this._self, this._then);

  final PermissionDef _self;
  final $Res Function(PermissionDef) _then;

/// Create a copy of PermissionDef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? group = null,Object? labelEn = freezed,Object? labelAr = freezed,Object? dangerous = null,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String,labelEn: freezed == labelEn ? _self.labelEn : labelEn // ignore: cast_nullable_to_non_nullable
as String?,labelAr: freezed == labelAr ? _self.labelAr : labelAr // ignore: cast_nullable_to_non_nullable
as String?,dangerous: null == dangerous ? _self.dangerous : dangerous // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PermissionDef].
extension PermissionDefPatterns on PermissionDef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PermissionDef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PermissionDef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PermissionDef value)  $default,){
final _that = this;
switch (_that) {
case _PermissionDef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PermissionDef value)?  $default,){
final _that = this;
switch (_that) {
case _PermissionDef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String group,  String? labelEn,  String? labelAr,  bool dangerous)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PermissionDef() when $default != null:
return $default(_that.key,_that.group,_that.labelEn,_that.labelAr,_that.dangerous);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String group,  String? labelEn,  String? labelAr,  bool dangerous)  $default,) {final _that = this;
switch (_that) {
case _PermissionDef():
return $default(_that.key,_that.group,_that.labelEn,_that.labelAr,_that.dangerous);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String group,  String? labelEn,  String? labelAr,  bool dangerous)?  $default,) {final _that = this;
switch (_that) {
case _PermissionDef() when $default != null:
return $default(_that.key,_that.group,_that.labelEn,_that.labelAr,_that.dangerous);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PermissionDef extends PermissionDef {
  const _PermissionDef({required this.key, this.group = 'other', this.labelEn, this.labelAr, this.dangerous = false}): super._();
  factory _PermissionDef.fromJson(Map<String, dynamic> json) => _$PermissionDefFromJson(json);

@override final  String key;
@override@JsonKey() final  String group;
@override final  String? labelEn;
@override final  String? labelAr;
@override@JsonKey() final  bool dangerous;

/// Create a copy of PermissionDef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PermissionDefCopyWith<_PermissionDef> get copyWith => __$PermissionDefCopyWithImpl<_PermissionDef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PermissionDefToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PermissionDef&&(identical(other.key, key) || other.key == key)&&(identical(other.group, group) || other.group == group)&&(identical(other.labelEn, labelEn) || other.labelEn == labelEn)&&(identical(other.labelAr, labelAr) || other.labelAr == labelAr)&&(identical(other.dangerous, dangerous) || other.dangerous == dangerous));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,group,labelEn,labelAr,dangerous);

@override
String toString() {
  return 'PermissionDef(key: $key, group: $group, labelEn: $labelEn, labelAr: $labelAr, dangerous: $dangerous)';
}


}

/// @nodoc
abstract mixin class _$PermissionDefCopyWith<$Res> implements $PermissionDefCopyWith<$Res> {
  factory _$PermissionDefCopyWith(_PermissionDef value, $Res Function(_PermissionDef) _then) = __$PermissionDefCopyWithImpl;
@override @useResult
$Res call({
 String key, String group, String? labelEn, String? labelAr, bool dangerous
});




}
/// @nodoc
class __$PermissionDefCopyWithImpl<$Res>
    implements _$PermissionDefCopyWith<$Res> {
  __$PermissionDefCopyWithImpl(this._self, this._then);

  final _PermissionDef _self;
  final $Res Function(_PermissionDef) _then;

/// Create a copy of PermissionDef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? group = null,Object? labelEn = freezed,Object? labelAr = freezed,Object? dangerous = null,}) {
  return _then(_PermissionDef(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String,labelEn: freezed == labelEn ? _self.labelEn : labelEn // ignore: cast_nullable_to_non_nullable
as String?,labelAr: freezed == labelAr ? _self.labelAr : labelAr // ignore: cast_nullable_to_non_nullable
as String?,dangerous: null == dangerous ? _self.dangerous : dangerous // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$Role {

 String get id; String get name; String? get description; bool get isSystem; List<String> get permissions; int get userCount;
/// Create a copy of Role
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoleCopyWith<Role> get copyWith => _$RoleCopyWithImpl<Role>(this as Role, _$identity);

  /// Serializes this Role to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Role&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.isSystem, isSystem) || other.isSystem == isSystem)&&const DeepCollectionEquality().equals(other.permissions, permissions)&&(identical(other.userCount, userCount) || other.userCount == userCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,isSystem,const DeepCollectionEquality().hash(permissions),userCount);

@override
String toString() {
  return 'Role(id: $id, name: $name, description: $description, isSystem: $isSystem, permissions: $permissions, userCount: $userCount)';
}


}

/// @nodoc
abstract mixin class $RoleCopyWith<$Res>  {
  factory $RoleCopyWith(Role value, $Res Function(Role) _then) = _$RoleCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description, bool isSystem, List<String> permissions, int userCount
});




}
/// @nodoc
class _$RoleCopyWithImpl<$Res>
    implements $RoleCopyWith<$Res> {
  _$RoleCopyWithImpl(this._self, this._then);

  final Role _self;
  final $Res Function(Role) _then;

/// Create a copy of Role
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? isSystem = null,Object? permissions = null,Object? userCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,permissions: null == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as List<String>,userCount: null == userCount ? _self.userCount : userCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Role].
extension RolePatterns on Role {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Role value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Role() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Role value)  $default,){
final _that = this;
switch (_that) {
case _Role():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Role value)?  $default,){
final _that = this;
switch (_that) {
case _Role() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  bool isSystem,  List<String> permissions,  int userCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Role() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.isSystem,_that.permissions,_that.userCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  bool isSystem,  List<String> permissions,  int userCount)  $default,) {final _that = this;
switch (_that) {
case _Role():
return $default(_that.id,_that.name,_that.description,_that.isSystem,_that.permissions,_that.userCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? description,  bool isSystem,  List<String> permissions,  int userCount)?  $default,) {final _that = this;
switch (_that) {
case _Role() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.isSystem,_that.permissions,_that.userCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Role implements Role {
  const _Role({required this.id, required this.name, this.description, this.isSystem = false, final  List<String> permissions = const [], this.userCount = 0}): _permissions = permissions;
  factory _Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? description;
@override@JsonKey() final  bool isSystem;
 final  List<String> _permissions;
@override@JsonKey() List<String> get permissions {
  if (_permissions is EqualUnmodifiableListView) return _permissions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_permissions);
}

@override@JsonKey() final  int userCount;

/// Create a copy of Role
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoleCopyWith<_Role> get copyWith => __$RoleCopyWithImpl<_Role>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Role&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.isSystem, isSystem) || other.isSystem == isSystem)&&const DeepCollectionEquality().equals(other._permissions, _permissions)&&(identical(other.userCount, userCount) || other.userCount == userCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,isSystem,const DeepCollectionEquality().hash(_permissions),userCount);

@override
String toString() {
  return 'Role(id: $id, name: $name, description: $description, isSystem: $isSystem, permissions: $permissions, userCount: $userCount)';
}


}

/// @nodoc
abstract mixin class _$RoleCopyWith<$Res> implements $RoleCopyWith<$Res> {
  factory _$RoleCopyWith(_Role value, $Res Function(_Role) _then) = __$RoleCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description, bool isSystem, List<String> permissions, int userCount
});




}
/// @nodoc
class __$RoleCopyWithImpl<$Res>
    implements _$RoleCopyWith<$Res> {
  __$RoleCopyWithImpl(this._self, this._then);

  final _Role _self;
  final $Res Function(_Role) _then;

/// Create a copy of Role
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? isSystem = null,Object? permissions = null,Object? userCount = null,}) {
  return _then(_Role(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,permissions: null == permissions ? _self._permissions : permissions // ignore: cast_nullable_to_non_nullable
as List<String>,userCount: null == userCount ? _self.userCount : userCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$SettingItem {

 String get key; Object? get value; String get type; String get group; String? get labelEn; String? get labelAr; int get version;@StringishConverter() String? get updatedBy;@LenientDateConverter() DateTime? get updatedAt;
/// Create a copy of SettingItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingItemCopyWith<SettingItem> get copyWith => _$SettingItemCopyWithImpl<SettingItem>(this as SettingItem, _$identity);

  /// Serializes this SettingItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingItem&&(identical(other.key, key) || other.key == key)&&const DeepCollectionEquality().equals(other.value, value)&&(identical(other.type, type) || other.type == type)&&(identical(other.group, group) || other.group == group)&&(identical(other.labelEn, labelEn) || other.labelEn == labelEn)&&(identical(other.labelAr, labelAr) || other.labelAr == labelAr)&&(identical(other.version, version) || other.version == version)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,const DeepCollectionEquality().hash(value),type,group,labelEn,labelAr,version,updatedBy,updatedAt);

@override
String toString() {
  return 'SettingItem(key: $key, value: $value, type: $type, group: $group, labelEn: $labelEn, labelAr: $labelAr, version: $version, updatedBy: $updatedBy, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $SettingItemCopyWith<$Res>  {
  factory $SettingItemCopyWith(SettingItem value, $Res Function(SettingItem) _then) = _$SettingItemCopyWithImpl;
@useResult
$Res call({
 String key, Object? value, String type, String group, String? labelEn, String? labelAr, int version,@StringishConverter() String? updatedBy,@LenientDateConverter() DateTime? updatedAt
});




}
/// @nodoc
class _$SettingItemCopyWithImpl<$Res>
    implements $SettingItemCopyWith<$Res> {
  _$SettingItemCopyWithImpl(this._self, this._then);

  final SettingItem _self;
  final $Res Function(SettingItem) _then;

/// Create a copy of SettingItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? value = freezed,Object? type = null,Object? group = null,Object? labelEn = freezed,Object? labelAr = freezed,Object? version = null,Object? updatedBy = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,value: freezed == value ? _self.value : value ,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String,labelEn: freezed == labelEn ? _self.labelEn : labelEn // ignore: cast_nullable_to_non_nullable
as String?,labelAr: freezed == labelAr ? _self.labelAr : labelAr // ignore: cast_nullable_to_non_nullable
as String?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,updatedBy: freezed == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SettingItem].
extension SettingItemPatterns on SettingItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettingItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettingItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettingItem value)  $default,){
final _that = this;
switch (_that) {
case _SettingItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettingItem value)?  $default,){
final _that = this;
switch (_that) {
case _SettingItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  Object? value,  String type,  String group,  String? labelEn,  String? labelAr,  int version, @StringishConverter()  String? updatedBy, @LenientDateConverter()  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettingItem() when $default != null:
return $default(_that.key,_that.value,_that.type,_that.group,_that.labelEn,_that.labelAr,_that.version,_that.updatedBy,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  Object? value,  String type,  String group,  String? labelEn,  String? labelAr,  int version, @StringishConverter()  String? updatedBy, @LenientDateConverter()  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _SettingItem():
return $default(_that.key,_that.value,_that.type,_that.group,_that.labelEn,_that.labelAr,_that.version,_that.updatedBy,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  Object? value,  String type,  String group,  String? labelEn,  String? labelAr,  int version, @StringishConverter()  String? updatedBy, @LenientDateConverter()  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _SettingItem() when $default != null:
return $default(_that.key,_that.value,_that.type,_that.group,_that.labelEn,_that.labelAr,_that.version,_that.updatedBy,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SettingItem extends SettingItem {
  const _SettingItem({required this.key, this.value, this.type = 'string', this.group = 'general', this.labelEn, this.labelAr, this.version = 1, @StringishConverter() this.updatedBy, @LenientDateConverter() this.updatedAt}): super._();
  factory _SettingItem.fromJson(Map<String, dynamic> json) => _$SettingItemFromJson(json);

@override final  String key;
@override final  Object? value;
@override@JsonKey() final  String type;
@override@JsonKey() final  String group;
@override final  String? labelEn;
@override final  String? labelAr;
@override@JsonKey() final  int version;
@override@StringishConverter() final  String? updatedBy;
@override@LenientDateConverter() final  DateTime? updatedAt;

/// Create a copy of SettingItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingItemCopyWith<_SettingItem> get copyWith => __$SettingItemCopyWithImpl<_SettingItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SettingItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingItem&&(identical(other.key, key) || other.key == key)&&const DeepCollectionEquality().equals(other.value, value)&&(identical(other.type, type) || other.type == type)&&(identical(other.group, group) || other.group == group)&&(identical(other.labelEn, labelEn) || other.labelEn == labelEn)&&(identical(other.labelAr, labelAr) || other.labelAr == labelAr)&&(identical(other.version, version) || other.version == version)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,const DeepCollectionEquality().hash(value),type,group,labelEn,labelAr,version,updatedBy,updatedAt);

@override
String toString() {
  return 'SettingItem(key: $key, value: $value, type: $type, group: $group, labelEn: $labelEn, labelAr: $labelAr, version: $version, updatedBy: $updatedBy, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$SettingItemCopyWith<$Res> implements $SettingItemCopyWith<$Res> {
  factory _$SettingItemCopyWith(_SettingItem value, $Res Function(_SettingItem) _then) = __$SettingItemCopyWithImpl;
@override @useResult
$Res call({
 String key, Object? value, String type, String group, String? labelEn, String? labelAr, int version,@StringishConverter() String? updatedBy,@LenientDateConverter() DateTime? updatedAt
});




}
/// @nodoc
class __$SettingItemCopyWithImpl<$Res>
    implements _$SettingItemCopyWith<$Res> {
  __$SettingItemCopyWithImpl(this._self, this._then);

  final _SettingItem _self;
  final $Res Function(_SettingItem) _then;

/// Create a copy of SettingItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? value = freezed,Object? type = null,Object? group = null,Object? labelEn = freezed,Object? labelAr = freezed,Object? version = null,Object? updatedBy = freezed,Object? updatedAt = freezed,}) {
  return _then(_SettingItem(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,value: freezed == value ? _self.value : value ,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String,labelEn: freezed == labelEn ? _self.labelEn : labelEn // ignore: cast_nullable_to_non_nullable
as String?,labelAr: freezed == labelAr ? _self.labelAr : labelAr // ignore: cast_nullable_to_non_nullable
as String?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,updatedBy: freezed == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$SettingVersion {

 int get version; Object? get value;@StringishConverter() String? get updatedBy;@LenientDateConverter() DateTime? get updatedAt; String? get reason;
/// Create a copy of SettingVersion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingVersionCopyWith<SettingVersion> get copyWith => _$SettingVersionCopyWithImpl<SettingVersion>(this as SettingVersion, _$identity);

  /// Serializes this SettingVersion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingVersion&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.value, value)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,const DeepCollectionEquality().hash(value),updatedBy,updatedAt,reason);

@override
String toString() {
  return 'SettingVersion(version: $version, value: $value, updatedBy: $updatedBy, updatedAt: $updatedAt, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $SettingVersionCopyWith<$Res>  {
  factory $SettingVersionCopyWith(SettingVersion value, $Res Function(SettingVersion) _then) = _$SettingVersionCopyWithImpl;
@useResult
$Res call({
 int version, Object? value,@StringishConverter() String? updatedBy,@LenientDateConverter() DateTime? updatedAt, String? reason
});




}
/// @nodoc
class _$SettingVersionCopyWithImpl<$Res>
    implements $SettingVersionCopyWith<$Res> {
  _$SettingVersionCopyWithImpl(this._self, this._then);

  final SettingVersion _self;
  final $Res Function(SettingVersion) _then;

/// Create a copy of SettingVersion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? value = freezed,Object? updatedBy = freezed,Object? updatedAt = freezed,Object? reason = freezed,}) {
  return _then(_self.copyWith(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,value: freezed == value ? _self.value : value ,updatedBy: freezed == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SettingVersion].
extension SettingVersionPatterns on SettingVersion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettingVersion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettingVersion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettingVersion value)  $default,){
final _that = this;
switch (_that) {
case _SettingVersion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettingVersion value)?  $default,){
final _that = this;
switch (_that) {
case _SettingVersion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int version,  Object? value, @StringishConverter()  String? updatedBy, @LenientDateConverter()  DateTime? updatedAt,  String? reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettingVersion() when $default != null:
return $default(_that.version,_that.value,_that.updatedBy,_that.updatedAt,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int version,  Object? value, @StringishConverter()  String? updatedBy, @LenientDateConverter()  DateTime? updatedAt,  String? reason)  $default,) {final _that = this;
switch (_that) {
case _SettingVersion():
return $default(_that.version,_that.value,_that.updatedBy,_that.updatedAt,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int version,  Object? value, @StringishConverter()  String? updatedBy, @LenientDateConverter()  DateTime? updatedAt,  String? reason)?  $default,) {final _that = this;
switch (_that) {
case _SettingVersion() when $default != null:
return $default(_that.version,_that.value,_that.updatedBy,_that.updatedAt,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SettingVersion implements SettingVersion {
  const _SettingVersion({required this.version, this.value, @StringishConverter() this.updatedBy, @LenientDateConverter() this.updatedAt, this.reason});
  factory _SettingVersion.fromJson(Map<String, dynamic> json) => _$SettingVersionFromJson(json);

@override final  int version;
@override final  Object? value;
@override@StringishConverter() final  String? updatedBy;
@override@LenientDateConverter() final  DateTime? updatedAt;
@override final  String? reason;

/// Create a copy of SettingVersion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingVersionCopyWith<_SettingVersion> get copyWith => __$SettingVersionCopyWithImpl<_SettingVersion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SettingVersionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingVersion&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.value, value)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,const DeepCollectionEquality().hash(value),updatedBy,updatedAt,reason);

@override
String toString() {
  return 'SettingVersion(version: $version, value: $value, updatedBy: $updatedBy, updatedAt: $updatedAt, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$SettingVersionCopyWith<$Res> implements $SettingVersionCopyWith<$Res> {
  factory _$SettingVersionCopyWith(_SettingVersion value, $Res Function(_SettingVersion) _then) = __$SettingVersionCopyWithImpl;
@override @useResult
$Res call({
 int version, Object? value,@StringishConverter() String? updatedBy,@LenientDateConverter() DateTime? updatedAt, String? reason
});




}
/// @nodoc
class __$SettingVersionCopyWithImpl<$Res>
    implements _$SettingVersionCopyWith<$Res> {
  __$SettingVersionCopyWithImpl(this._self, this._then);

  final _SettingVersion _self;
  final $Res Function(_SettingVersion) _then;

/// Create a copy of SettingVersion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? value = freezed,Object? updatedBy = freezed,Object? updatedAt = freezed,Object? reason = freezed,}) {
  return _then(_SettingVersion(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,value: freezed == value ? _self.value : value ,updatedBy: freezed == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$FlagItem {

 String get key; String get kind; bool get enabled; int? get rolloutPercent; List<String> get roles; String? get description;@StringishConverter() String? get updatedBy;@LenientDateConverter() DateTime? get updatedAt;
/// Create a copy of FlagItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FlagItemCopyWith<FlagItem> get copyWith => _$FlagItemCopyWithImpl<FlagItem>(this as FlagItem, _$identity);

  /// Serializes this FlagItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FlagItem&&(identical(other.key, key) || other.key == key)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.rolloutPercent, rolloutPercent) || other.rolloutPercent == rolloutPercent)&&const DeepCollectionEquality().equals(other.roles, roles)&&(identical(other.description, description) || other.description == description)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,kind,enabled,rolloutPercent,const DeepCollectionEquality().hash(roles),description,updatedBy,updatedAt);

@override
String toString() {
  return 'FlagItem(key: $key, kind: $kind, enabled: $enabled, rolloutPercent: $rolloutPercent, roles: $roles, description: $description, updatedBy: $updatedBy, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $FlagItemCopyWith<$Res>  {
  factory $FlagItemCopyWith(FlagItem value, $Res Function(FlagItem) _then) = _$FlagItemCopyWithImpl;
@useResult
$Res call({
 String key, String kind, bool enabled, int? rolloutPercent, List<String> roles, String? description,@StringishConverter() String? updatedBy,@LenientDateConverter() DateTime? updatedAt
});




}
/// @nodoc
class _$FlagItemCopyWithImpl<$Res>
    implements $FlagItemCopyWith<$Res> {
  _$FlagItemCopyWithImpl(this._self, this._then);

  final FlagItem _self;
  final $Res Function(FlagItem) _then;

/// Create a copy of FlagItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? kind = null,Object? enabled = null,Object? rolloutPercent = freezed,Object? roles = null,Object? description = freezed,Object? updatedBy = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,rolloutPercent: freezed == rolloutPercent ? _self.rolloutPercent : rolloutPercent // ignore: cast_nullable_to_non_nullable
as int?,roles: null == roles ? _self.roles : roles // ignore: cast_nullable_to_non_nullable
as List<String>,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,updatedBy: freezed == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [FlagItem].
extension FlagItemPatterns on FlagItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FlagItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FlagItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FlagItem value)  $default,){
final _that = this;
switch (_that) {
case _FlagItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FlagItem value)?  $default,){
final _that = this;
switch (_that) {
case _FlagItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String kind,  bool enabled,  int? rolloutPercent,  List<String> roles,  String? description, @StringishConverter()  String? updatedBy, @LenientDateConverter()  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FlagItem() when $default != null:
return $default(_that.key,_that.kind,_that.enabled,_that.rolloutPercent,_that.roles,_that.description,_that.updatedBy,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String kind,  bool enabled,  int? rolloutPercent,  List<String> roles,  String? description, @StringishConverter()  String? updatedBy, @LenientDateConverter()  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _FlagItem():
return $default(_that.key,_that.kind,_that.enabled,_that.rolloutPercent,_that.roles,_that.description,_that.updatedBy,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String kind,  bool enabled,  int? rolloutPercent,  List<String> roles,  String? description, @StringishConverter()  String? updatedBy, @LenientDateConverter()  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _FlagItem() when $default != null:
return $default(_that.key,_that.kind,_that.enabled,_that.rolloutPercent,_that.roles,_that.description,_that.updatedBy,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FlagItem extends FlagItem {
  const _FlagItem({required this.key, this.kind = 'flag', this.enabled = false, this.rolloutPercent, final  List<String> roles = const [], this.description, @StringishConverter() this.updatedBy, @LenientDateConverter() this.updatedAt}): _roles = roles,super._();
  factory _FlagItem.fromJson(Map<String, dynamic> json) => _$FlagItemFromJson(json);

@override final  String key;
@override@JsonKey() final  String kind;
@override@JsonKey() final  bool enabled;
@override final  int? rolloutPercent;
 final  List<String> _roles;
@override@JsonKey() List<String> get roles {
  if (_roles is EqualUnmodifiableListView) return _roles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_roles);
}

@override final  String? description;
@override@StringishConverter() final  String? updatedBy;
@override@LenientDateConverter() final  DateTime? updatedAt;

/// Create a copy of FlagItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FlagItemCopyWith<_FlagItem> get copyWith => __$FlagItemCopyWithImpl<_FlagItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FlagItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FlagItem&&(identical(other.key, key) || other.key == key)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.rolloutPercent, rolloutPercent) || other.rolloutPercent == rolloutPercent)&&const DeepCollectionEquality().equals(other._roles, _roles)&&(identical(other.description, description) || other.description == description)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,kind,enabled,rolloutPercent,const DeepCollectionEquality().hash(_roles),description,updatedBy,updatedAt);

@override
String toString() {
  return 'FlagItem(key: $key, kind: $kind, enabled: $enabled, rolloutPercent: $rolloutPercent, roles: $roles, description: $description, updatedBy: $updatedBy, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$FlagItemCopyWith<$Res> implements $FlagItemCopyWith<$Res> {
  factory _$FlagItemCopyWith(_FlagItem value, $Res Function(_FlagItem) _then) = __$FlagItemCopyWithImpl;
@override @useResult
$Res call({
 String key, String kind, bool enabled, int? rolloutPercent, List<String> roles, String? description,@StringishConverter() String? updatedBy,@LenientDateConverter() DateTime? updatedAt
});




}
/// @nodoc
class __$FlagItemCopyWithImpl<$Res>
    implements _$FlagItemCopyWith<$Res> {
  __$FlagItemCopyWithImpl(this._self, this._then);

  final _FlagItem _self;
  final $Res Function(_FlagItem) _then;

/// Create a copy of FlagItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? kind = null,Object? enabled = null,Object? rolloutPercent = freezed,Object? roles = null,Object? description = freezed,Object? updatedBy = freezed,Object? updatedAt = freezed,}) {
  return _then(_FlagItem(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,rolloutPercent: freezed == rolloutPercent ? _self.rolloutPercent : rolloutPercent // ignore: cast_nullable_to_non_nullable
as int?,roles: null == roles ? _self._roles : roles // ignore: cast_nullable_to_non_nullable
as List<String>,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,updatedBy: freezed == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$Integration {

 String get id; String get name; String get status; int? get latencyMs;@LenientDateConverter() DateTime? get checkedAt; String get mode; bool get enabled; String? get keyHint; String? get detail;
/// Create a copy of Integration
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IntegrationCopyWith<Integration> get copyWith => _$IntegrationCopyWithImpl<Integration>(this as Integration, _$identity);

  /// Serializes this Integration to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Integration&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.latencyMs, latencyMs) || other.latencyMs == latencyMs)&&(identical(other.checkedAt, checkedAt) || other.checkedAt == checkedAt)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.keyHint, keyHint) || other.keyHint == keyHint)&&(identical(other.detail, detail) || other.detail == detail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,status,latencyMs,checkedAt,mode,enabled,keyHint,detail);

@override
String toString() {
  return 'Integration(id: $id, name: $name, status: $status, latencyMs: $latencyMs, checkedAt: $checkedAt, mode: $mode, enabled: $enabled, keyHint: $keyHint, detail: $detail)';
}


}

/// @nodoc
abstract mixin class $IntegrationCopyWith<$Res>  {
  factory $IntegrationCopyWith(Integration value, $Res Function(Integration) _then) = _$IntegrationCopyWithImpl;
@useResult
$Res call({
 String id, String name, String status, int? latencyMs,@LenientDateConverter() DateTime? checkedAt, String mode, bool enabled, String? keyHint, String? detail
});




}
/// @nodoc
class _$IntegrationCopyWithImpl<$Res>
    implements $IntegrationCopyWith<$Res> {
  _$IntegrationCopyWithImpl(this._self, this._then);

  final Integration _self;
  final $Res Function(Integration) _then;

/// Create a copy of Integration
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? status = null,Object? latencyMs = freezed,Object? checkedAt = freezed,Object? mode = null,Object? enabled = null,Object? keyHint = freezed,Object? detail = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,latencyMs: freezed == latencyMs ? _self.latencyMs : latencyMs // ignore: cast_nullable_to_non_nullable
as int?,checkedAt: freezed == checkedAt ? _self.checkedAt : checkedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,keyHint: freezed == keyHint ? _self.keyHint : keyHint // ignore: cast_nullable_to_non_nullable
as String?,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Integration].
extension IntegrationPatterns on Integration {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Integration value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Integration() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Integration value)  $default,){
final _that = this;
switch (_that) {
case _Integration():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Integration value)?  $default,){
final _that = this;
switch (_that) {
case _Integration() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String status,  int? latencyMs, @LenientDateConverter()  DateTime? checkedAt,  String mode,  bool enabled,  String? keyHint,  String? detail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Integration() when $default != null:
return $default(_that.id,_that.name,_that.status,_that.latencyMs,_that.checkedAt,_that.mode,_that.enabled,_that.keyHint,_that.detail);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String status,  int? latencyMs, @LenientDateConverter()  DateTime? checkedAt,  String mode,  bool enabled,  String? keyHint,  String? detail)  $default,) {final _that = this;
switch (_that) {
case _Integration():
return $default(_that.id,_that.name,_that.status,_that.latencyMs,_that.checkedAt,_that.mode,_that.enabled,_that.keyHint,_that.detail);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String status,  int? latencyMs, @LenientDateConverter()  DateTime? checkedAt,  String mode,  bool enabled,  String? keyHint,  String? detail)?  $default,) {final _that = this;
switch (_that) {
case _Integration() when $default != null:
return $default(_that.id,_that.name,_that.status,_that.latencyMs,_that.checkedAt,_that.mode,_that.enabled,_that.keyHint,_that.detail);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Integration implements Integration {
  const _Integration({required this.id, required this.name, this.status = 'unconfigured', this.latencyMs, @LenientDateConverter() this.checkedAt, this.mode = 'sandbox', this.enabled = false, this.keyHint, this.detail});
  factory _Integration.fromJson(Map<String, dynamic> json) => _$IntegrationFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey() final  String status;
@override final  int? latencyMs;
@override@LenientDateConverter() final  DateTime? checkedAt;
@override@JsonKey() final  String mode;
@override@JsonKey() final  bool enabled;
@override final  String? keyHint;
@override final  String? detail;

/// Create a copy of Integration
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IntegrationCopyWith<_Integration> get copyWith => __$IntegrationCopyWithImpl<_Integration>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IntegrationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Integration&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.latencyMs, latencyMs) || other.latencyMs == latencyMs)&&(identical(other.checkedAt, checkedAt) || other.checkedAt == checkedAt)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.keyHint, keyHint) || other.keyHint == keyHint)&&(identical(other.detail, detail) || other.detail == detail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,status,latencyMs,checkedAt,mode,enabled,keyHint,detail);

@override
String toString() {
  return 'Integration(id: $id, name: $name, status: $status, latencyMs: $latencyMs, checkedAt: $checkedAt, mode: $mode, enabled: $enabled, keyHint: $keyHint, detail: $detail)';
}


}

/// @nodoc
abstract mixin class _$IntegrationCopyWith<$Res> implements $IntegrationCopyWith<$Res> {
  factory _$IntegrationCopyWith(_Integration value, $Res Function(_Integration) _then) = __$IntegrationCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String status, int? latencyMs,@LenientDateConverter() DateTime? checkedAt, String mode, bool enabled, String? keyHint, String? detail
});




}
/// @nodoc
class __$IntegrationCopyWithImpl<$Res>
    implements _$IntegrationCopyWith<$Res> {
  __$IntegrationCopyWithImpl(this._self, this._then);

  final _Integration _self;
  final $Res Function(_Integration) _then;

/// Create a copy of Integration
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? status = null,Object? latencyMs = freezed,Object? checkedAt = freezed,Object? mode = null,Object? enabled = null,Object? keyHint = freezed,Object? detail = freezed,}) {
  return _then(_Integration(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,latencyMs: freezed == latencyMs ? _self.latencyMs : latencyMs // ignore: cast_nullable_to_non_nullable
as int?,checkedAt: freezed == checkedAt ? _self.checkedAt : checkedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,keyHint: freezed == keyHint ? _self.keyHint : keyHint // ignore: cast_nullable_to_non_nullable
as String?,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Approval {

 String get id; String get action; String? get summary; Object? get payload;@StringishConverter() String? get requestedBy;@LenientDateConverter() DateTime? get requestedAt; String get status;@StringishConverter() String? get decidedBy;@LenientDateConverter() DateTime? get decidedAt; String? get decisionNote;
/// Create a copy of Approval
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApprovalCopyWith<Approval> get copyWith => _$ApprovalCopyWithImpl<Approval>(this as Approval, _$identity);

  /// Serializes this Approval to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Approval&&(identical(other.id, id) || other.id == id)&&(identical(other.action, action) || other.action == action)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.payload, payload)&&(identical(other.requestedBy, requestedBy) || other.requestedBy == requestedBy)&&(identical(other.requestedAt, requestedAt) || other.requestedAt == requestedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.decidedBy, decidedBy) || other.decidedBy == decidedBy)&&(identical(other.decidedAt, decidedAt) || other.decidedAt == decidedAt)&&(identical(other.decisionNote, decisionNote) || other.decisionNote == decisionNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,action,summary,const DeepCollectionEquality().hash(payload),requestedBy,requestedAt,status,decidedBy,decidedAt,decisionNote);

@override
String toString() {
  return 'Approval(id: $id, action: $action, summary: $summary, payload: $payload, requestedBy: $requestedBy, requestedAt: $requestedAt, status: $status, decidedBy: $decidedBy, decidedAt: $decidedAt, decisionNote: $decisionNote)';
}


}

/// @nodoc
abstract mixin class $ApprovalCopyWith<$Res>  {
  factory $ApprovalCopyWith(Approval value, $Res Function(Approval) _then) = _$ApprovalCopyWithImpl;
@useResult
$Res call({
 String id, String action, String? summary, Object? payload,@StringishConverter() String? requestedBy,@LenientDateConverter() DateTime? requestedAt, String status,@StringishConverter() String? decidedBy,@LenientDateConverter() DateTime? decidedAt, String? decisionNote
});




}
/// @nodoc
class _$ApprovalCopyWithImpl<$Res>
    implements $ApprovalCopyWith<$Res> {
  _$ApprovalCopyWithImpl(this._self, this._then);

  final Approval _self;
  final $Res Function(Approval) _then;

/// Create a copy of Approval
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? action = null,Object? summary = freezed,Object? payload = freezed,Object? requestedBy = freezed,Object? requestedAt = freezed,Object? status = null,Object? decidedBy = freezed,Object? decidedAt = freezed,Object? decisionNote = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,payload: freezed == payload ? _self.payload : payload ,requestedBy: freezed == requestedBy ? _self.requestedBy : requestedBy // ignore: cast_nullable_to_non_nullable
as String?,requestedAt: freezed == requestedAt ? _self.requestedAt : requestedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,decidedBy: freezed == decidedBy ? _self.decidedBy : decidedBy // ignore: cast_nullable_to_non_nullable
as String?,decidedAt: freezed == decidedAt ? _self.decidedAt : decidedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,decisionNote: freezed == decisionNote ? _self.decisionNote : decisionNote // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Approval].
extension ApprovalPatterns on Approval {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Approval value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Approval() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Approval value)  $default,){
final _that = this;
switch (_that) {
case _Approval():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Approval value)?  $default,){
final _that = this;
switch (_that) {
case _Approval() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String action,  String? summary,  Object? payload, @StringishConverter()  String? requestedBy, @LenientDateConverter()  DateTime? requestedAt,  String status, @StringishConverter()  String? decidedBy, @LenientDateConverter()  DateTime? decidedAt,  String? decisionNote)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Approval() when $default != null:
return $default(_that.id,_that.action,_that.summary,_that.payload,_that.requestedBy,_that.requestedAt,_that.status,_that.decidedBy,_that.decidedAt,_that.decisionNote);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String action,  String? summary,  Object? payload, @StringishConverter()  String? requestedBy, @LenientDateConverter()  DateTime? requestedAt,  String status, @StringishConverter()  String? decidedBy, @LenientDateConverter()  DateTime? decidedAt,  String? decisionNote)  $default,) {final _that = this;
switch (_that) {
case _Approval():
return $default(_that.id,_that.action,_that.summary,_that.payload,_that.requestedBy,_that.requestedAt,_that.status,_that.decidedBy,_that.decidedAt,_that.decisionNote);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String action,  String? summary,  Object? payload, @StringishConverter()  String? requestedBy, @LenientDateConverter()  DateTime? requestedAt,  String status, @StringishConverter()  String? decidedBy, @LenientDateConverter()  DateTime? decidedAt,  String? decisionNote)?  $default,) {final _that = this;
switch (_that) {
case _Approval() when $default != null:
return $default(_that.id,_that.action,_that.summary,_that.payload,_that.requestedBy,_that.requestedAt,_that.status,_that.decidedBy,_that.decidedAt,_that.decisionNote);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Approval implements Approval {
  const _Approval({required this.id, required this.action, this.summary, this.payload, @StringishConverter() this.requestedBy, @LenientDateConverter() this.requestedAt, this.status = 'pending', @StringishConverter() this.decidedBy, @LenientDateConverter() this.decidedAt, this.decisionNote});
  factory _Approval.fromJson(Map<String, dynamic> json) => _$ApprovalFromJson(json);

@override final  String id;
@override final  String action;
@override final  String? summary;
@override final  Object? payload;
@override@StringishConverter() final  String? requestedBy;
@override@LenientDateConverter() final  DateTime? requestedAt;
@override@JsonKey() final  String status;
@override@StringishConverter() final  String? decidedBy;
@override@LenientDateConverter() final  DateTime? decidedAt;
@override final  String? decisionNote;

/// Create a copy of Approval
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApprovalCopyWith<_Approval> get copyWith => __$ApprovalCopyWithImpl<_Approval>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApprovalToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Approval&&(identical(other.id, id) || other.id == id)&&(identical(other.action, action) || other.action == action)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.payload, payload)&&(identical(other.requestedBy, requestedBy) || other.requestedBy == requestedBy)&&(identical(other.requestedAt, requestedAt) || other.requestedAt == requestedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.decidedBy, decidedBy) || other.decidedBy == decidedBy)&&(identical(other.decidedAt, decidedAt) || other.decidedAt == decidedAt)&&(identical(other.decisionNote, decisionNote) || other.decisionNote == decisionNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,action,summary,const DeepCollectionEquality().hash(payload),requestedBy,requestedAt,status,decidedBy,decidedAt,decisionNote);

@override
String toString() {
  return 'Approval(id: $id, action: $action, summary: $summary, payload: $payload, requestedBy: $requestedBy, requestedAt: $requestedAt, status: $status, decidedBy: $decidedBy, decidedAt: $decidedAt, decisionNote: $decisionNote)';
}


}

/// @nodoc
abstract mixin class _$ApprovalCopyWith<$Res> implements $ApprovalCopyWith<$Res> {
  factory _$ApprovalCopyWith(_Approval value, $Res Function(_Approval) _then) = __$ApprovalCopyWithImpl;
@override @useResult
$Res call({
 String id, String action, String? summary, Object? payload,@StringishConverter() String? requestedBy,@LenientDateConverter() DateTime? requestedAt, String status,@StringishConverter() String? decidedBy,@LenientDateConverter() DateTime? decidedAt, String? decisionNote
});




}
/// @nodoc
class __$ApprovalCopyWithImpl<$Res>
    implements _$ApprovalCopyWith<$Res> {
  __$ApprovalCopyWithImpl(this._self, this._then);

  final _Approval _self;
  final $Res Function(_Approval) _then;

/// Create a copy of Approval
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? action = null,Object? summary = freezed,Object? payload = freezed,Object? requestedBy = freezed,Object? requestedAt = freezed,Object? status = null,Object? decidedBy = freezed,Object? decidedAt = freezed,Object? decisionNote = freezed,}) {
  return _then(_Approval(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,payload: freezed == payload ? _self.payload : payload ,requestedBy: freezed == requestedBy ? _self.requestedBy : requestedBy // ignore: cast_nullable_to_non_nullable
as String?,requestedAt: freezed == requestedAt ? _self.requestedAt : requestedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,decidedBy: freezed == decidedBy ? _self.decidedBy : decidedBy // ignore: cast_nullable_to_non_nullable
as String?,decidedAt: freezed == decidedAt ? _self.decidedAt : decidedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,decisionNote: freezed == decisionNote ? _self.decisionNote : decisionNote // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AuditEvent {

 String get id;@StringishConverter() String? get actor; String? get actorRole; String get action; String? get entityType;@StringishConverter() String? get entityId; Object? get before; Object? get after; String? get reason;@StringishConverter() String? get device; String? get correlationId;@LenientDateConverter() DateTime? get timestamp;
/// Create a copy of AuditEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuditEventCopyWith<AuditEvent> get copyWith => _$AuditEventCopyWithImpl<AuditEvent>(this as AuditEvent, _$identity);

  /// Serializes this AuditEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuditEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.actor, actor) || other.actor == actor)&&(identical(other.actorRole, actorRole) || other.actorRole == actorRole)&&(identical(other.action, action) || other.action == action)&&(identical(other.entityType, entityType) || other.entityType == entityType)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&const DeepCollectionEquality().equals(other.before, before)&&const DeepCollectionEquality().equals(other.after, after)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.device, device) || other.device == device)&&(identical(other.correlationId, correlationId) || other.correlationId == correlationId)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,actor,actorRole,action,entityType,entityId,const DeepCollectionEquality().hash(before),const DeepCollectionEquality().hash(after),reason,device,correlationId,timestamp);

@override
String toString() {
  return 'AuditEvent(id: $id, actor: $actor, actorRole: $actorRole, action: $action, entityType: $entityType, entityId: $entityId, before: $before, after: $after, reason: $reason, device: $device, correlationId: $correlationId, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $AuditEventCopyWith<$Res>  {
  factory $AuditEventCopyWith(AuditEvent value, $Res Function(AuditEvent) _then) = _$AuditEventCopyWithImpl;
@useResult
$Res call({
 String id,@StringishConverter() String? actor, String? actorRole, String action, String? entityType,@StringishConverter() String? entityId, Object? before, Object? after, String? reason,@StringishConverter() String? device, String? correlationId,@LenientDateConverter() DateTime? timestamp
});




}
/// @nodoc
class _$AuditEventCopyWithImpl<$Res>
    implements $AuditEventCopyWith<$Res> {
  _$AuditEventCopyWithImpl(this._self, this._then);

  final AuditEvent _self;
  final $Res Function(AuditEvent) _then;

/// Create a copy of AuditEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? actor = freezed,Object? actorRole = freezed,Object? action = null,Object? entityType = freezed,Object? entityId = freezed,Object? before = freezed,Object? after = freezed,Object? reason = freezed,Object? device = freezed,Object? correlationId = freezed,Object? timestamp = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,actor: freezed == actor ? _self.actor : actor // ignore: cast_nullable_to_non_nullable
as String?,actorRole: freezed == actorRole ? _self.actorRole : actorRole // ignore: cast_nullable_to_non_nullable
as String?,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,entityType: freezed == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as String?,entityId: freezed == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String?,before: freezed == before ? _self.before : before ,after: freezed == after ? _self.after : after ,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,device: freezed == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as String?,correlationId: freezed == correlationId ? _self.correlationId : correlationId // ignore: cast_nullable_to_non_nullable
as String?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuditEvent].
extension AuditEventPatterns on AuditEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuditEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuditEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuditEvent value)  $default,){
final _that = this;
switch (_that) {
case _AuditEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuditEvent value)?  $default,){
final _that = this;
switch (_that) {
case _AuditEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @StringishConverter()  String? actor,  String? actorRole,  String action,  String? entityType, @StringishConverter()  String? entityId,  Object? before,  Object? after,  String? reason, @StringishConverter()  String? device,  String? correlationId, @LenientDateConverter()  DateTime? timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuditEvent() when $default != null:
return $default(_that.id,_that.actor,_that.actorRole,_that.action,_that.entityType,_that.entityId,_that.before,_that.after,_that.reason,_that.device,_that.correlationId,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @StringishConverter()  String? actor,  String? actorRole,  String action,  String? entityType, @StringishConverter()  String? entityId,  Object? before,  Object? after,  String? reason, @StringishConverter()  String? device,  String? correlationId, @LenientDateConverter()  DateTime? timestamp)  $default,) {final _that = this;
switch (_that) {
case _AuditEvent():
return $default(_that.id,_that.actor,_that.actorRole,_that.action,_that.entityType,_that.entityId,_that.before,_that.after,_that.reason,_that.device,_that.correlationId,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @StringishConverter()  String? actor,  String? actorRole,  String action,  String? entityType, @StringishConverter()  String? entityId,  Object? before,  Object? after,  String? reason, @StringishConverter()  String? device,  String? correlationId, @LenientDateConverter()  DateTime? timestamp)?  $default,) {final _that = this;
switch (_that) {
case _AuditEvent() when $default != null:
return $default(_that.id,_that.actor,_that.actorRole,_that.action,_that.entityType,_that.entityId,_that.before,_that.after,_that.reason,_that.device,_that.correlationId,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuditEvent implements AuditEvent {
  const _AuditEvent({required this.id, @StringishConverter() this.actor, this.actorRole, required this.action, this.entityType, @StringishConverter() this.entityId, this.before, this.after, this.reason, @StringishConverter() this.device, this.correlationId, @LenientDateConverter() this.timestamp});
  factory _AuditEvent.fromJson(Map<String, dynamic> json) => _$AuditEventFromJson(json);

@override final  String id;
@override@StringishConverter() final  String? actor;
@override final  String? actorRole;
@override final  String action;
@override final  String? entityType;
@override@StringishConverter() final  String? entityId;
@override final  Object? before;
@override final  Object? after;
@override final  String? reason;
@override@StringishConverter() final  String? device;
@override final  String? correlationId;
@override@LenientDateConverter() final  DateTime? timestamp;

/// Create a copy of AuditEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuditEventCopyWith<_AuditEvent> get copyWith => __$AuditEventCopyWithImpl<_AuditEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuditEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuditEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.actor, actor) || other.actor == actor)&&(identical(other.actorRole, actorRole) || other.actorRole == actorRole)&&(identical(other.action, action) || other.action == action)&&(identical(other.entityType, entityType) || other.entityType == entityType)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&const DeepCollectionEquality().equals(other.before, before)&&const DeepCollectionEquality().equals(other.after, after)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.device, device) || other.device == device)&&(identical(other.correlationId, correlationId) || other.correlationId == correlationId)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,actor,actorRole,action,entityType,entityId,const DeepCollectionEquality().hash(before),const DeepCollectionEquality().hash(after),reason,device,correlationId,timestamp);

@override
String toString() {
  return 'AuditEvent(id: $id, actor: $actor, actorRole: $actorRole, action: $action, entityType: $entityType, entityId: $entityId, before: $before, after: $after, reason: $reason, device: $device, correlationId: $correlationId, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$AuditEventCopyWith<$Res> implements $AuditEventCopyWith<$Res> {
  factory _$AuditEventCopyWith(_AuditEvent value, $Res Function(_AuditEvent) _then) = __$AuditEventCopyWithImpl;
@override @useResult
$Res call({
 String id,@StringishConverter() String? actor, String? actorRole, String action, String? entityType,@StringishConverter() String? entityId, Object? before, Object? after, String? reason,@StringishConverter() String? device, String? correlationId,@LenientDateConverter() DateTime? timestamp
});




}
/// @nodoc
class __$AuditEventCopyWithImpl<$Res>
    implements _$AuditEventCopyWith<$Res> {
  __$AuditEventCopyWithImpl(this._self, this._then);

  final _AuditEvent _self;
  final $Res Function(_AuditEvent) _then;

/// Create a copy of AuditEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? actor = freezed,Object? actorRole = freezed,Object? action = null,Object? entityType = freezed,Object? entityId = freezed,Object? before = freezed,Object? after = freezed,Object? reason = freezed,Object? device = freezed,Object? correlationId = freezed,Object? timestamp = freezed,}) {
  return _then(_AuditEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,actor: freezed == actor ? _self.actor : actor // ignore: cast_nullable_to_non_nullable
as String?,actorRole: freezed == actorRole ? _self.actorRole : actorRole // ignore: cast_nullable_to_non_nullable
as String?,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,entityType: freezed == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as String?,entityId: freezed == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String?,before: freezed == before ? _self.before : before ,after: freezed == after ? _self.after : after ,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,device: freezed == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as String?,correlationId: freezed == correlationId ? _self.correlationId : correlationId // ignore: cast_nullable_to_non_nullable
as String?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$SearchResult {

 String get type; String get id; String get title; String? get subtitle; String? get route;
/// Create a copy of SearchResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchResultCopyWith<SearchResult> get copyWith => _$SearchResultCopyWithImpl<SearchResult>(this as SearchResult, _$identity);

  /// Serializes this SearchResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchResult&&(identical(other.type, type) || other.type == type)&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.route, route) || other.route == route));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,id,title,subtitle,route);

@override
String toString() {
  return 'SearchResult(type: $type, id: $id, title: $title, subtitle: $subtitle, route: $route)';
}


}

/// @nodoc
abstract mixin class $SearchResultCopyWith<$Res>  {
  factory $SearchResultCopyWith(SearchResult value, $Res Function(SearchResult) _then) = _$SearchResultCopyWithImpl;
@useResult
$Res call({
 String type, String id, String title, String? subtitle, String? route
});




}
/// @nodoc
class _$SearchResultCopyWithImpl<$Res>
    implements $SearchResultCopyWith<$Res> {
  _$SearchResultCopyWithImpl(this._self, this._then);

  final SearchResult _self;
  final $Res Function(SearchResult) _then;

/// Create a copy of SearchResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? id = null,Object? title = null,Object? subtitle = freezed,Object? route = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,route: freezed == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchResult].
extension SearchResultPatterns on SearchResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchResult value)  $default,){
final _that = this;
switch (_that) {
case _SearchResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchResult value)?  $default,){
final _that = this;
switch (_that) {
case _SearchResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String id,  String title,  String? subtitle,  String? route)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchResult() when $default != null:
return $default(_that.type,_that.id,_that.title,_that.subtitle,_that.route);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String id,  String title,  String? subtitle,  String? route)  $default,) {final _that = this;
switch (_that) {
case _SearchResult():
return $default(_that.type,_that.id,_that.title,_that.subtitle,_that.route);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String id,  String title,  String? subtitle,  String? route)?  $default,) {final _that = this;
switch (_that) {
case _SearchResult() when $default != null:
return $default(_that.type,_that.id,_that.title,_that.subtitle,_that.route);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchResult implements SearchResult {
  const _SearchResult({required this.type, required this.id, required this.title, this.subtitle, this.route});
  factory _SearchResult.fromJson(Map<String, dynamic> json) => _$SearchResultFromJson(json);

@override final  String type;
@override final  String id;
@override final  String title;
@override final  String? subtitle;
@override final  String? route;

/// Create a copy of SearchResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchResultCopyWith<_SearchResult> get copyWith => __$SearchResultCopyWithImpl<_SearchResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchResult&&(identical(other.type, type) || other.type == type)&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.route, route) || other.route == route));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,id,title,subtitle,route);

@override
String toString() {
  return 'SearchResult(type: $type, id: $id, title: $title, subtitle: $subtitle, route: $route)';
}


}

/// @nodoc
abstract mixin class _$SearchResultCopyWith<$Res> implements $SearchResultCopyWith<$Res> {
  factory _$SearchResultCopyWith(_SearchResult value, $Res Function(_SearchResult) _then) = __$SearchResultCopyWithImpl;
@override @useResult
$Res call({
 String type, String id, String title, String? subtitle, String? route
});




}
/// @nodoc
class __$SearchResultCopyWithImpl<$Res>
    implements _$SearchResultCopyWith<$Res> {
  __$SearchResultCopyWithImpl(this._self, this._then);

  final _SearchResult _self;
  final $Res Function(_SearchResult) _then;

/// Create a copy of SearchResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? id = null,Object? title = null,Object? subtitle = freezed,Object? route = freezed,}) {
  return _then(_SearchResult(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,route: freezed == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
