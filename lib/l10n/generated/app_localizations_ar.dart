// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'دهب أوبس';

  @override
  String get retry => 'حاول مرة أخرى';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get close => 'إغلاق';

  @override
  String get save => 'حفظ';

  @override
  String get done => 'تم';

  @override
  String get copy => 'نسخ';

  @override
  String get copied => 'تم النسخ';

  @override
  String get search => 'بحث';

  @override
  String get refresh => 'تحديث';

  @override
  String get loadMore => 'تحميل المزيد';

  @override
  String get edit => 'تعديل';

  @override
  String get add => 'إضافة';

  @override
  String get remove => 'إزالة';

  @override
  String get apply => 'تطبيق';

  @override
  String get reset => 'إعادة ضبط';

  @override
  String get all => 'الكل';

  @override
  String get optional => 'اختياري';

  @override
  String get unknown => 'غير معروف';

  @override
  String get justNow => 'الآن';

  @override
  String get errorGeneric => 'حدث خطأ ما.';

  @override
  String get errorNetwork => 'تعذر الوصول إلى خوادم دهب. تحقق من الاتصال.';

  @override
  String get errorTimeout => 'استغرق الخادم وقتاً طويلاً للرد.';

  @override
  String get errorUnauthorized => 'انتهت جلستك. سجّل الدخول مرة أخرى.';

  @override
  String get errorForbidden => 'ليست لديك صلاحية لهذا الإجراء.';

  @override
  String get errorNotFound => 'لم نعثر على ذلك.';

  @override
  String get errorServer => 'حدثت مشكلة في الخادم وتم تسجيلها.';

  @override
  String get errorKillSwitch => 'هذه الخاصية متوقفة حالياً.';

  @override
  String get errorMaintenance => 'دهب في وضع الصيانة.';

  @override
  String get errorViewAsReadonly =>
      'وضع العرض كمستخدم للقراءة فقط. أنهِه لإجراء تغييرات.';

  @override
  String get correlationId => 'المرجع';

  @override
  String get copyReference => 'نسخ المرجع';

  @override
  String get offlineBanner => 'أنت غير متصل. نعرض آخر بيانات متاحة.';

  @override
  String get loginTitle => 'تسجيل الدخول إلى أدوات التشغيل';

  @override
  String get loginSubtitle =>
      'لفريق دهب والموردين الشركاء. يستخدم المسافرون تطبيق دهب.';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get showPassword => 'إظهار كلمة المرور';

  @override
  String get hidePassword => 'إخفاء كلمة المرور';

  @override
  String get emailInvalid => 'أدخل بريداً إلكترونياً صحيحاً.';

  @override
  String get passwordRequired => 'أدخل كلمة المرور.';

  @override
  String get invalidCredentials =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة.';

  @override
  String get notStaff => 'هذا الحساب ليس لديه صلاحيات الفريق.';

  @override
  String get restoringSession => 'جارٍ استعادة جلستك…';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logoutConfirm => 'تسجيل الخروج من دهب أوبس على هذا الجهاز؟';

  @override
  String get or => 'أو';

  @override
  String get unlockWithFaceId => 'الفتح ببصمة الوجه';

  @override
  String staffOnlyNote(String device) {
    return 'للموظفين فقط. هذا الجهاز مسجّل باسم $device. تنتهي الجلسة بعد 12 ساعة.';
  }

  @override
  String get buildStamp => 'الإصدار 1.0.0 (204)';

  @override
  String get controlTitle => 'التحكم';

  @override
  String get myDevices => 'أجهزتي';

  @override
  String get thisDevice => 'هذا الجهاز';

  @override
  String get revokeDevice => 'تسجيل خروج الجهاز';

  @override
  String get deviceRevoked => 'تم تسجيل خروج الجهاز';

  @override
  String get devicesEmpty => 'لا توجد أجهزة مسجلة الدخول.';

  @override
  String get appLocked => 'دهب أوبس مقفل';

  @override
  String get appLockedBody => 'افتح القفل للمتابعة من حيث توقفت.';

  @override
  String get unlock => 'فتح القفل';

  @override
  String get unlockReason => 'فتح دهب أوبس';

  @override
  String get biometricLock => 'قفل التطبيق بالبصمة';

  @override
  String get biometricLockHint =>
      'اطلب بصمة الوجه أو الإصبع عند العودة إلى التطبيق.';

  @override
  String get biometricUnavailable => 'لم يتم إعداد البصمة على هذا الجهاز.';

  @override
  String get navPulse => 'النبض';

  @override
  String get navQueue => 'المهام';

  @override
  String get navLive => 'مباشر';

  @override
  String get navInbox => 'الوارد';

  @override
  String get navMore => 'المزيد';

  @override
  String get navInventory => 'المخزون';

  @override
  String get navRevenue => 'الإيرادات';

  @override
  String get sectionOverview => 'نظرة عامة';

  @override
  String get sectionCore => 'نواة الذكاء';

  @override
  String get sectionTrips => 'الرحلات الحية';

  @override
  String get sectionTransfers => 'النقل';

  @override
  String get sectionExceptions => 'الاستثناءات';

  @override
  String get sectionCommerce => 'التجارة';

  @override
  String get sectionAccommodations => 'أماكن الإقامة';

  @override
  String get sectionStays => 'الإقامات';

  @override
  String get sectionSuppliers => 'الموردين';

  @override
  String get sectionIntelligence => 'الاستخبارات';

  @override
  String get sectionOpportunities => 'الفرص';

  @override
  String get sectionKnowledge => 'المعرفة';

  @override
  String get sectionSupport => 'الدعم';

  @override
  String get sectionSms => 'الرسائل';

  @override
  String get sectionNotifications => 'الإشعارات';

  @override
  String get sectionAudit => 'سجل التدقيق';

  @override
  String get sectionFlags => 'أعلام الميزات';

  @override
  String get sectionJobs => 'الوظائف';

  @override
  String get sectionHealth => 'صحة النظام';

  @override
  String get sectionCms => 'إدارة المحتوى';

  @override
  String get sectionPricing => 'التسعير والمخزون';

  @override
  String get sectionDining => 'طلبات المطاعم';

  @override
  String get sectionMarket => 'ذكاء السوق';

  @override
  String get supplierInbox => 'وارد المورد';

  @override
  String get supplierInventory => 'المخزون';

  @override
  String get supplierResources => 'الموارد';

  @override
  String get supplierStays => 'الإقامات';

  @override
  String get supplierRentals => 'الإيجارات';

  @override
  String get supplierRevenue => 'الإيرادات';

  @override
  String get supplierReliability => 'الموثوقية';

  @override
  String get supplierAudit => 'سجل النشاط';

  @override
  String get controlUsers => 'المستخدمون';

  @override
  String get controlInvite => 'دعوة موظف';

  @override
  String get controlRoles => 'الأدوار والصلاحيات';

  @override
  String get controlSettings => 'الإعدادات';

  @override
  String get controlFlags => 'الأعلام ومفاتيح الإيقاف';

  @override
  String get controlMaintenance => 'وضع الصيانة';

  @override
  String get controlIntegrations => 'التكاملات';

  @override
  String get controlApprovals => 'الموافقات';

  @override
  String get controlAudit => 'سجل التدقيق الزمني';

  @override
  String get groupCore => 'الأساس';

  @override
  String get groupDomain => 'العمليات';

  @override
  String get groupSystem => 'النظام';

  @override
  String get groupSupplier => 'المورد';

  @override
  String get groupMarket => 'السوق والمحتوى';

  @override
  String get groupControl => 'التحكم';

  @override
  String get groupAccount => 'الحساب';

  @override
  String get comingNextTitle => 'قريباً';

  @override
  String get comingNextBody =>
      'يُعاد بناء هذا القسم للجوال. حتى ذلك الحين، استخدم مركز القيادة على الويب.';

  @override
  String get comingNextAccess => 'صلاحيتك';

  @override
  String get pulseTitle => 'النبض';

  @override
  String get statusHealthy => 'جميع الأنظمة سليمة';

  @override
  String get statusDegraded => 'أداء متراجع';

  @override
  String get statusActionRequired => 'مطلوب إجراء';

  @override
  String get live => 'مباشر';

  @override
  String get polling => 'تحديث دوري';

  @override
  String get reconnecting => 'إعادة الاتصال';

  @override
  String get kpiActiveTrips => 'رحلات نشطة';

  @override
  String get kpiPendingBookings => 'حجوزات معلقة';

  @override
  String get kpiSupplierConfirmations => 'تأكيدات الموردين';

  @override
  String get kpiPaymentIssues => 'مشكلات الدفع';

  @override
  String get kpiExceptions => 'الاستثناءات';

  @override
  String get kpiAtRisk => 'رحلات معرضة للخطر';

  @override
  String get kpiUnreadSupport => 'دعم مفتوح';

  @override
  String get kpiActiveTransfers => 'تنقلات نشطة';

  @override
  String get actionQueue => 'طابور الإجراءات';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get queueEmpty => 'لا شيء يحتاجك الآن';

  @override
  String get queueEmptyBody => 'يظهر العمل الجديد هنا فور وصوله.';

  @override
  String get priorityCritical => 'حرج';

  @override
  String get priorityHigh => 'مرتفع';

  @override
  String get priorityMedium => 'متوسط';

  @override
  String get priorityLow => 'منخفض';

  @override
  String get searchHint => 'ابحث عن حجوزات أو أشخاص أو موردين…';

  @override
  String get recent => 'الأخيرة';

  @override
  String get clearRecent => 'مسح';

  @override
  String get noResults => 'لا توجد نتائج';

  @override
  String get searchEmptyBody =>
      'ابحث في الحجوزات والمستخدمين والموردين والعقارات المتاحة لك.';

  @override
  String get typeBooking => 'حجز';

  @override
  String get typeUser => 'مستخدم';

  @override
  String get typeSupplier => 'مورد';

  @override
  String get typeProperty => 'عقار';

  @override
  String get filters => 'عوامل التصفية';

  @override
  String get sort => 'ترتيب';

  @override
  String get ascending => 'تصاعدي';

  @override
  String get descending => 'تنازلي';

  @override
  String get newest => 'الأحدث أولاً';

  @override
  String get oldest => 'الأقدم أولاً';

  @override
  String get nameSort => 'الاسم';

  @override
  String get lastSeenSort => 'آخر ظهور';

  @override
  String get dangerReasonLabel => 'السبب';

  @override
  String get dangerReasonHint => 'لماذا تقوم بهذا؟ يُحفظ في سجل التدقيق.';

  @override
  String get dangerReasonTooShort => 'اكتب 3 أحرف على الأقل.';

  @override
  String get approvalNotice =>
      'هذا التغيير يحتاج إلى مسؤول ثانٍ. سيُضاف إلى قائمة الموافقات.';

  @override
  String get biometricConfirmReason => 'أكّد هذا الإجراء الحساس';

  @override
  String get biometricFailed => 'فشل التحقق بالبصمة.';

  @override
  String get noAccessTitle => 'لا توجد صلاحية';

  @override
  String get noAccessBody => 'اطلب من المسؤول الصلاحية أدناه.';

  @override
  String get usersTitle => 'المستخدمون';

  @override
  String get usersSearch => 'ابحث بالاسم أو البريد';

  @override
  String get filterRole => 'الدور';

  @override
  String get filterStatus => 'الحالة';

  @override
  String get statusActive => 'نشط';

  @override
  String get statusSuspended => 'موقوف';

  @override
  String get role => 'الدور';

  @override
  String get changeRole => 'تغيير الدور';

  @override
  String get suspend => 'إيقاف';

  @override
  String get reactivate => 'إعادة التفعيل';

  @override
  String get suspendTitle => 'إيقاف هذا المستخدم؟';

  @override
  String get suspendBody =>
      'سيتم تسجيل خروجه من كل مكان ولن يتمكن من الدخول حتى إعادة التفعيل.';

  @override
  String get overrides => 'استثناءات الصلاحيات';

  @override
  String get overridesHint =>
      'الاستثناءات تتقدم على الدور. المنع يتقدم على المنح.';

  @override
  String get addOverride => 'إضافة استثناء';

  @override
  String get grant => 'منح';

  @override
  String get deny => 'منع';

  @override
  String get effectivePermissions => 'الصلاحيات الفعلية';

  @override
  String get revokeSessions => 'إلغاء كل الجلسات';

  @override
  String get revokeSessionsTitle => 'تسجيل خروج المستخدم من كل مكان؟';

  @override
  String get devices => 'الأجهزة';

  @override
  String get viewAs => 'العرض كهذا المستخدم';

  @override
  String get endViewAs => 'إنهاء';

  @override
  String get inviteStaff => 'دعوة موظف';

  @override
  String get name => 'الاسم';

  @override
  String get phone => 'الهاتف';

  @override
  String get supplierId => 'معرّف المورد';

  @override
  String get invite => 'إرسال الدعوة';

  @override
  String get tempPasswordTitle => 'كلمة مرور مؤقتة';

  @override
  String get tempPasswordBody =>
      'تظهر مرة واحدة. شاركها عبر قناة آمنة، ويجب تغييرها عند أول دخول.';

  @override
  String get nameRequired => 'أدخل الاسم.';

  @override
  String get roleRequired => 'اختر دوراً.';

  @override
  String get rolesTitle => 'الأدوار والصلاحيات';

  @override
  String get systemRole => 'نظام';

  @override
  String get permissionMatrix => 'مصفوفة الصلاحيات';

  @override
  String get dangerous => 'خطِر';

  @override
  String get newRole => 'دور جديد';

  @override
  String get roleName => 'اسم الدور';

  @override
  String get roleDescription => 'الوصف';

  @override
  String get deleteRole => 'حذف الدور';

  @override
  String get deleteRoleTitle => 'حذف هذا الدور؟';

  @override
  String get saved => 'تم الحفظ';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get history => 'السجل';

  @override
  String get rollback => 'استرجاع';

  @override
  String get invalidJson => 'هذا ليس JSON صالحاً.';

  @override
  String get invalidNumber => 'أدخل رقماً.';

  @override
  String get flagsTitle => 'الأعلام ومفاتيح الإيقاف';

  @override
  String get killSwitches => 'مفاتيح الإيقاف';

  @override
  String get featureFlags => 'أعلام الميزات';

  @override
  String get rollout => 'نسبة الإتاحة';

  @override
  String get killSwitchWarning =>
      'تشغيل هذا يوقف الخاصية لجميع المستخدمين فوراً.';

  @override
  String get enabled => 'مفعّل';

  @override
  String get disabled => 'متوقف';

  @override
  String get maintenanceTitle => 'وضع الصيانة';

  @override
  String get maintenanceOn => 'الصيانة مفعّلة';

  @override
  String get maintenanceOff => 'الصيانة متوقفة';

  @override
  String get maintenanceBody =>
      'أثناء التفعيل يرى المسافرون والموردون صفحة الصيانة. يستمر عمل الفريق وتسجيل الدخول.';

  @override
  String get messageEn => 'الرسالة (إنجليزي)';

  @override
  String get messageAr => 'الرسالة (عربي)';

  @override
  String get saveMessage => 'حفظ الرسالة';

  @override
  String get integrationsTitle => 'التكاملات';

  @override
  String get checkNow => 'فحص الآن';

  @override
  String get latency => 'زمن الاستجابة';

  @override
  String get mode => 'الوضع';

  @override
  String get sandbox => 'تجريبي';

  @override
  String get liveMode => 'فعلي';

  @override
  String get keyHint => 'المفتاح';

  @override
  String get statusDown => 'متوقف';

  @override
  String get statusOff => 'معطّل';

  @override
  String get statusUnconfigured => 'غير مهيأ';

  @override
  String get approvalsTitle => 'الموافقات';

  @override
  String get pending => 'معلّق';

  @override
  String get approved => 'موافق عليه';

  @override
  String get rejected => 'مرفوض';

  @override
  String get approve => 'موافقة';

  @override
  String get reject => 'رفض';

  @override
  String get decisionNote => 'ملاحظة (اختياري)';

  @override
  String get ownHidden => 'طلباتك مخفية. يقرر فيها مسؤول آخر.';

  @override
  String get approvalsEmpty => 'لا توجد موافقات معلقة';

  @override
  String get auditTitle => 'سجل التدقيق الزمني';

  @override
  String get actor => 'المنفّذ';

  @override
  String get action => 'الإجراء';

  @override
  String get entity => 'الكيان';

  @override
  String get dateRange => 'النطاق الزمني';

  @override
  String get before => 'قبل';

  @override
  String get after => 'بعد';

  @override
  String get noChanges => 'لم تُسجل تغييرات في الحقول.';

  @override
  String get auditEmpty => 'لا توجد أحداث مطابقة';

  @override
  String get device => 'الجهاز';

  @override
  String get appearance => 'المظهر';

  @override
  String get theme => 'السمة';

  @override
  String get themeAbyss => 'العمق';

  @override
  String get themeSalt => 'الملح';

  @override
  String get themeHighContrast => 'تباين عالٍ';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get security => 'الأمان';

  @override
  String get signedInAs => 'مسجّل الدخول باسم';

  @override
  String get emptyList => 'لا شيء هنا بعد';

  @override
  String get details => 'التفاصيل';

  @override
  String get payload => 'البيانات';

  @override
  String get commandPalette => 'لوحة الأوامر';

  @override
  String get actionFailed => 'لم يكتمل الإجراء.';

  @override
  String updatedAgo(String time) {
    return 'آخر تحديث $time';
  }

  @override
  String minutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'قبل $count دقيقة',
      few: 'قبل $count دقائق',
      two: 'قبل دقيقتين',
      one: 'قبل دقيقة',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'قبل $count ساعة',
      few: 'قبل $count ساعات',
      two: 'قبل ساعتين',
      one: 'قبل ساعة',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'قبل $count يوم',
      few: 'قبل $count أيام',
      two: 'قبل يومين',
      one: 'أمس',
    );
    return '$_temp0';
  }

  @override
  String approvalQueued(String id) {
    return 'أُضيف إلى الموافقات · $id';
  }

  @override
  String lastSeen(String time) {
    return 'آخر ظهور $time';
  }

  @override
  String deviceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count جهاز',
      few: '$count أجهزة',
      two: 'جهازان',
      one: 'جهاز واحد',
      zero: 'لا أجهزة',
    );
    return '$_temp0';
  }

  @override
  String usersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مستخدم',
      few: '$count مستخدمين',
      two: 'مستخدمان',
      one: 'مستخدم واحد',
      zero: 'لا مستخدمين',
    );
    return '$_temp0';
  }

  @override
  String revokedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'أُلغيت $count جلسة',
      one: 'أُلغيت جلسة واحدة',
    );
    return '$_temp0';
  }

  @override
  String viewAsBanner(String email) {
    return 'العرض باسم $email · قراءة فقط';
  }

  @override
  String versionLabel(int version) {
    return 'إصدار $version';
  }

  @override
  String rollbackTo(int version) {
    return 'الاسترجاع إلى الإصدار $version؟';
  }

  @override
  String requestedBy(String name) {
    return 'طلبه $name';
  }

  @override
  String changesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تغيير',
      few: '$count تغييرات',
      two: 'تغييران',
      one: 'تغيير واحد',
      zero: 'لا تغييرات',
    );
    return '$_temp0';
  }

  @override
  String permissionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count صلاحية',
      few: '$count صلاحيات',
      two: 'صلاحيتان',
      one: 'صلاحية واحدة',
    );
    return '$_temp0';
  }

  @override
  String grantedOf(int granted, int total) {
    return '$granted من $total';
  }

  @override
  String latencyMs(int ms) {
    return '$ms م.ث';
  }

  @override
  String confirmToggle(String name, String state) {
    return 'تحويل $name إلى $state؟';
  }

  @override
  String changeRoleTo(String role) {
    return 'تغيير الدور إلى $role؟';
  }

  @override
  String saveSettingTitle(String key) {
    return 'حفظ $key؟';
  }

  @override
  String get queueTitle => 'المهام';

  @override
  String get needsAction => 'بحاجة إلى إجراء';

  @override
  String get filterAll => 'الكل';

  @override
  String get filterCritical => 'حرجة';

  @override
  String get filterSuppliers => 'الموردون';

  @override
  String get filterPayments => 'المدفوعات';

  @override
  String get filterSupport => 'الدعم';

  @override
  String get snooze => 'تأجيل';

  @override
  String get resolve => 'حلّ';

  @override
  String get overdue => 'متأخر';

  @override
  String get slaLeft => 'متبقٍ';

  @override
  String get accept => 'قبول';

  @override
  String get decline => 'رفض';

  @override
  String get declineBookingTitle => 'رفض هذا الحجز؟';

  @override
  String get declineReasonHint => 'أخبر المكتب بالسبب (رياح، حجز زائد، …)';

  @override
  String get total => 'الإجمالي';

  @override
  String get guests => 'الضيوف';

  @override
  String get commissionRate => 'العمولة';

  @override
  String get commissionNeedsApproval => 'التغيير يحتاج موافقة';

  @override
  String get rebook => 'إعادة الحجز';

  @override
  String get reviewRefund => 'مراجعة الاسترداد';

  @override
  String get timelineBooked => 'تم الحجز';

  @override
  String get timelinePaid => 'تم الدفع';

  @override
  String get timelinePickup => 'الانطلاق';

  @override
  String get paymentsLedger => 'دفتر المدفوعات';

  @override
  String get ledgerCharge => 'تحصيل';

  @override
  String ledgerCommission(Object rate) {
    return 'عمولة $rate';
  }

  @override
  String get ledgerPayout => 'مستحق المورد';

  @override
  String get ledgerNet => 'الصافي لدهب';

  @override
  String get refund => 'استرداد';

  @override
  String get refundAction => 'استرداد مبلغ حجز';

  @override
  String refundSheetSub(Object paid) {
    return 'دُفع $paid. اختر المبلغ المسترد.';
  }

  @override
  String refundOf(Object paid) {
    return 'من $paid';
  }

  @override
  String get refundFull => 'كامل';

  @override
  String get refundReason => 'السبب';

  @override
  String get reasonSupplierCancelled => 'ألغى المورد';

  @override
  String get reasonWeather => 'الطقس';

  @override
  String get reasonNotDelivered => 'لم تُقدَّم الخدمة';

  @override
  String get reasonDuplicateCharge => 'تحصيل مكرر';

  @override
  String get refundNoteHint => 'ماذا حدث، في سطر أو سطرين';

  @override
  String get refundNeedsApproval => 'فوق حد الموافقة: يوافق مسؤول ثانٍ بعدك.';

  @override
  String get requestApprovalWithFaceId => 'طلب الموافقة ببصمة الوجه';

  @override
  String get refundAuditNote => 'يُسجَّل في سجل التدقيق باسمك.';

  @override
  String get refundToGuest => 'إلى بطاقة الضيف';

  @override
  String get refundCommissionReversed => 'عمولة مستردّة';

  @override
  String get refundFromPayout => 'خصم من مستحق المورد';

  @override
  String get refundQueuedTitle => 'بانتظار موافقة مسؤول ثانٍ';

  @override
  String get refundQueuedBody => 'يُسترد المبلغ للضيف بعد الموافقة.';

  @override
  String get refundDoneTitle => 'تم إصدار الاسترداد';

  @override
  String refundDoneBody(Object amount) {
    return 'يعود $amount إلى بطاقة الضيف.';
  }

  @override
  String get inboxWaiting => 'بانتظار ردك';

  @override
  String get inboxEarnings => 'الأرباح';

  @override
  String get inboxReliability => 'الموثوقية';

  @override
  String get inboxPending => 'معلّقة';

  @override
  String get inboxConfirmed => 'مؤكدة';

  @override
  String get inboxDeclined => 'مرفوضة';

  @override
  String get kpiUnreadNotifications => 'إشعارات غير مقروءة';

  @override
  String get actionsTitle => 'إجراءات';

  @override
  String get saveRole => 'حفظ الدور';

  @override
  String get valueLabel => 'القيمة';

  @override
  String get editOverrides => 'تعديل الاستثناءات';

  @override
  String effectivePermissionsCount(Object count) {
    return '$count صلاحية سارية';
  }

  @override
  String get dangerConfirmBiometric => 'تأكيد ببصمة الوجه';

  @override
  String get dangerAuditNote => 'يُسجَّل في سجل التدقيق مع السبب.';

  @override
  String get dangerApprovalTitle => 'يتطلب موافقة مسؤول آخر';

  @override
  String get errorTitle => 'حدث خطأ ما';

  @override
  String get errorConflict =>
      'قام شخص آخر بتعديل هذا أولاً. حدّث وحاول مجدداً.';

  @override
  String get errorValidation => 'بعض الحقول تحتاج إلى مراجعة.';

  @override
  String get offlineShort => 'غير متصل';

  @override
  String get sortBy => 'ترتيب حسب';

  @override
  String get clearFilters => 'مسح عوامل التصفية';

  @override
  String slaMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دقيقة',
      one: 'دقيقة',
    );
    return '$_temp0';
  }

  @override
  String get timelineNow => 'الآن';

  @override
  String get readOnly => 'للقراءة فقط';

  @override
  String get loading => 'جارٍ التحميل';

  @override
  String get viewAsStart => 'العرض كهذا المستخدم';

  @override
  String get viewAsStartBody => 'تصبح جلستك للقراءة فقط وتعرض ما يراه.';

  @override
  String get viewAsEnded => 'انتهى العرض كمستخدم';

  @override
  String get copyPassword => 'نسخ كلمة المرور';

  @override
  String get dateFrom => 'من';

  @override
  String get dateTo => 'إلى';

  @override
  String get showChanges => 'عرض التغييرات';

  @override
  String get hideChanges => 'إخفاء التغييرات';

  @override
  String get currentValue => 'القيمة الحالية';

  @override
  String get newValue => 'القيمة الجديدة';

  @override
  String get historyEmpty => 'لا توجد إصدارات سابقة.';

  @override
  String get integrationEnabled => 'التكامل مفعّل';

  @override
  String switchModeTitle(Object name, Object mode) {
    return 'تحويل $name إلى $mode؟';
  }

  @override
  String toggleTitle(Object name, Object state) {
    return 'هل تريد $state $name؟';
  }

  @override
  String get on => 'تشغيل';

  @override
  String get off => 'إيقاف';

  @override
  String get decidedToast => 'تم تسجيل القرار';

  @override
  String get approvalsHistory => 'تم البت فيها';

  @override
  String get openUser => 'فتح المستخدم';

  @override
  String statusChangeTitle(Object status) {
    return 'تغيير الحالة إلى $status؟';
  }

  @override
  String get addPermission => 'إضافة صلاحية';

  @override
  String get pickPermission => 'اختر صلاحية';

  @override
  String unsavedChanges(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تغييرات غير محفوظة',
      one: 'تغيير واحد غير محفوظ',
    );
    return '$_temp0';
  }

  @override
  String dangerousCount(Object count) {
    return '$count خطرة';
  }

  @override
  String get inviteDone => 'تم إنشاء الدعوة';

  @override
  String get createRole => 'إنشاء دور';

  @override
  String get maintenanceActive => 'وضع الصيانة مفعّل';

  @override
  String get maintenanceInactive => 'الموقع يعمل بشكل طبيعي';

  @override
  String checkedAgo(Object time) {
    return 'تم الفحص $time';
  }

  @override
  String get controlHubSub => 'كل تغيير يتطلب سبباً ويُسجَّل في التدقيق.';

  @override
  String get userNotFound => 'المستخدم غير موجود';

  @override
  String get auditOps => 'تدقيق العمليات';

  @override
  String get filterApply => 'تطبيق عوامل التصفية';

  @override
  String get systemRoleLocked =>
      'يمكن تعديل صلاحيات أدوار النظام لكن لا يمكن إعادة تسميتها أو حذفها.';

  @override
  String get fStatus => 'الحالة';

  @override
  String get fTraveler => 'المسافر';

  @override
  String get fAmount => 'المبلغ';

  @override
  String get fScheduled => 'الموعد';

  @override
  String get fPickup => 'الالتقاء';

  @override
  String get fDropoff => 'الوصول';

  @override
  String get fDriver => 'السائق';

  @override
  String get fVehicle => 'المركبة';

  @override
  String get fSupplier => 'المورّد';

  @override
  String get fService => 'الخدمة';

  @override
  String get fCreated => 'تاريخ الإنشاء';

  @override
  String get fChannel => 'القناة';

  @override
  String get fRecipient => 'المستلم';

  @override
  String get fMessage => 'الرسالة';

  @override
  String get fCategory => 'الفئة';

  @override
  String get fPriority => 'الأولوية';

  @override
  String get fVenue => 'المكان';

  @override
  String get fEta => 'الوقت المتوقع';

  @override
  String get fType => 'النوع';

  @override
  String get fBooking => 'الحجز';

  @override
  String get fTrip => 'الرحلة';

  @override
  String get fDays => 'الأيام';

  @override
  String get fTravelers => 'المسافرون';

  @override
  String get fBudget => 'الميزانية';

  @override
  String get fPaid => 'المدفوع';

  @override
  String get fEstimated => 'التقدير';

  @override
  String get fRating => 'التقييم';

  @override
  String get fArea => 'المنطقة';

  @override
  String get fTier => 'المستوى';

  @override
  String get fPhone => 'الهاتف';

  @override
  String get fConfirmationRate => 'معدل التأكيد';

  @override
  String get fRejectionRate => 'معدل الرفض';

  @override
  String get fCapacity => 'السعة';

  @override
  String get fReserved => 'محجوز';

  @override
  String get fPrice => 'السعر';

  @override
  String get fBasePrice => 'السعر الأساسي';

  @override
  String get fDate => 'التاريخ';

  @override
  String get fNights => 'الليالي';

  @override
  String get fCheckIn => 'الوصول';

  @override
  String get fCheckOut => 'المغادرة';

  @override
  String get fDeposit => 'العربون';

  @override
  String get fSchedule => 'الجدولة';

  @override
  String get fLastRun => 'آخر تشغيل';

  @override
  String get fNextRun => 'التشغيل التالي';

  @override
  String get fFailures => 'الإخفاقات';

  @override
  String get fSource => 'المصدر';

  @override
  String get fConfidence => 'الثقة';

  @override
  String get fDebit => 'مدين';

  @override
  String get fCredit => 'دائن';

  @override
  String get fSeverity => 'الخطورة';

  @override
  String get fMargin => 'الهامش';

  @override
  String get fReply => 'الرد';

  @override
  String get fRooms => 'الغرف';

  @override
  String get fQuantity => 'الكمية';

  @override
  String get fDailyRate => 'السعر اليومي';

  @override
  String get fSlug => 'المعرّف';

  @override
  String get fUpdated => 'آخر تحديث';

  @override
  String get tabTrips => 'الرحلات';

  @override
  String get tabTransfers => 'التنقلات';

  @override
  String get tabProperties => 'العقارات';

  @override
  String get tabStayBookings => 'حجوزات الإقامة';

  @override
  String get tabLedger => 'دفتر الحسابات';

  @override
  String get tabRefunds => 'المبالغ المستردة';

  @override
  String get tabFailedPayments => 'مدفوعات فاشلة';

  @override
  String get tabListings => 'القوائم';

  @override
  String get tabBookings => 'الحجوزات';

  @override
  String get changeStatus => 'تغيير الحالة';

  @override
  String get openBooking => 'فتح الحجز';

  @override
  String get acknowledge => 'إقرار';

  @override
  String get acknowledged => 'تم الإقرار';

  @override
  String get sourceAlert => 'تنبيه السوق';

  @override
  String get sourceSupport => 'الدعم';

  @override
  String get sourceReview => 'قائمة المراجعة';

  @override
  String get sourceGap => 'فجوة معرفية';

  @override
  String get openSupport => 'فتح في الدعم';

  @override
  String get captured => 'المحصّل';

  @override
  String get refunded => 'المسترد';

  @override
  String get commission => 'العمولة';

  @override
  String get escrow => 'الضمان';

  @override
  String get ledgerIntact => 'سلسلة الدفتر سليمة';

  @override
  String get ledgerBroken => 'سلسلة الدفتر معطوبة';

  @override
  String get replyHint => 'اكتب رداً للمسافر';

  @override
  String get sendReply => 'إرسال الرد';

  @override
  String get replySent => 'تم إرسال الرد';

  @override
  String get urgent => 'عاجل';

  @override
  String get sendSms => 'إرسال رسالة نصية';

  @override
  String get smsSent => 'تم إرسال الرسالة';

  @override
  String get smsReplayed => 'أُرسلت مسبقاً. هذه هي النتيجة الأولى.';

  @override
  String get recipientName => 'اسم المستلم';

  @override
  String get sendNotification => 'إرسال إشعار';

  @override
  String get notificationsSendUnavailable =>
      'الإرسال من التطبيق غير متاح بعد: لا توجد نقطة إرسال على الخادم. استخدم لوحة الويب.';

  @override
  String get unread => 'غير مقروء';

  @override
  String get openPortal => 'فتح بوابة المورّد';

  @override
  String get deactivate => 'إلغاء التفعيل';

  @override
  String get activate => 'تفعيل';

  @override
  String get stayApprove => 'قبول';

  @override
  String get stayDecline => 'رفض';

  @override
  String get stayCheckIn => 'تسجيل الوصول';

  @override
  String get stayComplete => 'إكمال';

  @override
  String get stayCancel => 'إلغاء الإقامة';

  @override
  String get editPrice => 'تعديل السعر';

  @override
  String get priceChanged => 'تم تحديث السعر';

  @override
  String get inventorySlots => 'فترات المخزون';

  @override
  String advanceTo(Object status) {
    return 'تحديد كـ $status';
  }

  @override
  String get cancelOrder => 'إلغاء الطلب';

  @override
  String get runNow => 'تشغيل الآن';

  @override
  String get jobQueued => 'تم تشغيل المهمة';

  @override
  String activeJobs(Object count) {
    return '$count مهام نشطة';
  }

  @override
  String get healthDatabase => 'قاعدة البيانات';

  @override
  String get healthLedger => 'دفتر الحسابات';

  @override
  String get healthAi => 'الذكاء الاصطناعي';

  @override
  String get healthPayments => 'المدفوعات';

  @override
  String get healthPush => 'الإشعارات الفورية';

  @override
  String get healthReadiness => 'الجاهزية التجارية';

  @override
  String get simulated => 'محاكاة';

  @override
  String get configured => 'مُعدّ';

  @override
  String get notConfigured => 'غير مُعدّ';

  @override
  String get knowledgeGaps => 'الفجوات';

  @override
  String get knowledgeConflicts => 'التعارضات';

  @override
  String get knowledgeReview => 'المراجعة';

  @override
  String get knowledgeStale => 'حقائق قديمة';

  @override
  String get evidence => 'الأدلة';

  @override
  String get marketSuppliers => 'الموردون المتابعون';

  @override
  String get marketOffers => 'العروض';

  @override
  String get marketObservations => 'رصد الأسعار';

  @override
  String get marketChanges => 'التغييرات الأخيرة';

  @override
  String get marketFreshness => 'الحداثة';

  @override
  String get marketSources => 'المصادر';

  @override
  String get priceIndex => 'رصد الأسعار (ج.م)';

  @override
  String get refreshMarket => 'تحديث بيانات السوق';

  @override
  String get revenueGross => 'إجمالي الحجوزات';

  @override
  String get revenuePayout => 'المستحقات';

  @override
  String get revenueEscrow => 'في الضمان';

  @override
  String get revenueCompletion => 'الإنجاز';

  @override
  String get revenueDaily => 'الإجمالي اليومي مقابل المستحقات';

  @override
  String get revenueByService => 'حسب الخدمة';

  @override
  String get days30 => '30 يوماً';

  @override
  String get days7 => '7 أيام';

  @override
  String get days90 => '90 يوماً';

  @override
  String get reliabilityOverall => 'الإجمالي';

  @override
  String get reliabilityAcceptance => 'القبول';

  @override
  String get reliabilitySpeed => 'سرعة الاستجابة';

  @override
  String get reliabilityCancellation => 'الإلغاء';

  @override
  String sampleSize(Object count) {
    return 'استناداً إلى $count حجز';
  }

  @override
  String get blockDates => 'حجب التواريخ';

  @override
  String get blocked => 'محجوب';

  @override
  String get openDay => 'متاح';

  @override
  String get blockAdded => 'تم حجب التواريخ';

  @override
  String get noSupplier => 'لا يوجد مورّد مرتبط بهذا الحساب.';

  @override
  String get markReturned => 'تحديد كمُعاد';

  @override
  String get cmsPages => 'الصفحات';

  @override
  String get cmsDraft => 'مسودة';

  @override
  String get cmsPublished => 'منشورة';

  @override
  String get cmsArchived => 'مؤرشفة';

  @override
  String get cmsTitleEn => 'العنوان (إنجليزي)';

  @override
  String get cmsTitleAr => 'العنوان (عربي)';

  @override
  String get cmsBodyEn => 'المحتوى (إنجليزي)';

  @override
  String get cmsBodyAr => 'المحتوى (عربي)';

  @override
  String get cmsDescriptionEn => 'الوصف (إنجليزي)';

  @override
  String get cmsDescriptionAr => 'الوصف (عربي)';

  @override
  String get cmsHeroImage => 'رابط الصورة الرئيسية';

  @override
  String get cmsSeo => 'تحسين محركات البحث';

  @override
  String get cmsSeoTitleEn => 'عنوان البحث (إنجليزي)';

  @override
  String get cmsSeoTitleAr => 'عنوان البحث (عربي)';

  @override
  String get cmsSeoDescEn => 'الوصف التعريفي (إنجليزي)';

  @override
  String get cmsSeoDescAr => 'الوصف التعريفي (عربي)';

  @override
  String get cmsCanonical => 'الرابط الأساسي';

  @override
  String get cmsNoindex => 'إخفاء من محركات البحث';

  @override
  String get cmsPublish => 'نشر';

  @override
  String get cmsPublishedToast => 'تم نشر الصفحة';

  @override
  String get cmsRevisions => 'المراجعات';

  @override
  String get cmsUpload => 'رفع صورة';

  @override
  String get cmsUploaded => 'تم رفع الصورة';

  @override
  String get cmsMedia => 'الوسائط';

  @override
  String get cmsAltEn => 'النص البديل (إنجليزي)';

  @override
  String get cmsAltAr => 'النص البديل (عربي)';

  @override
  String cmsTooLarge(Object mb) {
    return 'الصورة أكبر من $mb ميجابايت.';
  }

  @override
  String get cmsUseAsHero => 'استخدام كصورة رئيسية';

  @override
  String get auditTabPlaceholder =>
      'لا تتوفر واجهة لسجل تدقيق المورّد بعد. اطلب السجل الكامل من فريق العمليات.';

  @override
  String get supplierPortal => 'بوابة المورّد';

  @override
  String get sectionLive => 'الرحلات والتنقلات المباشرة';

  @override
  String get back => 'رجوع';

  @override
  String get navCalendar => 'التقويم';

  @override
  String get navPayouts => 'المدفوعات';

  @override
  String get navAccount => 'الحساب';

  @override
  String secondsAgo(int n) {
    return 'قبل $n ث';
  }

  @override
  String feedUpdated(String feed, String ago) {
    return '$feed، حُدّث $ago';
  }

  @override
  String queueSubtitle(int open, int critical) {
    return '$open مفتوحة، $critical حرجة';
  }

  @override
  String get swipeHint => 'اسحب أي مهمة للحل أو التأجيل';

  @override
  String pulseSubtitle(String date) {
    return '$date بتوقيت دهب';
  }

  @override
  String get subsystemApi => 'الواجهة';

  @override
  String get subsystemDatabase => 'قاعدة البيانات';

  @override
  String get subsystemPayments => 'المدفوعات';

  @override
  String get subsystemAi => 'الذكاء';

  @override
  String get kpiArrowsNote =>
      'الأسهم تقارن بالقراءة السابقة. الأخضر تحسّن، والمرجاني تراجع.';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get egp => 'ج.م';

  @override
  String get required => 'إلزامي';

  @override
  String get refundNeedsApprovalTitle => 'يحتاج موافقة مسؤول ثانٍ';

  @override
  String get traveler => 'مسافر';

  @override
  String get supplierLabel => 'مورد';

  @override
  String get controlSubtitle => 'التغييرات تُسجَّل مع السبب';

  @override
  String get groupCommerce => 'التجارة';

  @override
  String get changeNeedsApproval => 'التغيير يحتاج موافقة';

  @override
  String get killSwitchesNote => 'تشغيل يعني إيقاف الخدمة';

  @override
  String get running => 'تعمل';

  @override
  String stoppedBy(String who, String time) {
    return 'متوقف بواسطة $who، $time';
  }

  @override
  String get maintenanceMode => 'وضع الصيانة';

  @override
  String get maintenanceHint => 'يبقى الموظفون متصلين أثناء الصيانة';

  @override
  String get statusHealthyShort => 'سليم';

  @override
  String get accessTitle => 'الصلاحيات';

  @override
  String accessSubtitle(int users, int roles) {
    return '$users مستخدمًا، $roles أدوار';
  }

  @override
  String get reasonAskedOnSave => 'يلزم ذكر السبب عند الحفظ';

  @override
  String guestsCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n ضيفًا',
      few: '$n ضيوف',
      two: 'ضيفان',
      one: 'ضيف واحد',
    );
    return '$_temp0';
  }

  @override
  String requestedAgo(String ago) {
    return 'طُلب $ago';
  }

  @override
  String get paletteFootnote => 'تظهر النتائج حسب صلاحياتك فقط.';

  @override
  String get appNameLatin => 'Dahab Ops';

  @override
  String get groupCatalog => 'الكتالوج';

  @override
  String get sectionCatalog => 'الكتالوج';

  @override
  String get catMyListings => 'قوائمي';

  @override
  String get catSupplierHint =>
      'عدّل قوائمك وأرسلها للمراجعة. ينشر فريق دهب التغييرات المعتمدة.';

  @override
  String get catActions => 'إجراءات';

  @override
  String get catAddDay => 'إضافة يوم';

  @override
  String get catAddItem => 'إضافة صنف';

  @override
  String get catAddPhoto => 'إضافة صورة';

  @override
  String get catAddTag => 'أضف وسمًا ثم اضغط إدخال';

  @override
  String get catAddTime => 'إضافة وقت';

  @override
  String get catArchive => 'أرشفة';

  @override
  String get catArchiveBody =>
      'تختفي القوائم المؤرشفة من الموقع، مع الاحتفاظ بالحجوزات والسجل.';

  @override
  String catArchiveTitle(String name) {
    return 'أرشفة $name؟';
  }

  @override
  String get catArchivedToast => 'تمت الأرشفة';

  @override
  String get catAvailable => 'متاح';

  @override
  String get catCamera => 'التقاط صورة';

  @override
  String get catLibrary => 'اختيار من المعرض';

  @override
  String get catCannotPublish => 'لا يمكن النشر بعد';

  @override
  String get catCapacity => 'السعة لكل موعد';

  @override
  String get catCloseDates => 'إغلاق هذه التواريخ';

  @override
  String get catClosedShort => 'مغلق';

  @override
  String get catConflictBody =>
      'حفظ شخص آخر هذه القائمة أثناء تعديلك. احتفظ بتغييراتك فوق تغييراته، أو أعد تحميل نسخته.';

  @override
  String get catConflictKeep => 'الاحتفاظ بتغييراتي';

  @override
  String get catConflictReload => 'إعادة التحميل';

  @override
  String get catConflictShort => 'تغيّر من مكان آخر';

  @override
  String get catConflictTitle => 'تم التعديل من مكان آخر';

  @override
  String get catCountDrafts => 'مسودات';

  @override
  String get catCountReview => 'قيد المراجعة';

  @override
  String get catCover => 'الغلاف';

  @override
  String get catCustom => 'مخصص';

  @override
  String catDay(int n) {
    return 'اليوم $n';
  }

  @override
  String get catDayBody => 'البرنامج';

  @override
  String get catDayTitle => 'العنوان';

  @override
  String get catDelete => 'حذف';

  @override
  String get catDeleteBody =>
      'لا يمكن حذف إلا المسودات التي لم تُحجز أبدًا، وغير ذلك يُؤرشف.';

  @override
  String catDeleteTitle(String name) {
    return 'حذف $name؟';
  }

  @override
  String get catDeletedToast => 'تم الحذف';

  @override
  String get catDraftSaved => 'تم حفظ المسودة';

  @override
  String get catDuplicate => 'تكرار';

  @override
  String get catDuplicatedToast => 'أُنشئت نسخة كمسودة';

  @override
  String get catEditPrice => 'تعديل السعر';

  @override
  String get catEmptyBody => 'لا شيء هنا بعد. اضغط جديد لإضافة أول عنصر.';

  @override
  String get catFilterSupplier => 'تصفية حسب المورّد';

  @override
  String catFromPrice(String price) {
    return 'من $price';
  }

  @override
  String get catHiddenToast => 'أُخفي من الموقع';

  @override
  String get catHide => 'إخفاء';

  @override
  String catHoursShort(int h) {
    return '$h س';
  }

  @override
  String catMinutesShort(int m) {
    return '$m د';
  }

  @override
  String get catMinutesUnit => 'دقيقة';

  @override
  String get catInUseBody =>
      'لهذه القائمة حجوزات، لذا لا يمكن حذفها. هل تريد أرشفتها بدلًا من ذلك؟';

  @override
  String get catInUseTitle => 'قيد الاستخدام';

  @override
  String get catInvalidJson => 'صيغة JSON غير صالحة';

  @override
  String get catItemName => 'اسم الصنف';

  @override
  String get catLat => 'خط العرض';

  @override
  String get catLng => 'خط الطول';

  @override
  String get catMenu => 'القائمة';

  @override
  String get catMenuOther => 'أخرى';

  @override
  String catMissingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ينقص $count',
      one: 'ينقص حقل واحد',
    );
    return '$_temp0';
  }

  @override
  String catMissingLang(String lang) {
    return 'ينقص $lang';
  }

  @override
  String catMissingTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ينقص $count قبل النشر',
      one: 'ينقص شيء واحد قبل النشر',
    );
    return '$_temp0';
  }

  @override
  String get catNew => 'جديد';

  @override
  String get catNewSection => 'أو اكتب قسمًا جديدًا';

  @override
  String catNewType(String type) {
    return 'جديد · $type';
  }

  @override
  String get catNextStep => 'حفظ والتالي';

  @override
  String get catNightlyPrice => 'السعر لليلة';

  @override
  String catNights(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ليالٍ',
      one: 'ليلة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get catNoRooms => 'أضف غرفة أولًا';

  @override
  String get catNoSupplier => 'اختر المورّد';

  @override
  String get catNotSaved => 'لم يُحفظ بعد';

  @override
  String get catOrders => 'الحجوزات والطلبات';

  @override
  String catPhotoHint(int count, int max) {
    return '$count من $max · اضغط مطولًا واسحب لإعادة الترتيب · الصورة الأولى هي الغلاف';
  }

  @override
  String get catPrice => 'السعر';

  @override
  String catPriceReasonBody(String from, String to) {
    return 'التغيير من $from إلى $to أكثر من 30٪. اذكر السبب.';
  }

  @override
  String get catPriceReasonTitle => 'تغيير كبير في السعر';

  @override
  String get catPublish => 'نشر';

  @override
  String get catPublishChanges => 'نشر التغييرات';

  @override
  String get catPublishedToast => 'تم النشر';

  @override
  String get catRangeHint =>
      'اضغط على يوم، أو اضغط مطولًا واسحب عبر الأيام، ثم حدّد السعر أو أغلقها.';

  @override
  String get catRates => 'تقويم الأسعار';

  @override
  String get catRequired => 'مطلوب';

  @override
  String get catRestore => 'استعادة';

  @override
  String get catRestoredToast => 'تمت الاستعادة';

  @override
  String get catRooms => 'الغرف';

  @override
  String get catSaveDraft => 'حفظ كمسودة';

  @override
  String get catSaveFailed => 'لم يُحفظ. ستُعاد المحاولة عند التعديل التالي.';

  @override
  String get catSaving => 'جارٍ الحفظ…';

  @override
  String get catSearchSuppliers => 'ابحث عن مورّد';

  @override
  String get catSection => 'القسم';

  @override
  String get catSlots => 'المواعيد';

  @override
  String get catSlotsHint =>
      'اضغط مطولًا واسحب عبر الأيام لتحديد الأوقات والسعة، أو أغلقها.';

  @override
  String get catStatusArchived => 'مؤرشف';

  @override
  String get catStatusDraft => 'مسودة';

  @override
  String get catStatusHidden => 'مخفي';

  @override
  String get catStatusPublished => 'منشور';

  @override
  String get catStatusReview => 'قيد المراجعة';

  @override
  String get catStepBasics => 'الأساسيات';

  @override
  String get catStepPhotos => 'الصور';

  @override
  String get catStepPrice => 'السعر';

  @override
  String get catSubmitReview => 'إرسال للمراجعة';

  @override
  String get catSubmittedToast => 'أُرسلت إلى دهب للمراجعة';

  @override
  String get catTimes => 'أوقات البدء';

  @override
  String get catUnsaved => 'تغييرات غير محفوظة';

  @override
  String get catUntitled => 'بدون عنوان';

  @override
  String get catWeekdays => 'تطبيق على';

  @override
  String get killPaymentsTitle => 'المدفوعات';

  @override
  String get killPaymentsDesc => 'يوقف الدفع وتحصيل المبالغ';

  @override
  String get killBookingsTitle => 'الحجوزات';

  @override
  String get killBookingsDesc => 'يوقف الحجوزات والطلبات الجديدة';

  @override
  String get killAiTitle => 'ميزات الذكاء الاصطناعي';

  @override
  String get killAiDesc => 'يوقف خدمات الذكاء الاصطناعي (DayGI وتخطيط الرحلات)';

  @override
  String get killSmsTitle => 'الرسائل النصية الصادرة';

  @override
  String get killSmsDesc => 'يوقف إرسال الرسائل النصية';

  @override
  String get killSupplierSignupTitle => 'تسجيل الموردين';

  @override
  String get killSupplierSignupDesc => 'يوقف تسجيل الموردين الذاتي';

  @override
  String get flagMaintenanceTitle => 'وضع الصيانة';

  @override
  String get flagMaintenanceDesc => 'طلبات غير الموظفين تتلقى 503';

  @override
  String get actorSystem => 'النظام';

  @override
  String get allPermissions => 'كل الصلاحيات';

  @override
  String get listSeparator => '، ';

  @override
  String get roleTraveler => 'مسافر';

  @override
  String get roleSupplier => 'مورد';

  @override
  String get roleOperations => 'التشغيل';

  @override
  String get roleProduct => 'المنتج';

  @override
  String get roleAdmin => 'مسؤول';

  @override
  String get ccHubSubtitle => 'مكتب واحد للويب وتطبيقَي الموبايل';

  @override
  String get ccGroupApp => 'التطبيق والمحتوى';

  @override
  String get ccGroupPlatform => 'المنصة';

  @override
  String get ccTileExperience => 'تجربة التطبيق';

  @override
  String get ccTileExperienceSub => 'الصيانة والبانر والمفاتيح والإصدارات';

  @override
  String get ccTileHomepage => 'أقسام الصفحة الرئيسية';

  @override
  String get ccTileHomepageSub => 'الترتيب والإظهار وإعدادات كل قسم';

  @override
  String get ccTileProgrammes => 'برامج الرحلات';

  @override
  String get ccTileProgrammesSub => 'الرحلات الجاهزة التي يعرضها التطبيقان';

  @override
  String get ccTileNavigation => 'قوائم التنقل';

  @override
  String get ccTileNavigationSub => 'قوائم الويب المُدارة من النظام';

  @override
  String get ccTileCmsSub => 'الصفحات والنشر والوسائط';

  @override
  String get ccTileSettingsSub => 'إعدادات مُنظمة بسجل واسترجاع';

  @override
  String get ccTileFlagsSub => 'مفاتيح الميزات والتوجيه';

  @override
  String get ccTileIntegrationsSub => 'صحة المزودين الحية';

  @override
  String get ccTileApprovalsSub => 'تغييرات بانتظار موافقة أدمن ثانٍ';

  @override
  String get ccTileUsers => 'المستخدمون والأدوار';

  @override
  String get ccTileUsersSub => 'الحسابات والأدوار والاستثناءات';

  @override
  String get ccTileAuditSub => 'كل تغيير: من وماذا ولماذا';

  @override
  String get ccMaintenanceOn => 'المنصة تحت الصيانة';

  @override
  String get ccMaintenanceOnSub => 'المسافرون يرون شاشة الصيانة حتى ترفعها.';

  @override
  String ccKillsOn(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count خدمات معطلة',
      one: 'خدمة واحدة معطلة',
      zero: 'لا مفاتيح معطلة',
    );
    return '$_temp0';
  }

  @override
  String get ccAllClear => 'كل شيء يعمل';

  @override
  String get ccAllClearSub => 'لا صيانة ولا مفاتيح معطلة.';

  @override
  String get ccReadingApprovals => 'الموافقات';

  @override
  String get ccReadingKills => 'خدمات معطلة';

  @override
  String get ccReadingIntegrations => 'متدهورة';

  @override
  String get previewQuiet => 'المسافر يرى التطبيق طبيعياً';

  @override
  String ccSaveSettingTitle(Object key) {
    return 'تغيير $key؟';
  }

  @override
  String get ccMaintenanceHint => 'يحوّل كل العملاء لشاشة الصيانة.';

  @override
  String get ccPreviewEn => 'معاينة - إنجليزي';

  @override
  String get ccPreviewAr => 'معاينة - عربي';

  @override
  String get ccAnnouncementTitle => 'بانر الإعلان';

  @override
  String get ccAnnouncementNote => 'يظهر أعلى كل تطبيق';

  @override
  String get ccBannerOn => 'البانر ظاهر';

  @override
  String get ccBannerOff => 'لا بانر';

  @override
  String get ccBannerInfo => 'النبرة: معلومة';

  @override
  String get ccBannerWarn => 'النبرة: تحذير';

  @override
  String get ccBannerEnable => 'إظهار بانر الإعلان؟';

  @override
  String get ccBannerDisable => 'إخفاء بانر الإعلان؟';

  @override
  String get ccFeatureFlags => 'مفاتيح الميزات';

  @override
  String get ccFlagsManageAll => 'إدارة الكل';

  @override
  String ccRolloutReading(Object value) {
    return '$value توزيع';
  }

  @override
  String get ccFlagOn => 'مفعل';

  @override
  String get ccFlagOff => 'متوقف';

  @override
  String get ccFlagEnable => 'تفعيل';

  @override
  String get ccFlagDisable => 'إيقاف';

  @override
  String ccFlagEnableTitle(Object key) {
    return 'تفعيل $key؟';
  }

  @override
  String ccFlagDisableTitle(Object key) {
    return 'إيقاف $key؟';
  }

  @override
  String get ccFlagEngaged => 'متوقف';

  @override
  String get ccFlagNormal => 'يعمل';

  @override
  String ccKillEngageTitle(Object title) {
    return 'إيقاف $title؟';
  }

  @override
  String ccKillReleaseTitle(Object title) {
    return 'إعادة تشغيل $title؟';
  }

  @override
  String get ccGatesTitle => 'بوابات إصدارات التطبيق';

  @override
  String get ccGatesNote => 'إجبار التحديث أو اقتراحه';

  @override
  String get ccPlatformAndroid => 'أندرويد';

  @override
  String get ccPlatformIos => 'iOS';

  @override
  String get ccMinVersion => 'أقل إصدار';

  @override
  String get ccLatestVersion => 'أحدث إصدار';

  @override
  String get ccStoreUrl => 'رابط المتجر';

  @override
  String get ccSimulatorTitle => 'محاكاة إصدار';

  @override
  String get ccSimulatorHint => 'إصدار التطبيق، مثل 1.2.0';

  @override
  String get ccSimulatorEmpty => 'اكتب إصداراً لرؤية نتيجة البوابة.';

  @override
  String get ccVersionInvalid => 'استخدم إصداراً مثل 1.2.0.';

  @override
  String get ccGateBlocked => 'التحديث إجباري';

  @override
  String get ccGateUpdate => 'يُنصح بالتحديث';

  @override
  String get ccGateOk => 'محدّث';

  @override
  String get ccHomepageEmpty => 'لا أقسام بعد';

  @override
  String get ccHomepageHint =>
      'اسحب لإعادة الترتيب. الترتيب والإظهار ينعكسان على الويب فوراً.';

  @override
  String get ccHomepageReordered => 'تم حفظ الترتيب.';

  @override
  String get ccVisible => 'ظاهر';

  @override
  String get ccTitleEn => 'العنوان (إنجليزي)';

  @override
  String get ccTitleAr => 'العنوان (عربي)';

  @override
  String get ccConfigJson => 'إعدادات القسم (JSON)';

  @override
  String get ccInvalidJson => 'هذا ليس JSON صالحاً.';

  @override
  String get ccConfigMustBeObject => 'الإعدادات يجب أن تكون كائن JSON.';

  @override
  String get ccProgrammeNew => 'برنامج جديد';

  @override
  String get ccAll => 'الكل';

  @override
  String get ccAllDestinations => 'كل الوجهات';

  @override
  String get ccDraft => 'مسودة';

  @override
  String get ccArchived => 'مؤرشف';

  @override
  String get ccDestDahab => 'دهب';

  @override
  String get ccDestNuweiba => 'نويبع';

  @override
  String get ccDestSiwa => 'سيوة';

  @override
  String get ccProgrammesEmpty => 'لا برامج مطابقة';

  @override
  String get ccProgrammesEmptyBody => 'عدّل الفلاتر أو أنشئ برنامجاً جديداً.';

  @override
  String get ccProgrammeId => 'المعرف (ثابت، مثل dahab-slow-weekend)';

  @override
  String get ccTaglineEn => 'الوصف المختصر (إنجليزي)';

  @override
  String get ccTaglineAr => 'الوصف المختصر (عربي)';

  @override
  String get ccDestination => 'الوجهة';

  @override
  String get ccPace => 'الإيقاع';

  @override
  String get ccBudget => 'الميزانية الافتراضية';

  @override
  String get ccDurationDays => 'الأيام';

  @override
  String get ccPriceEgp => 'السعر من (جنيه)';

  @override
  String get ccPriceEstimate => 'السعر تقديري';

  @override
  String get ccPriceEstimateHint => 'صحيح بينما لا يسعّره مورّد بعد';

  @override
  String get ccIdealForEn => 'مناسب لـ (إنجليزي)';

  @override
  String get ccIdealForAr => 'مناسب لـ (عربي)';

  @override
  String get ccHighlightsEn => 'المميزات (إنجليزي)';

  @override
  String get ccHighlightsAr => 'المميزات (عربي)';

  @override
  String get ccCommaSeparated => 'افصل العناصر بفاصلة';

  @override
  String get ccDayByDay => 'يوم بيوم';

  @override
  String get ccAddDay => 'إضافة يوم';

  @override
  String get ccNoDaysYet => 'لا أيام مخططة بعد.';

  @override
  String get ccSubtitleEn => 'العنوان الفرعي (إنجليزي)';

  @override
  String get ccTimeEstimate => 'تقدير الوقت';

  @override
  String get ccCreate => 'إنشاء البرنامج';

  @override
  String get ccProgrammeCreateConfirm => 'إنشاء هذا البرنامج؟';

  @override
  String get ccProgrammePublishConfirm => 'نشر هذا البرنامج؟';

  @override
  String get ccProgrammePublishBody => 'سيظهر على الويب وتطبيق REHLA فوراً.';

  @override
  String get ccProgrammeArchiveConfirm => 'أرشفة هذا البرنامج؟';

  @override
  String get ccProgrammeArchiveBody =>
      'سيختفي من التطبيقين ويبقى في الداش بورد.';

  @override
  String get ccArchivedToast => 'تمت أرشفة البرنامج.';

  @override
  String get ccProgrammeDeleteConfirm => 'حذف هذا البرنامج؟';

  @override
  String get ccProgrammeDeleteBody => 'لا يمكن التراجع. الأرشفة أفضل عادة.';

  @override
  String get ccProgrammeDeleted => 'تم حذف البرنامج.';

  @override
  String get deleteLabel => 'حذف';

  @override
  String get noticeFailed => 'لم يتم تنفيذ التغيير.';

  @override
  String get ccNavItemNew => 'عنصر تنقل جديد';

  @override
  String get ccNavItemEdit => 'تعديل عنصر التنقل';

  @override
  String get ccNavEmpty => 'لا عناصر في هذه القائمة';

  @override
  String get ccNavEmptyBody => 'أنشئ أول عنصر لهذه القائمة.';

  @override
  String get ccNavRoute => 'المسار';

  @override
  String get ccNavRouteHint => 'مسار داخلي مثل /hotels';

  @override
  String get ccNavExternal => 'رابط خارجي';

  @override
  String get ccNavOrder => 'الترتيب';

  @override
  String get ccHidden => 'مخفي';

  @override
  String ccNavDeleteTitle(Object label) {
    return 'حذف $label؟';
  }

  @override
  String get ccNavLabelRequired => 'الاسم مطلوب.';
}
