// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:auto_route/auto_route.dart' as _i43;
import 'package:dahab_ops/core/router/more_page.dart' as _i23;
import 'package:dahab_ops/core/router/tabs_page.dart' as _i40;
import 'package:dahab_ops/features/access/presentation/invite_staff_page.dart'
    as _i18;
import 'package:dahab_ops/features/access/presentation/role_editor_page.dart'
    as _i31;
import 'package:dahab_ops/features/access/presentation/user_detail_page.dart'
    as _i41;
import 'package:dahab_ops/features/access/presentation/users_page.dart' as _i42;
import 'package:dahab_ops/features/auth/presentation/login/login_page.dart'
    as _i21;
import 'package:dahab_ops/features/auth/presentation/splash/splash_page.dart'
    as _i34;
import 'package:dahab_ops/features/booking/presentation/booking_detail_page.dart'
    as _i4;
import 'package:dahab_ops/features/catalog/presentation/catalog_children_pages.dart'
    as _i5;
import 'package:dahab_ops/features/catalog/presentation/catalog_editor_pages.dart'
    as _i6;
import 'package:dahab_ops/features/catalog/presentation/catalog_home_page.dart'
    as _i7;
import 'package:dahab_ops/features/catalog/presentation/catalog_list_page.dart'
    as _i8;
import 'package:dahab_ops/features/cms/cms_pages.dart' as _i9;
import 'package:dahab_ops/features/cms/presentation/homepage_editor_page.dart'
    as _i16;
import 'package:dahab_ops/features/cms/presentation/navigation_editor_page.dart'
    as _i25;
import 'package:dahab_ops/features/cms/presentation/programmes_pages.dart'
    as _i28;
import 'package:dahab_ops/features/control/presentation/app_experience_page.dart'
    as _i1;
import 'package:dahab_ops/features/control/presentation/approvals_page.dart'
    as _i2;
import 'package:dahab_ops/features/control/presentation/audit_page.dart' as _i3;
import 'package:dahab_ops/features/control/presentation/control_page.dart'
    as _i11;
import 'package:dahab_ops/features/control/presentation/flags_page.dart'
    as _i14;
import 'package:dahab_ops/features/control/presentation/integrations_page.dart'
    as _i17;
import 'package:dahab_ops/features/control/presentation/maintenance_page.dart'
    as _i22;
import 'package:dahab_ops/features/control/presentation/my_devices_page.dart'
    as _i24;
import 'package:dahab_ops/features/control/presentation/settings_page.dart'
    as _i33;
import 'package:dahab_ops/features/ops/commerce/commerce_page.dart' as _i10;
import 'package:dahab_ops/features/ops/dining/dining_page.dart' as _i12;
import 'package:dahab_ops/features/ops/exceptions/exceptions_page.dart' as _i13;
import 'package:dahab_ops/features/ops/insight/insight_pages.dart' as _i19;
import 'package:dahab_ops/features/ops/live/live_page.dart' as _i20;
import 'package:dahab_ops/features/ops/messaging/messaging_pages.dart' as _i26;
import 'package:dahab_ops/features/ops/pricing/pricing_page.dart' as _i27;
import 'package:dahab_ops/features/ops/stays/stays_page.dart' as _i35;
import 'package:dahab_ops/features/ops/suppliers/suppliers_page.dart' as _i38;
import 'package:dahab_ops/features/ops/support/support_page.dart' as _i39;
import 'package:dahab_ops/features/ops/system/system_pages.dart' as _i15;
import 'package:dahab_ops/features/pulse/presentation/pulse_page.dart' as _i29;
import 'package:dahab_ops/features/queue/presentation/queue_page.dart' as _i30;
import 'package:dahab_ops/features/search/presentation/search_page.dart'
    as _i32;
import 'package:dahab_ops/features/supplier/presentation/supplier_inbox_page.dart'
    as _i37;
import 'package:dahab_ops/features/supplier/presentation/supplier_portal_pages.dart'
    as _i36;
import 'package:flutter/material.dart' as _i44;

/// generated route for
/// [_i1.AppExperiencePage]
class AppExperienceRoute extends _i43.PageRouteInfo<void> {
  const AppExperienceRoute({List<_i43.PageRouteInfo>? children})
    : super(AppExperienceRoute.name, initialChildren: children);

  static const String name = 'AppExperienceRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i1.AppExperiencePage();
    },
  );
}

/// generated route for
/// [_i2.ApprovalsPage]
class ApprovalsRoute extends _i43.PageRouteInfo<void> {
  const ApprovalsRoute({List<_i43.PageRouteInfo>? children})
    : super(ApprovalsRoute.name, initialChildren: children);

  static const String name = 'ApprovalsRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i2.ApprovalsPage();
    },
  );
}

/// generated route for
/// [_i3.AuditPage]
class AuditRoute extends _i43.PageRouteInfo<AuditRouteArgs> {
  AuditRoute({
    _i44.Key? key,
    bool ops = false,
    String? entityType,
    String? entityId,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         AuditRoute.name,
         args: AuditRouteArgs(
           key: key,
           ops: ops,
           entityType: entityType,
           entityId: entityId,
         ),
         initialChildren: children,
       );

  static const String name = 'AuditRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AuditRouteArgs>(
        orElse: () => const AuditRouteArgs(),
      );
      return _i3.AuditPage(
        key: args.key,
        ops: args.ops,
        entityType: args.entityType,
        entityId: args.entityId,
      );
    },
  );
}

class AuditRouteArgs {
  const AuditRouteArgs({
    this.key,
    this.ops = false,
    this.entityType,
    this.entityId,
  });

  final _i44.Key? key;

  final bool ops;

  final String? entityType;

  final String? entityId;

  @override
  String toString() {
    return 'AuditRouteArgs{key: $key, ops: $ops, entityType: $entityType, entityId: $entityId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AuditRouteArgs) return false;
    return key == other.key &&
        ops == other.ops &&
        entityType == other.entityType &&
        entityId == other.entityId;
  }

  @override
  int get hashCode =>
      key.hashCode ^ ops.hashCode ^ entityType.hashCode ^ entityId.hashCode;
}

/// generated route for
/// [_i4.BookingDetailPage]
class BookingDetailRoute extends _i43.PageRouteInfo<BookingDetailRouteArgs> {
  BookingDetailRoute({
    _i44.Key? key,
    required String ref,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         BookingDetailRoute.name,
         args: BookingDetailRouteArgs(key: key, ref: ref),
         rawPathParams: {'ref': ref},
         initialChildren: children,
       );

  static const String name = 'BookingDetailRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<BookingDetailRouteArgs>(
        orElse: () => BookingDetailRouteArgs(ref: pathParams.getString('ref')),
      );
      return _i4.BookingDetailPage(key: args.key, ref: args.ref);
    },
  );
}

class BookingDetailRouteArgs {
  const BookingDetailRouteArgs({this.key, required this.ref});

  final _i44.Key? key;

  final String ref;

  @override
  String toString() {
    return 'BookingDetailRouteArgs{key: $key, ref: $ref}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BookingDetailRouteArgs) return false;
    return key == other.key && ref == other.ref;
  }

  @override
  int get hashCode => key.hashCode ^ ref.hashCode;
}

/// generated route for
/// [_i5.CatalogChildrenPage]
class CatalogChildrenRoute
    extends _i43.PageRouteInfo<CatalogChildrenRouteArgs> {
  CatalogChildrenRoute({
    _i44.Key? key,
    required String type,
    required String id,
    required String child,
    String? itemType,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         CatalogChildrenRoute.name,
         args: CatalogChildrenRouteArgs(
           key: key,
           type: type,
           id: id,
           child: child,
           itemType: itemType,
         ),
         rawPathParams: {'type': type, 'id': id, 'child': child},
         initialChildren: children,
       );

  static const String name = 'CatalogChildrenRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<CatalogChildrenRouteArgs>(
        orElse: () => CatalogChildrenRouteArgs(
          type: pathParams.getString('type'),
          id: pathParams.getString('id'),
          child: pathParams.getString('child'),
        ),
      );
      return _i5.CatalogChildrenPage(
        key: args.key,
        type: args.type,
        id: args.id,
        child: args.child,
        itemType: args.itemType,
      );
    },
  );
}

class CatalogChildrenRouteArgs {
  const CatalogChildrenRouteArgs({
    this.key,
    required this.type,
    required this.id,
    required this.child,
    this.itemType,
  });

  final _i44.Key? key;

  final String type;

  final String id;

  final String child;

  final String? itemType;

  @override
  String toString() {
    return 'CatalogChildrenRouteArgs{key: $key, type: $type, id: $id, child: $child, itemType: $itemType}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CatalogChildrenRouteArgs) return false;
    return key == other.key &&
        type == other.type &&
        id == other.id &&
        child == other.child &&
        itemType == other.itemType;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      type.hashCode ^
      id.hashCode ^
      child.hashCode ^
      itemType.hashCode;
}

/// generated route for
/// [_i6.CatalogCreatePage]
class CatalogCreateRoute extends _i43.PageRouteInfo<CatalogCreateRouteArgs> {
  CatalogCreateRoute({
    _i44.Key? key,
    required String type,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         CatalogCreateRoute.name,
         args: CatalogCreateRouteArgs(key: key, type: type),
         rawPathParams: {'type': type},
         initialChildren: children,
       );

  static const String name = 'CatalogCreateRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<CatalogCreateRouteArgs>(
        orElse: () =>
            CatalogCreateRouteArgs(type: pathParams.getString('type')),
      );
      return _i6.CatalogCreatePage(key: args.key, type: args.type);
    },
  );
}

class CatalogCreateRouteArgs {
  const CatalogCreateRouteArgs({this.key, required this.type});

  final _i44.Key? key;

  final String type;

  @override
  String toString() {
    return 'CatalogCreateRouteArgs{key: $key, type: $type}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CatalogCreateRouteArgs) return false;
    return key == other.key && type == other.type;
  }

  @override
  int get hashCode => key.hashCode ^ type.hashCode;
}

/// generated route for
/// [_i6.CatalogEditPage]
class CatalogEditRoute extends _i43.PageRouteInfo<CatalogEditRouteArgs> {
  CatalogEditRoute({
    _i44.Key? key,
    required String type,
    required String id,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         CatalogEditRoute.name,
         args: CatalogEditRouteArgs(key: key, type: type, id: id),
         rawPathParams: {'type': type, 'id': id},
         initialChildren: children,
       );

  static const String name = 'CatalogEditRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<CatalogEditRouteArgs>(
        orElse: () => CatalogEditRouteArgs(
          type: pathParams.getString('type'),
          id: pathParams.getString('id'),
        ),
      );
      return _i6.CatalogEditPage(key: args.key, type: args.type, id: args.id);
    },
  );
}

class CatalogEditRouteArgs {
  const CatalogEditRouteArgs({this.key, required this.type, required this.id});

  final _i44.Key? key;

  final String type;

  final String id;

  @override
  String toString() {
    return 'CatalogEditRouteArgs{key: $key, type: $type, id: $id}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CatalogEditRouteArgs) return false;
    return key == other.key && type == other.type && id == other.id;
  }

  @override
  int get hashCode => key.hashCode ^ type.hashCode ^ id.hashCode;
}

/// generated route for
/// [_i7.CatalogHomePage]
class CatalogHomeRoute extends _i43.PageRouteInfo<void> {
  const CatalogHomeRoute({List<_i43.PageRouteInfo>? children})
    : super(CatalogHomeRoute.name, initialChildren: children);

  static const String name = 'CatalogHomeRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i7.CatalogHomePage();
    },
  );
}

/// generated route for
/// [_i8.CatalogListPage]
class CatalogListRoute extends _i43.PageRouteInfo<CatalogListRouteArgs> {
  CatalogListRoute({
    _i44.Key? key,
    required String type,
    String? initialStatus,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         CatalogListRoute.name,
         args: CatalogListRouteArgs(
           key: key,
           type: type,
           initialStatus: initialStatus,
         ),
         rawPathParams: {'type': type},
         initialChildren: children,
       );

  static const String name = 'CatalogListRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<CatalogListRouteArgs>(
        orElse: () => CatalogListRouteArgs(type: pathParams.getString('type')),
      );
      return _i8.CatalogListPage(
        key: args.key,
        type: args.type,
        initialStatus: args.initialStatus,
      );
    },
  );
}

class CatalogListRouteArgs {
  const CatalogListRouteArgs({
    this.key,
    required this.type,
    this.initialStatus,
  });

  final _i44.Key? key;

  final String type;

  final String? initialStatus;

  @override
  String toString() {
    return 'CatalogListRouteArgs{key: $key, type: $type, initialStatus: $initialStatus}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CatalogListRouteArgs) return false;
    return key == other.key &&
        type == other.type &&
        initialStatus == other.initialStatus;
  }

  @override
  int get hashCode => key.hashCode ^ type.hashCode ^ initialStatus.hashCode;
}

/// generated route for
/// [_i5.CatalogMenuPage]
class CatalogMenuRoute extends _i43.PageRouteInfo<CatalogMenuRouteArgs> {
  CatalogMenuRoute({
    _i44.Key? key,
    required String restaurantId,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         CatalogMenuRoute.name,
         args: CatalogMenuRouteArgs(key: key, restaurantId: restaurantId),
         rawPathParams: {'id': restaurantId},
         initialChildren: children,
       );

  static const String name = 'CatalogMenuRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<CatalogMenuRouteArgs>(
        orElse: () =>
            CatalogMenuRouteArgs(restaurantId: pathParams.getString('id')),
      );
      return _i5.CatalogMenuPage(
        key: args.key,
        restaurantId: args.restaurantId,
      );
    },
  );
}

class CatalogMenuRouteArgs {
  const CatalogMenuRouteArgs({this.key, required this.restaurantId});

  final _i44.Key? key;

  final String restaurantId;

  @override
  String toString() {
    return 'CatalogMenuRouteArgs{key: $key, restaurantId: $restaurantId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CatalogMenuRouteArgs) return false;
    return key == other.key && restaurantId == other.restaurantId;
  }

  @override
  int get hashCode => key.hashCode ^ restaurantId.hashCode;
}

/// generated route for
/// [_i5.CatalogRatesPage]
class CatalogRatesRoute extends _i43.PageRouteInfo<CatalogRatesRouteArgs> {
  CatalogRatesRoute({
    _i44.Key? key,
    required String hotelId,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         CatalogRatesRoute.name,
         args: CatalogRatesRouteArgs(key: key, hotelId: hotelId),
         rawPathParams: {'id': hotelId},
         initialChildren: children,
       );

  static const String name = 'CatalogRatesRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<CatalogRatesRouteArgs>(
        orElse: () =>
            CatalogRatesRouteArgs(hotelId: pathParams.getString('id')),
      );
      return _i5.CatalogRatesPage(key: args.key, hotelId: args.hotelId);
    },
  );
}

class CatalogRatesRouteArgs {
  const CatalogRatesRouteArgs({this.key, required this.hotelId});

  final _i44.Key? key;

  final String hotelId;

  @override
  String toString() {
    return 'CatalogRatesRouteArgs{key: $key, hotelId: $hotelId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CatalogRatesRouteArgs) return false;
    return key == other.key && hotelId == other.hotelId;
  }

  @override
  int get hashCode => key.hashCode ^ hotelId.hashCode;
}

/// generated route for
/// [_i5.CatalogSlotsPage]
class CatalogSlotsRoute extends _i43.PageRouteInfo<CatalogSlotsRouteArgs> {
  CatalogSlotsRoute({
    _i44.Key? key,
    required String activityId,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         CatalogSlotsRoute.name,
         args: CatalogSlotsRouteArgs(key: key, activityId: activityId),
         rawPathParams: {'id': activityId},
         initialChildren: children,
       );

  static const String name = 'CatalogSlotsRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<CatalogSlotsRouteArgs>(
        orElse: () =>
            CatalogSlotsRouteArgs(activityId: pathParams.getString('id')),
      );
      return _i5.CatalogSlotsPage(key: args.key, activityId: args.activityId);
    },
  );
}

class CatalogSlotsRouteArgs {
  const CatalogSlotsRouteArgs({this.key, required this.activityId});

  final _i44.Key? key;

  final String activityId;

  @override
  String toString() {
    return 'CatalogSlotsRouteArgs{key: $key, activityId: $activityId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CatalogSlotsRouteArgs) return false;
    return key == other.key && activityId == other.activityId;
  }

  @override
  int get hashCode => key.hashCode ^ activityId.hashCode;
}

/// generated route for
/// [_i9.CmsEditorPage]
class CmsEditorRoute extends _i43.PageRouteInfo<CmsEditorRouteArgs> {
  CmsEditorRoute({
    _i44.Key? key,
    required String pageId,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         CmsEditorRoute.name,
         args: CmsEditorRouteArgs(key: key, pageId: pageId),
         rawPathParams: {'id': pageId},
         initialChildren: children,
       );

  static const String name = 'CmsEditorRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<CmsEditorRouteArgs>(
        orElse: () => CmsEditorRouteArgs(pageId: pathParams.getString('id')),
      );
      return _i9.CmsEditorPage(key: args.key, pageId: args.pageId);
    },
  );
}

class CmsEditorRouteArgs {
  const CmsEditorRouteArgs({this.key, required this.pageId});

  final _i44.Key? key;

  final String pageId;

  @override
  String toString() {
    return 'CmsEditorRouteArgs{key: $key, pageId: $pageId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CmsEditorRouteArgs) return false;
    return key == other.key && pageId == other.pageId;
  }

  @override
  int get hashCode => key.hashCode ^ pageId.hashCode;
}

/// generated route for
/// [_i9.CmsListPage]
class CmsListRoute extends _i43.PageRouteInfo<void> {
  const CmsListRoute({List<_i43.PageRouteInfo>? children})
    : super(CmsListRoute.name, initialChildren: children);

  static const String name = 'CmsListRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i9.CmsListPage();
    },
  );
}

/// generated route for
/// [_i10.CommercePage]
class CommerceRoute extends _i43.PageRouteInfo<void> {
  const CommerceRoute({List<_i43.PageRouteInfo>? children})
    : super(CommerceRoute.name, initialChildren: children);

  static const String name = 'CommerceRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i10.CommercePage();
    },
  );
}

/// generated route for
/// [_i11.ControlPage]
class ControlRoute extends _i43.PageRouteInfo<void> {
  const ControlRoute({List<_i43.PageRouteInfo>? children})
    : super(ControlRoute.name, initialChildren: children);

  static const String name = 'ControlRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i11.ControlPage();
    },
  );
}

/// generated route for
/// [_i12.DiningPage]
class DiningRoute extends _i43.PageRouteInfo<void> {
  const DiningRoute({List<_i43.PageRouteInfo>? children})
    : super(DiningRoute.name, initialChildren: children);

  static const String name = 'DiningRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i12.DiningPage();
    },
  );
}

/// generated route for
/// [_i13.ExceptionsPage]
class ExceptionsRoute extends _i43.PageRouteInfo<void> {
  const ExceptionsRoute({List<_i43.PageRouteInfo>? children})
    : super(ExceptionsRoute.name, initialChildren: children);

  static const String name = 'ExceptionsRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i13.ExceptionsPage();
    },
  );
}

/// generated route for
/// [_i14.FlagsPage]
class FlagsRoute extends _i43.PageRouteInfo<void> {
  const FlagsRoute({List<_i43.PageRouteInfo>? children})
    : super(FlagsRoute.name, initialChildren: children);

  static const String name = 'FlagsRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i14.FlagsPage();
    },
  );
}

/// generated route for
/// [_i15.HealthPage]
class HealthRoute extends _i43.PageRouteInfo<void> {
  const HealthRoute({List<_i43.PageRouteInfo>? children})
    : super(HealthRoute.name, initialChildren: children);

  static const String name = 'HealthRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i15.HealthPage();
    },
  );
}

/// generated route for
/// [_i16.HomepageEditorPage]
class HomepageEditorRoute extends _i43.PageRouteInfo<void> {
  const HomepageEditorRoute({List<_i43.PageRouteInfo>? children})
    : super(HomepageEditorRoute.name, initialChildren: children);

  static const String name = 'HomepageEditorRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i16.HomepageEditorPage();
    },
  );
}

/// generated route for
/// [_i17.IntegrationsPage]
class IntegrationsRoute extends _i43.PageRouteInfo<void> {
  const IntegrationsRoute({List<_i43.PageRouteInfo>? children})
    : super(IntegrationsRoute.name, initialChildren: children);

  static const String name = 'IntegrationsRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i17.IntegrationsPage();
    },
  );
}

/// generated route for
/// [_i18.InviteStaffPage]
class InviteStaffRoute extends _i43.PageRouteInfo<void> {
  const InviteStaffRoute({List<_i43.PageRouteInfo>? children})
    : super(InviteStaffRoute.name, initialChildren: children);

  static const String name = 'InviteStaffRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i18.InviteStaffPage();
    },
  );
}

/// generated route for
/// [_i15.JobsPage]
class JobsRoute extends _i43.PageRouteInfo<void> {
  const JobsRoute({List<_i43.PageRouteInfo>? children})
    : super(JobsRoute.name, initialChildren: children);

  static const String name = 'JobsRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i15.JobsPage();
    },
  );
}

/// generated route for
/// [_i19.KnowledgePage]
class KnowledgeRoute extends _i43.PageRouteInfo<void> {
  const KnowledgeRoute({List<_i43.PageRouteInfo>? children})
    : super(KnowledgeRoute.name, initialChildren: children);

  static const String name = 'KnowledgeRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i19.KnowledgePage();
    },
  );
}

/// generated route for
/// [_i20.LivePage]
class LiveRoute extends _i43.PageRouteInfo<void> {
  const LiveRoute({List<_i43.PageRouteInfo>? children})
    : super(LiveRoute.name, initialChildren: children);

  static const String name = 'LiveRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i20.LivePage();
    },
  );
}

/// generated route for
/// [_i21.LoginPage]
class LoginRoute extends _i43.PageRouteInfo<void> {
  const LoginRoute({List<_i43.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i21.LoginPage();
    },
  );
}

/// generated route for
/// [_i22.MaintenancePage]
class MaintenanceRoute extends _i43.PageRouteInfo<void> {
  const MaintenanceRoute({List<_i43.PageRouteInfo>? children})
    : super(MaintenanceRoute.name, initialChildren: children);

  static const String name = 'MaintenanceRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i22.MaintenancePage();
    },
  );
}

/// generated route for
/// [_i19.MarketPage]
class MarketRoute extends _i43.PageRouteInfo<void> {
  const MarketRoute({List<_i43.PageRouteInfo>? children})
    : super(MarketRoute.name, initialChildren: children);

  static const String name = 'MarketRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i19.MarketPage();
    },
  );
}

/// generated route for
/// [_i23.MorePage]
class MoreRoute extends _i43.PageRouteInfo<void> {
  const MoreRoute({List<_i43.PageRouteInfo>? children})
    : super(MoreRoute.name, initialChildren: children);

  static const String name = 'MoreRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i23.MorePage();
    },
  );
}

/// generated route for
/// [_i24.MyDevicesPage]
class MyDevicesRoute extends _i43.PageRouteInfo<void> {
  const MyDevicesRoute({List<_i43.PageRouteInfo>? children})
    : super(MyDevicesRoute.name, initialChildren: children);

  static const String name = 'MyDevicesRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i24.MyDevicesPage();
    },
  );
}

/// generated route for
/// [_i25.NavigationEditorPage]
class NavigationEditorRoute extends _i43.PageRouteInfo<void> {
  const NavigationEditorRoute({List<_i43.PageRouteInfo>? children})
    : super(NavigationEditorRoute.name, initialChildren: children);

  static const String name = 'NavigationEditorRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i25.NavigationEditorPage();
    },
  );
}

/// generated route for
/// [_i26.NotificationsPage]
class NotificationsRoute extends _i43.PageRouteInfo<void> {
  const NotificationsRoute({List<_i43.PageRouteInfo>? children})
    : super(NotificationsRoute.name, initialChildren: children);

  static const String name = 'NotificationsRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i26.NotificationsPage();
    },
  );
}

/// generated route for
/// [_i19.OpportunitiesPage]
class OpportunitiesRoute extends _i43.PageRouteInfo<void> {
  const OpportunitiesRoute({List<_i43.PageRouteInfo>? children})
    : super(OpportunitiesRoute.name, initialChildren: children);

  static const String name = 'OpportunitiesRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i19.OpportunitiesPage();
    },
  );
}

/// generated route for
/// [_i27.PricingPage]
class PricingRoute extends _i43.PageRouteInfo<void> {
  const PricingRoute({List<_i43.PageRouteInfo>? children})
    : super(PricingRoute.name, initialChildren: children);

  static const String name = 'PricingRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i27.PricingPage();
    },
  );
}

/// generated route for
/// [_i28.ProgrammeEditorPage]
class ProgrammeEditorRoute
    extends _i43.PageRouteInfo<ProgrammeEditorRouteArgs> {
  ProgrammeEditorRoute({
    String id = 'new',
    _i44.Key? key,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         ProgrammeEditorRoute.name,
         args: ProgrammeEditorRouteArgs(id: id, key: key),
         rawPathParams: {'id': id},
         initialChildren: children,
       );

  static const String name = 'ProgrammeEditorRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ProgrammeEditorRouteArgs>(
        orElse: () =>
            ProgrammeEditorRouteArgs(id: pathParams.getString('id', 'new')),
      );
      return _i28.ProgrammeEditorPage(id: args.id, key: args.key);
    },
  );
}

class ProgrammeEditorRouteArgs {
  const ProgrammeEditorRouteArgs({this.id = 'new', this.key});

  final String id;

  final _i44.Key? key;

  @override
  String toString() {
    return 'ProgrammeEditorRouteArgs{id: $id, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ProgrammeEditorRouteArgs) return false;
    return id == other.id && key == other.key;
  }

  @override
  int get hashCode => id.hashCode ^ key.hashCode;
}

/// generated route for
/// [_i28.ProgrammesPage]
class ProgrammesRoute extends _i43.PageRouteInfo<void> {
  const ProgrammesRoute({List<_i43.PageRouteInfo>? children})
    : super(ProgrammesRoute.name, initialChildren: children);

  static const String name = 'ProgrammesRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i28.ProgrammesPage();
    },
  );
}

/// generated route for
/// [_i29.PulsePage]
class PulseRoute extends _i43.PageRouteInfo<void> {
  const PulseRoute({List<_i43.PageRouteInfo>? children})
    : super(PulseRoute.name, initialChildren: children);

  static const String name = 'PulseRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i29.PulsePage();
    },
  );
}

/// generated route for
/// [_i30.QueuePage]
class QueueRoute extends _i43.PageRouteInfo<void> {
  const QueueRoute({List<_i43.PageRouteInfo>? children})
    : super(QueueRoute.name, initialChildren: children);

  static const String name = 'QueueRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i30.QueuePage();
    },
  );
}

/// generated route for
/// [_i31.RoleEditorPage]
class RoleEditorRoute extends _i43.PageRouteInfo<RoleEditorRouteArgs> {
  RoleEditorRoute({
    _i44.Key? key,
    String? roleId,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         RoleEditorRoute.name,
         args: RoleEditorRouteArgs(key: key, roleId: roleId),
         initialChildren: children,
       );

  static const String name = 'RoleEditorRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RoleEditorRouteArgs>(
        orElse: () => const RoleEditorRouteArgs(),
      );
      return _i31.RoleEditorPage(key: args.key, roleId: args.roleId);
    },
  );
}

class RoleEditorRouteArgs {
  const RoleEditorRouteArgs({this.key, this.roleId});

  final _i44.Key? key;

  final String? roleId;

  @override
  String toString() {
    return 'RoleEditorRouteArgs{key: $key, roleId: $roleId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! RoleEditorRouteArgs) return false;
    return key == other.key && roleId == other.roleId;
  }

  @override
  int get hashCode => key.hashCode ^ roleId.hashCode;
}

/// generated route for
/// [_i32.SearchPage]
class SearchRoute extends _i43.PageRouteInfo<void> {
  const SearchRoute({List<_i43.PageRouteInfo>? children})
    : super(SearchRoute.name, initialChildren: children);

  static const String name = 'SearchRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i32.SearchPage();
    },
  );
}

/// generated route for
/// [_i33.SettingsPage]
class SettingsRoute extends _i43.PageRouteInfo<void> {
  const SettingsRoute({List<_i43.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i33.SettingsPage();
    },
  );
}

/// generated route for
/// [_i26.SmsPage]
class SmsRoute extends _i43.PageRouteInfo<void> {
  const SmsRoute({List<_i43.PageRouteInfo>? children})
    : super(SmsRoute.name, initialChildren: children);

  static const String name = 'SmsRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i26.SmsPage();
    },
  );
}

/// generated route for
/// [_i34.SplashPage]
class SplashRoute extends _i43.PageRouteInfo<void> {
  const SplashRoute({List<_i43.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i34.SplashPage();
    },
  );
}

/// generated route for
/// [_i35.StaysPage]
class StaysRoute extends _i43.PageRouteInfo<void> {
  const StaysRoute({List<_i43.PageRouteInfo>? children})
    : super(StaysRoute.name, initialChildren: children);

  static const String name = 'StaysRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i35.StaysPage();
    },
  );
}

/// generated route for
/// [_i36.SupplierAuditPage]
class SupplierAuditRoute extends _i43.PageRouteInfo<void> {
  const SupplierAuditRoute({List<_i43.PageRouteInfo>? children})
    : super(SupplierAuditRoute.name, initialChildren: children);

  static const String name = 'SupplierAuditRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i36.SupplierAuditPage();
    },
  );
}

/// generated route for
/// [_i37.SupplierInboxPage]
class SupplierInboxRoute extends _i43.PageRouteInfo<SupplierInboxRouteArgs> {
  SupplierInboxRoute({
    _i44.Key? key,
    String? supplierId,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         SupplierInboxRoute.name,
         args: SupplierInboxRouteArgs(key: key, supplierId: supplierId),
         initialChildren: children,
       );

  static const String name = 'SupplierInboxRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SupplierInboxRouteArgs>(
        orElse: () => const SupplierInboxRouteArgs(),
      );
      return _i37.SupplierInboxPage(key: args.key, supplierId: args.supplierId);
    },
  );
}

class SupplierInboxRouteArgs {
  const SupplierInboxRouteArgs({this.key, this.supplierId});

  final _i44.Key? key;

  final String? supplierId;

  @override
  String toString() {
    return 'SupplierInboxRouteArgs{key: $key, supplierId: $supplierId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SupplierInboxRouteArgs) return false;
    return key == other.key && supplierId == other.supplierId;
  }

  @override
  int get hashCode => key.hashCode ^ supplierId.hashCode;
}

/// generated route for
/// [_i36.SupplierInventoryPage]
class SupplierInventoryRoute
    extends _i43.PageRouteInfo<SupplierInventoryRouteArgs> {
  SupplierInventoryRoute({
    _i44.Key? key,
    String? supplierId,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         SupplierInventoryRoute.name,
         args: SupplierInventoryRouteArgs(key: key, supplierId: supplierId),
         initialChildren: children,
       );

  static const String name = 'SupplierInventoryRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SupplierInventoryRouteArgs>(
        orElse: () => const SupplierInventoryRouteArgs(),
      );
      return _i36.SupplierInventoryPage(
        key: args.key,
        supplierId: args.supplierId,
      );
    },
  );
}

class SupplierInventoryRouteArgs {
  const SupplierInventoryRouteArgs({this.key, this.supplierId});

  final _i44.Key? key;

  final String? supplierId;

  @override
  String toString() {
    return 'SupplierInventoryRouteArgs{key: $key, supplierId: $supplierId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SupplierInventoryRouteArgs) return false;
    return key == other.key && supplierId == other.supplierId;
  }

  @override
  int get hashCode => key.hashCode ^ supplierId.hashCode;
}

/// generated route for
/// [_i36.SupplierPortalPage]
class SupplierPortalRoute extends _i43.PageRouteInfo<SupplierPortalRouteArgs> {
  SupplierPortalRoute({
    _i44.Key? key,
    String? supplierId,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         SupplierPortalRoute.name,
         args: SupplierPortalRouteArgs(key: key, supplierId: supplierId),
         initialChildren: children,
       );

  static const String name = 'SupplierPortalRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SupplierPortalRouteArgs>(
        orElse: () => const SupplierPortalRouteArgs(),
      );
      return _i36.SupplierPortalPage(
        key: args.key,
        supplierId: args.supplierId,
      );
    },
  );
}

class SupplierPortalRouteArgs {
  const SupplierPortalRouteArgs({this.key, this.supplierId});

  final _i44.Key? key;

  final String? supplierId;

  @override
  String toString() {
    return 'SupplierPortalRouteArgs{key: $key, supplierId: $supplierId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SupplierPortalRouteArgs) return false;
    return key == other.key && supplierId == other.supplierId;
  }

  @override
  int get hashCode => key.hashCode ^ supplierId.hashCode;
}

/// generated route for
/// [_i36.SupplierReliabilityPage]
class SupplierReliabilityRoute
    extends _i43.PageRouteInfo<SupplierReliabilityRouteArgs> {
  SupplierReliabilityRoute({
    _i44.Key? key,
    String? supplierId,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         SupplierReliabilityRoute.name,
         args: SupplierReliabilityRouteArgs(key: key, supplierId: supplierId),
         initialChildren: children,
       );

  static const String name = 'SupplierReliabilityRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SupplierReliabilityRouteArgs>(
        orElse: () => const SupplierReliabilityRouteArgs(),
      );
      return _i36.SupplierReliabilityPage(
        key: args.key,
        supplierId: args.supplierId,
      );
    },
  );
}

class SupplierReliabilityRouteArgs {
  const SupplierReliabilityRouteArgs({this.key, this.supplierId});

  final _i44.Key? key;

  final String? supplierId;

  @override
  String toString() {
    return 'SupplierReliabilityRouteArgs{key: $key, supplierId: $supplierId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SupplierReliabilityRouteArgs) return false;
    return key == other.key && supplierId == other.supplierId;
  }

  @override
  int get hashCode => key.hashCode ^ supplierId.hashCode;
}

/// generated route for
/// [_i36.SupplierRentalsPage]
class SupplierRentalsRoute extends _i43.PageRouteInfo<void> {
  const SupplierRentalsRoute({List<_i43.PageRouteInfo>? children})
    : super(SupplierRentalsRoute.name, initialChildren: children);

  static const String name = 'SupplierRentalsRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i36.SupplierRentalsPage();
    },
  );
}

/// generated route for
/// [_i36.SupplierRevenuePage]
class SupplierRevenueRoute
    extends _i43.PageRouteInfo<SupplierRevenueRouteArgs> {
  SupplierRevenueRoute({
    _i44.Key? key,
    String? supplierId,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         SupplierRevenueRoute.name,
         args: SupplierRevenueRouteArgs(key: key, supplierId: supplierId),
         initialChildren: children,
       );

  static const String name = 'SupplierRevenueRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SupplierRevenueRouteArgs>(
        orElse: () => const SupplierRevenueRouteArgs(),
      );
      return _i36.SupplierRevenuePage(
        key: args.key,
        supplierId: args.supplierId,
      );
    },
  );
}

class SupplierRevenueRouteArgs {
  const SupplierRevenueRouteArgs({this.key, this.supplierId});

  final _i44.Key? key;

  final String? supplierId;

  @override
  String toString() {
    return 'SupplierRevenueRouteArgs{key: $key, supplierId: $supplierId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SupplierRevenueRouteArgs) return false;
    return key == other.key && supplierId == other.supplierId;
  }

  @override
  int get hashCode => key.hashCode ^ supplierId.hashCode;
}

/// generated route for
/// [_i36.SupplierStaysPage]
class SupplierStaysRoute extends _i43.PageRouteInfo<void> {
  const SupplierStaysRoute({List<_i43.PageRouteInfo>? children})
    : super(SupplierStaysRoute.name, initialChildren: children);

  static const String name = 'SupplierStaysRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i36.SupplierStaysPage();
    },
  );
}

/// generated route for
/// [_i38.SuppliersPage]
class SuppliersRoute extends _i43.PageRouteInfo<void> {
  const SuppliersRoute({List<_i43.PageRouteInfo>? children})
    : super(SuppliersRoute.name, initialChildren: children);

  static const String name = 'SuppliersRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i38.SuppliersPage();
    },
  );
}

/// generated route for
/// [_i39.SupportPage]
class SupportRoute extends _i43.PageRouteInfo<void> {
  const SupportRoute({List<_i43.PageRouteInfo>? children})
    : super(SupportRoute.name, initialChildren: children);

  static const String name = 'SupportRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i39.SupportPage();
    },
  );
}

/// generated route for
/// [_i40.TabsPage]
class TabsRoute extends _i43.PageRouteInfo<void> {
  const TabsRoute({List<_i43.PageRouteInfo>? children})
    : super(TabsRoute.name, initialChildren: children);

  static const String name = 'TabsRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i40.TabsPage();
    },
  );
}

/// generated route for
/// [_i41.UserDetailPage]
class UserDetailRoute extends _i43.PageRouteInfo<UserDetailRouteArgs> {
  UserDetailRoute({
    _i44.Key? key,
    required String userId,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         UserDetailRoute.name,
         args: UserDetailRouteArgs(key: key, userId: userId),
         rawPathParams: {'id': userId},
         initialChildren: children,
       );

  static const String name = 'UserDetailRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<UserDetailRouteArgs>(
        orElse: () => UserDetailRouteArgs(userId: pathParams.getString('id')),
      );
      return _i41.UserDetailPage(key: args.key, userId: args.userId);
    },
  );
}

class UserDetailRouteArgs {
  const UserDetailRouteArgs({this.key, required this.userId});

  final _i44.Key? key;

  final String userId;

  @override
  String toString() {
    return 'UserDetailRouteArgs{key: $key, userId: $userId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UserDetailRouteArgs) return false;
    return key == other.key && userId == other.userId;
  }

  @override
  int get hashCode => key.hashCode ^ userId.hashCode;
}

/// generated route for
/// [_i42.UsersPage]
class UsersRoute extends _i43.PageRouteInfo<void> {
  const UsersRoute({List<_i43.PageRouteInfo>? children})
    : super(UsersRoute.name, initialChildren: children);

  static const String name = 'UsersRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i42.UsersPage();
    },
  );
}
