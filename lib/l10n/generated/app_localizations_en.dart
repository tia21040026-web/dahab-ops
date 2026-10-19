// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Dahab Ops';

  @override
  String get retry => 'Try again';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get close => 'Close';

  @override
  String get save => 'Save';

  @override
  String get done => 'Done';

  @override
  String get copy => 'Copy';

  @override
  String get copied => 'Copied';

  @override
  String get search => 'Search';

  @override
  String get refresh => 'Refresh';

  @override
  String get loadMore => 'Load more';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get remove => 'Remove';

  @override
  String get apply => 'Apply';

  @override
  String get reset => 'Reset';

  @override
  String get all => 'All';

  @override
  String get optional => 'Optional';

  @override
  String get unknown => 'Unknown';

  @override
  String get justNow => 'just now';

  @override
  String get errorGeneric => 'Something went wrong.';

  @override
  String get errorNetwork =>
      'Can\'t reach the Dahab servers. Check your connection.';

  @override
  String get errorTimeout => 'The server took too long to answer.';

  @override
  String get errorUnauthorized => 'Your session ended. Sign in again.';

  @override
  String get errorForbidden => 'You don\'t have permission for this.';

  @override
  String get errorNotFound => 'We couldn\'t find that.';

  @override
  String get errorServer => 'The server had a problem. It has been logged.';

  @override
  String get errorKillSwitch => 'This capability is switched off right now.';

  @override
  String get errorMaintenance => 'Dahab is in maintenance mode.';

  @override
  String get errorViewAsReadonly =>
      'View-as is read-only. End it to make changes.';

  @override
  String get correlationId => 'Reference';

  @override
  String get copyReference => 'Copy reference';

  @override
  String get offlineBanner => 'You\'re offline. Showing the last data we have.';

  @override
  String get loginTitle => 'Sign in to run the day in Dahab';

  @override
  String get loginSubtitle =>
      'For Dahab staff and partner suppliers. Travelers use the Dahab app.';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get signIn => 'Sign in';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get emailInvalid => 'Enter a valid email address.';

  @override
  String get passwordRequired => 'Enter your password.';

  @override
  String get invalidCredentials => 'Email or password is incorrect.';

  @override
  String get notStaff => 'This account has no staff access.';

  @override
  String get restoringSession => 'Restoring your session…';

  @override
  String get logout => 'Sign out';

  @override
  String get logoutConfirm => 'Sign out of Dahab Ops on this device?';

  @override
  String get or => 'or';

  @override
  String get unlockWithFaceId => 'Unlock with Face ID';

  @override
  String staffOnlyNote(String device) {
    return 'Staff only. This device is registered as $device. Sessions end after 12 hours.';
  }

  @override
  String get buildStamp => 'Build 1.0.0 (204)';

  @override
  String get controlTitle => 'Control';

  @override
  String get myDevices => 'My devices';

  @override
  String get thisDevice => 'This device';

  @override
  String get revokeDevice => 'Sign out device';

  @override
  String get deviceRevoked => 'Device signed out';

  @override
  String get devicesEmpty => 'No devices are signed in.';

  @override
  String get appLocked => 'Dahab Ops is locked';

  @override
  String get appLockedBody => 'Unlock to continue where you left off.';

  @override
  String get unlock => 'Unlock';

  @override
  String get unlockReason => 'Unlock Dahab Ops';

  @override
  String get biometricLock => 'Biometric app lock';

  @override
  String get biometricLockHint =>
      'Ask for Face ID or fingerprint when you come back to the app.';

  @override
  String get biometricUnavailable =>
      'Biometrics aren\'t set up on this device.';

  @override
  String get navPulse => 'Pulse';

  @override
  String get navQueue => 'Queue';

  @override
  String get navLive => 'Live';

  @override
  String get navInbox => 'Inbox';

  @override
  String get navMore => 'More';

  @override
  String get navInventory => 'Inventory';

  @override
  String get navRevenue => 'Revenue';

  @override
  String get sectionOverview => 'Overview';

  @override
  String get sectionCore => 'Intelligence Core';

  @override
  String get sectionTrips => 'Live Trips';

  @override
  String get sectionTransfers => 'Transfers';

  @override
  String get sectionExceptions => 'Exceptions';

  @override
  String get sectionCommerce => 'Commerce';

  @override
  String get sectionAccommodations => 'Accommodations';

  @override
  String get sectionStays => 'Stays';

  @override
  String get sectionSuppliers => 'Suppliers';

  @override
  String get sectionIntelligence => 'Intelligence';

  @override
  String get sectionOpportunities => 'Opportunities';

  @override
  String get sectionKnowledge => 'Knowledge';

  @override
  String get sectionSupport => 'Support';

  @override
  String get sectionSms => 'SMS Center';

  @override
  String get sectionNotifications => 'Notifications';

  @override
  String get sectionAudit => 'Audit Log';

  @override
  String get sectionFlags => 'Feature Flags';

  @override
  String get sectionJobs => 'Market Jobs';

  @override
  String get sectionHealth => 'System Health';

  @override
  String get sectionCms => 'CMS Content';

  @override
  String get sectionPricing => 'Pricing & Inventory';

  @override
  String get sectionDining => 'Dining Orders';

  @override
  String get sectionMarket => 'Market Intelligence';

  @override
  String get supplierInbox => 'Supplier inbox';

  @override
  String get supplierInventory => 'Inventory';

  @override
  String get supplierResources => 'Resources';

  @override
  String get supplierStays => 'Stays';

  @override
  String get supplierRentals => 'Rentals';

  @override
  String get supplierRevenue => 'Revenue';

  @override
  String get supplierReliability => 'Reliability';

  @override
  String get supplierAudit => 'Activity log';

  @override
  String get controlUsers => 'Users';

  @override
  String get controlInvite => 'Invite staff';

  @override
  String get controlRoles => 'Roles & permissions';

  @override
  String get controlSettings => 'Settings';

  @override
  String get controlFlags => 'Flags & kill switches';

  @override
  String get controlMaintenance => 'Maintenance mode';

  @override
  String get controlIntegrations => 'Integrations';

  @override
  String get controlApprovals => 'Approvals';

  @override
  String get controlAudit => 'Audit timeline';

  @override
  String get groupCore => 'Core';

  @override
  String get groupDomain => 'Operations';

  @override
  String get groupSystem => 'System';

  @override
  String get groupSupplier => 'Supplier';

  @override
  String get groupMarket => 'Market & content';

  @override
  String get groupControl => 'Control';

  @override
  String get groupAccount => 'Account';

  @override
  String get comingNextTitle => 'Coming next';

  @override
  String get comingNextBody =>
      'This section is being rebuilt for mobile. Until it lands, use the web command center.';

  @override
  String get comingNextAccess => 'Your access';

  @override
  String get pulseTitle => 'Pulse';

  @override
  String get statusHealthy => 'All systems healthy';

  @override
  String get statusDegraded => 'Degraded';

  @override
  String get statusActionRequired => 'Action required';

  @override
  String get live => 'Live';

  @override
  String get polling => 'Polling';

  @override
  String get reconnecting => 'Reconnecting';

  @override
  String get kpiActiveTrips => 'Active trips';

  @override
  String get kpiPendingBookings => 'Pending bookings';

  @override
  String get kpiSupplierConfirmations => 'Supplier confirmations';

  @override
  String get kpiPaymentIssues => 'Payment issues';

  @override
  String get kpiExceptions => 'Exceptions';

  @override
  String get kpiAtRisk => 'At-risk trips';

  @override
  String get kpiUnreadSupport => 'Open support';

  @override
  String get kpiActiveTransfers => 'Active transfers';

  @override
  String get actionQueue => 'Action queue';

  @override
  String get viewAll => 'View all';

  @override
  String get queueEmpty => 'Nothing needs you right now';

  @override
  String get queueEmptyBody => 'New work appears here the moment it lands.';

  @override
  String get priorityCritical => 'Critical';

  @override
  String get priorityHigh => 'High';

  @override
  String get priorityMedium => 'Medium';

  @override
  String get priorityLow => 'Low';

  @override
  String get searchHint => 'Search bookings, people, suppliers…';

  @override
  String get recent => 'Recent';

  @override
  String get clearRecent => 'Clear';

  @override
  String get noResults => 'No matches';

  @override
  String get searchEmptyBody =>
      'Search bookings, users, suppliers and properties you can access.';

  @override
  String get typeBooking => 'Booking';

  @override
  String get typeUser => 'User';

  @override
  String get typeSupplier => 'Supplier';

  @override
  String get typeProperty => 'Property';

  @override
  String get filters => 'Filters';

  @override
  String get sort => 'Sort';

  @override
  String get ascending => 'Ascending';

  @override
  String get descending => 'Descending';

  @override
  String get newest => 'Newest first';

  @override
  String get oldest => 'Oldest first';

  @override
  String get nameSort => 'Name';

  @override
  String get lastSeenSort => 'Last seen';

  @override
  String get dangerReasonLabel => 'Reason';

  @override
  String get dangerReasonHint =>
      'Why are you doing this? It is saved to the audit log.';

  @override
  String get dangerReasonTooShort => 'Write at least 3 characters.';

  @override
  String get approvalNotice =>
      'This change needs a second admin. It will be queued for approval.';

  @override
  String get biometricConfirmReason => 'Confirm this sensitive action';

  @override
  String get biometricFailed => 'Biometric check failed.';

  @override
  String get noAccessTitle => 'No access';

  @override
  String get noAccessBody => 'Ask an admin for the permission below.';

  @override
  String get usersTitle => 'Users';

  @override
  String get usersSearch => 'Search name or email';

  @override
  String get filterRole => 'Role';

  @override
  String get filterStatus => 'Status';

  @override
  String get statusActive => 'Active';

  @override
  String get statusSuspended => 'Suspended';

  @override
  String get role => 'Role';

  @override
  String get changeRole => 'Change role';

  @override
  String get suspend => 'Suspend';

  @override
  String get reactivate => 'Reactivate';

  @override
  String get suspendTitle => 'Suspend this user?';

  @override
  String get suspendBody =>
      'They are signed out everywhere and cannot sign in until reactivated.';

  @override
  String get overrides => 'Permission overrides';

  @override
  String get overridesHint => 'Overrides win over the role. Deny beats grant.';

  @override
  String get addOverride => 'Add override';

  @override
  String get grant => 'Grant';

  @override
  String get deny => 'Deny';

  @override
  String get effectivePermissions => 'Effective permissions';

  @override
  String get revokeSessions => 'Revoke all sessions';

  @override
  String get revokeSessionsTitle => 'Sign this user out everywhere?';

  @override
  String get devices => 'Devices';

  @override
  String get viewAs => 'View as this user';

  @override
  String get endViewAs => 'End';

  @override
  String get inviteStaff => 'Invite staff';

  @override
  String get name => 'Name';

  @override
  String get phone => 'Phone';

  @override
  String get supplierId => 'Supplier ID';

  @override
  String get invite => 'Send invite';

  @override
  String get tempPasswordTitle => 'Temporary password';

  @override
  String get tempPasswordBody =>
      'Shown once. Share it through a secure channel; it must be changed at first sign in.';

  @override
  String get nameRequired => 'Enter a name.';

  @override
  String get roleRequired => 'Pick a role.';

  @override
  String get rolesTitle => 'Roles & permissions';

  @override
  String get systemRole => 'System';

  @override
  String get permissionMatrix => 'Permission matrix';

  @override
  String get dangerous => 'Dangerous';

  @override
  String get newRole => 'New role';

  @override
  String get roleName => 'Role name';

  @override
  String get roleDescription => 'Description';

  @override
  String get deleteRole => 'Delete role';

  @override
  String get deleteRoleTitle => 'Delete this role?';

  @override
  String get saved => 'Saved';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get history => 'History';

  @override
  String get rollback => 'Roll back';

  @override
  String get invalidJson => 'That isn\'t valid JSON.';

  @override
  String get invalidNumber => 'Enter a number.';

  @override
  String get flagsTitle => 'Flags & kill switches';

  @override
  String get killSwitches => 'Kill switches';

  @override
  String get featureFlags => 'Feature flags';

  @override
  String get rollout => 'Rollout';

  @override
  String get killSwitchWarning =>
      'Turning this on switches the capability off for every user, immediately.';

  @override
  String get enabled => 'On';

  @override
  String get disabled => 'Off';

  @override
  String get maintenanceTitle => 'Maintenance mode';

  @override
  String get maintenanceOn => 'Maintenance is on';

  @override
  String get maintenanceOff => 'Maintenance is off';

  @override
  String get maintenanceBody =>
      'While on, travelers and suppliers get a maintenance page. Staff and sign-in keep working.';

  @override
  String get messageEn => 'Message (English)';

  @override
  String get messageAr => 'Message (Arabic)';

  @override
  String get saveMessage => 'Save message';

  @override
  String get integrationsTitle => 'Integrations';

  @override
  String get checkNow => 'Check now';

  @override
  String get latency => 'Latency';

  @override
  String get mode => 'Mode';

  @override
  String get sandbox => 'Sandbox';

  @override
  String get liveMode => 'Live';

  @override
  String get keyHint => 'Key';

  @override
  String get statusDown => 'Down';

  @override
  String get statusOff => 'Disabled';

  @override
  String get statusUnconfigured => 'Not configured';

  @override
  String get approvalsTitle => 'Approvals';

  @override
  String get pending => 'Pending';

  @override
  String get approved => 'Approved';

  @override
  String get rejected => 'Rejected';

  @override
  String get approve => 'Approve';

  @override
  String get reject => 'Reject';

  @override
  String get decisionNote => 'Note (optional)';

  @override
  String get ownHidden =>
      'Requests you made are hidden. Another admin decides them.';

  @override
  String get approvalsEmpty => 'No approvals waiting';

  @override
  String get auditTitle => 'Audit timeline';

  @override
  String get actor => 'Actor';

  @override
  String get action => 'Action';

  @override
  String get entity => 'Entity';

  @override
  String get dateRange => 'Date range';

  @override
  String get before => 'Before';

  @override
  String get after => 'After';

  @override
  String get noChanges => 'No field changes recorded.';

  @override
  String get auditEmpty => 'No audit events match';

  @override
  String get device => 'Device';

  @override
  String get appearance => 'Appearance';

  @override
  String get theme => 'Theme';

  @override
  String get themeAbyss => 'Abyss';

  @override
  String get themeSalt => 'Salt';

  @override
  String get themeHighContrast => 'High contrast';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get security => 'Security';

  @override
  String get signedInAs => 'Signed in as';

  @override
  String get emptyList => 'Nothing here yet';

  @override
  String get details => 'Details';

  @override
  String get payload => 'Payload';

  @override
  String get commandPalette => 'Command palette';

  @override
  String get actionFailed => 'That didn\'t go through.';

  @override
  String updatedAgo(String time) {
    return 'Updated $time';
  }

  @override
  String minutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count min ago',
      one: '1 min ago',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count h ago',
      one: '1 h ago',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: 'yesterday',
    );
    return '$_temp0';
  }

  @override
  String approvalQueued(String id) {
    return 'Queued for approval · $id';
  }

  @override
  String lastSeen(String time) {
    return 'Last seen $time';
  }

  @override
  String deviceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count devices',
      one: '1 device',
      zero: 'No devices',
    );
    return '$_temp0';
  }

  @override
  String usersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count users',
      one: '1 user',
      zero: 'No users',
    );
    return '$_temp0';
  }

  @override
  String revokedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessions revoked',
      one: '1 session revoked',
    );
    return '$_temp0';
  }

  @override
  String viewAsBanner(String email) {
    return 'Viewing as $email · read-only';
  }

  @override
  String versionLabel(int version) {
    return 'v$version';
  }

  @override
  String rollbackTo(int version) {
    return 'Roll back to v$version?';
  }

  @override
  String requestedBy(String name) {
    return 'Requested by $name';
  }

  @override
  String changesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count changes',
      one: '1 change',
      zero: 'No changes',
    );
    return '$_temp0';
  }

  @override
  String permissionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count permissions',
      one: '1 permission',
    );
    return '$_temp0';
  }

  @override
  String grantedOf(int granted, int total) {
    return '$granted of $total';
  }

  @override
  String latencyMs(int ms) {
    return '$ms ms';
  }

  @override
  String confirmToggle(String name, String state) {
    return 'Turn $name $state?';
  }

  @override
  String changeRoleTo(String role) {
    return 'Change role to $role?';
  }

  @override
  String saveSettingTitle(String key) {
    return 'Save $key?';
  }

  @override
  String get queueTitle => 'Queue';

  @override
  String get needsAction => 'Needs action';

  @override
  String get filterAll => 'All';

  @override
  String get filterCritical => 'Critical';

  @override
  String get filterSuppliers => 'Suppliers';

  @override
  String get filterPayments => 'Payments';

  @override
  String get filterSupport => 'Support';

  @override
  String get snooze => 'Snooze';

  @override
  String get resolve => 'Resolve';

  @override
  String get overdue => 'overdue';

  @override
  String get slaLeft => 'left';

  @override
  String get accept => 'Accept';

  @override
  String get decline => 'Decline';

  @override
  String get declineBookingTitle => 'Decline this booking?';

  @override
  String get declineReasonHint => 'Tell the desk why (wind, overbooked, …)';

  @override
  String get total => 'Total';

  @override
  String get guests => 'Guests';

  @override
  String get commissionRate => 'Commission';

  @override
  String get commissionNeedsApproval => 'Changes need approval';

  @override
  String get rebook => 'Rebook';

  @override
  String get reviewRefund => 'Review refund';

  @override
  String get timelineBooked => 'Booked';

  @override
  String get timelinePaid => 'Paid';

  @override
  String get timelinePickup => 'Pickup';

  @override
  String get paymentsLedger => 'Payments ledger';

  @override
  String get ledgerCharge => 'Charge';

  @override
  String ledgerCommission(Object rate) {
    return 'Commission $rate';
  }

  @override
  String get ledgerPayout => 'Supplier payout';

  @override
  String get ledgerNet => 'Net to Dahab';

  @override
  String get refund => 'Refund';

  @override
  String get refundAction => 'Refund a booking';

  @override
  String refundSheetSub(Object paid) {
    return 'Paid $paid. Choose how much of it goes back.';
  }

  @override
  String refundOf(Object paid) {
    return 'of $paid';
  }

  @override
  String get refundFull => 'Full';

  @override
  String get refundReason => 'Reason';

  @override
  String get reasonSupplierCancelled => 'Supplier cancelled';

  @override
  String get reasonWeather => 'Weather';

  @override
  String get reasonNotDelivered => 'Not delivered';

  @override
  String get reasonDuplicateCharge => 'Duplicate charge';

  @override
  String get refundNoteHint => 'What happened, in one or two lines';

  @override
  String get refundNeedsApproval =>
      'Above the approval threshold: a second admin approves after you.';

  @override
  String get requestApprovalWithFaceId => 'Request approval with Face ID';

  @override
  String get refundAuditNote => 'Logged to the audit trail under your name.';

  @override
  String get refundToGuest => 'To guest card';

  @override
  String get refundCommissionReversed => 'Commission reversed';

  @override
  String get refundFromPayout => 'Taken from supplier payout';

  @override
  String get refundQueuedTitle => 'Queued for a second admin';

  @override
  String get refundQueuedBody =>
      'The guest is refunded once an admin approves.';

  @override
  String get refundDoneTitle => 'Refund issued';

  @override
  String refundDoneBody(Object amount) {
    return '$amount goes back to the guest card.';
  }

  @override
  String get inboxWaiting => 'Waiting on you';

  @override
  String get inboxEarnings => 'Earnings';

  @override
  String get inboxReliability => 'Reliability';

  @override
  String get inboxPending => 'Pending';

  @override
  String get inboxConfirmed => 'Confirmed';

  @override
  String get inboxDeclined => 'Declined';

  @override
  String get kpiUnreadNotifications => 'Unread notifications';

  @override
  String get actionsTitle => 'Actions';

  @override
  String get saveRole => 'Save role';

  @override
  String get valueLabel => 'Value';

  @override
  String get editOverrides => 'Edit overrides';

  @override
  String effectivePermissionsCount(Object count) {
    return '$count permissions in effect';
  }

  @override
  String get dangerConfirmBiometric => 'Confirm with Face ID';

  @override
  String get dangerAuditNote => 'Logged to the audit trail with your reason.';

  @override
  String get dangerApprovalTitle => 'Needs a second admin';

  @override
  String get errorTitle => 'Something went wrong';

  @override
  String get errorConflict =>
      'Someone changed this first. Refresh and try again.';

  @override
  String get errorValidation => 'Some fields need attention.';

  @override
  String get offlineShort => 'Offline';

  @override
  String get sortBy => 'Sort by';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String slaMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count min',
      one: '1 min',
    );
    return '$_temp0';
  }

  @override
  String get timelineNow => 'Now';

  @override
  String get readOnly => 'Read only';

  @override
  String get loading => 'Loading';

  @override
  String get viewAsStart => 'View as this user';

  @override
  String get viewAsStartBody =>
      'Your session becomes read-only and shows what they see.';

  @override
  String get viewAsEnded => 'View-as ended';

  @override
  String get copyPassword => 'Copy password';

  @override
  String get dateFrom => 'From';

  @override
  String get dateTo => 'To';

  @override
  String get showChanges => 'Show changes';

  @override
  String get hideChanges => 'Hide changes';

  @override
  String get currentValue => 'Current value';

  @override
  String get newValue => 'New value';

  @override
  String get historyEmpty => 'No earlier versions.';

  @override
  String get integrationEnabled => 'Integration enabled';

  @override
  String switchModeTitle(Object name, Object mode) {
    return 'Switch $name to $mode?';
  }

  @override
  String toggleTitle(Object name, Object state) {
    return 'Turn $name $state?';
  }

  @override
  String get on => 'on';

  @override
  String get off => 'off';

  @override
  String get decidedToast => 'Decision recorded';

  @override
  String get approvalsHistory => 'Decided';

  @override
  String get openUser => 'Open user';

  @override
  String statusChangeTitle(Object status) {
    return 'Change status to $status?';
  }

  @override
  String get addPermission => 'Add permission';

  @override
  String get pickPermission => 'Pick a permission';

  @override
  String unsavedChanges(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unsaved changes',
      one: '1 unsaved change',
    );
    return '$_temp0';
  }

  @override
  String dangerousCount(Object count) {
    return '$count dangerous';
  }

  @override
  String get inviteDone => 'Invitation created';

  @override
  String get createRole => 'Create role';

  @override
  String get maintenanceActive => 'Maintenance is on';

  @override
  String get maintenanceInactive => 'Site is serving normally';

  @override
  String checkedAgo(Object time) {
    return 'Checked $time';
  }

  @override
  String get controlHubSub => 'Every change asks for a reason and is audited.';

  @override
  String get userNotFound => 'User not found';

  @override
  String get auditOps => 'Operations audit';

  @override
  String get filterApply => 'Apply filters';

  @override
  String get systemRoleLocked =>
      'System roles can change permissions but not be renamed or deleted.';

  @override
  String get fStatus => 'Status';

  @override
  String get fTraveler => 'Traveler';

  @override
  String get fAmount => 'Amount';

  @override
  String get fScheduled => 'Scheduled';

  @override
  String get fPickup => 'Pickup';

  @override
  String get fDropoff => 'Drop-off';

  @override
  String get fDriver => 'Driver';

  @override
  String get fVehicle => 'Vehicle';

  @override
  String get fSupplier => 'Supplier';

  @override
  String get fService => 'Service';

  @override
  String get fCreated => 'Created';

  @override
  String get fChannel => 'Channel';

  @override
  String get fRecipient => 'Recipient';

  @override
  String get fMessage => 'Message';

  @override
  String get fCategory => 'Category';

  @override
  String get fPriority => 'Priority';

  @override
  String get fVenue => 'Venue';

  @override
  String get fEta => 'ETA';

  @override
  String get fType => 'Type';

  @override
  String get fBooking => 'Booking';

  @override
  String get fTrip => 'Trip';

  @override
  String get fDays => 'Days';

  @override
  String get fTravelers => 'Travelers';

  @override
  String get fBudget => 'Budget';

  @override
  String get fPaid => 'Paid';

  @override
  String get fEstimated => 'Estimated';

  @override
  String get fRating => 'Rating';

  @override
  String get fArea => 'Area';

  @override
  String get fTier => 'Tier';

  @override
  String get fPhone => 'Phone';

  @override
  String get fConfirmationRate => 'Confirmation rate';

  @override
  String get fRejectionRate => 'Rejection rate';

  @override
  String get fCapacity => 'Capacity';

  @override
  String get fReserved => 'Reserved';

  @override
  String get fPrice => 'Price';

  @override
  String get fBasePrice => 'Base price';

  @override
  String get fDate => 'Date';

  @override
  String get fNights => 'Nights';

  @override
  String get fCheckIn => 'Check-in';

  @override
  String get fCheckOut => 'Check-out';

  @override
  String get fDeposit => 'Deposit';

  @override
  String get fSchedule => 'Schedule';

  @override
  String get fLastRun => 'Last run';

  @override
  String get fNextRun => 'Next run';

  @override
  String get fFailures => 'Failures';

  @override
  String get fSource => 'Source';

  @override
  String get fConfidence => 'Confidence';

  @override
  String get fDebit => 'Debit';

  @override
  String get fCredit => 'Credit';

  @override
  String get fSeverity => 'Severity';

  @override
  String get fMargin => 'Margin';

  @override
  String get fReply => 'Reply';

  @override
  String get fRooms => 'Rooms';

  @override
  String get fQuantity => 'Quantity';

  @override
  String get fDailyRate => 'Daily rate';

  @override
  String get fSlug => 'Slug';

  @override
  String get fUpdated => 'Updated';

  @override
  String get tabTrips => 'Trips';

  @override
  String get tabTransfers => 'Transfers';

  @override
  String get tabProperties => 'Properties';

  @override
  String get tabStayBookings => 'Stay bookings';

  @override
  String get tabLedger => 'Ledger';

  @override
  String get tabRefunds => 'Refunds';

  @override
  String get tabFailedPayments => 'Failed payments';

  @override
  String get tabListings => 'Listings';

  @override
  String get tabBookings => 'Bookings';

  @override
  String get changeStatus => 'Change status';

  @override
  String get openBooking => 'Open booking';

  @override
  String get acknowledge => 'Acknowledge';

  @override
  String get acknowledged => 'Acknowledged';

  @override
  String get sourceAlert => 'Market alert';

  @override
  String get sourceSupport => 'Support';

  @override
  String get sourceReview => 'Review queue';

  @override
  String get sourceGap => 'Knowledge gap';

  @override
  String get openSupport => 'Open in support';

  @override
  String get captured => 'Captured';

  @override
  String get refunded => 'Refunded';

  @override
  String get commission => 'Commission';

  @override
  String get escrow => 'Escrow';

  @override
  String get ledgerIntact => 'Ledger chain intact';

  @override
  String get ledgerBroken => 'Ledger chain broken';

  @override
  String get replyHint => 'Write a reply to the traveler';

  @override
  String get sendReply => 'Send reply';

  @override
  String get replySent => 'Reply sent';

  @override
  String get urgent => 'Urgent';

  @override
  String get sendSms => 'Send SMS';

  @override
  String get smsSent => 'SMS sent';

  @override
  String get smsReplayed => 'Already sent. This is the first result.';

  @override
  String get recipientName => 'Recipient name';

  @override
  String get sendNotification => 'Send notification';

  @override
  String get notificationsSendUnavailable =>
      'Sending from the app is not available yet: the server has no send endpoint. Use the web console.';

  @override
  String get unread => 'Unread';

  @override
  String get openPortal => 'Open supplier portal';

  @override
  String get deactivate => 'Deactivate';

  @override
  String get activate => 'Activate';

  @override
  String get stayApprove => 'Approve';

  @override
  String get stayDecline => 'Decline';

  @override
  String get stayCheckIn => 'Check in';

  @override
  String get stayComplete => 'Complete';

  @override
  String get stayCancel => 'Cancel stay';

  @override
  String get editPrice => 'Edit price';

  @override
  String get priceChanged => 'Price updated';

  @override
  String get inventorySlots => 'Inventory slots';

  @override
  String advanceTo(Object status) {
    return 'Mark $status';
  }

  @override
  String get cancelOrder => 'Cancel order';

  @override
  String get runNow => 'Run now';

  @override
  String get jobQueued => 'Job triggered';

  @override
  String activeJobs(Object count) {
    return '$count active jobs';
  }

  @override
  String get healthDatabase => 'Database';

  @override
  String get healthLedger => 'Ledger';

  @override
  String get healthAi => 'AI';

  @override
  String get healthPayments => 'Payments';

  @override
  String get healthPush => 'Push';

  @override
  String get healthReadiness => 'Commercial readiness';

  @override
  String get simulated => 'Simulated';

  @override
  String get configured => 'Configured';

  @override
  String get notConfigured => 'Not configured';

  @override
  String get knowledgeGaps => 'Gaps';

  @override
  String get knowledgeConflicts => 'Conflicts';

  @override
  String get knowledgeReview => 'Review';

  @override
  String get knowledgeStale => 'Stale facts';

  @override
  String get evidence => 'Evidence';

  @override
  String get marketSuppliers => 'Suppliers tracked';

  @override
  String get marketOffers => 'Offers';

  @override
  String get marketObservations => 'Price observations';

  @override
  String get marketChanges => 'Recent changes';

  @override
  String get marketFreshness => 'Freshness';

  @override
  String get marketSources => 'Sources';

  @override
  String get priceIndex => 'Price observations (EGP)';

  @override
  String get refreshMarket => 'Refresh market data';

  @override
  String get revenueGross => 'Gross bookings';

  @override
  String get revenuePayout => 'Payout';

  @override
  String get revenueEscrow => 'In escrow';

  @override
  String get revenueCompletion => 'Completion';

  @override
  String get revenueDaily => 'Daily gross vs payout';

  @override
  String get revenueByService => 'By service';

  @override
  String get days30 => '30 days';

  @override
  String get days7 => '7 days';

  @override
  String get days90 => '90 days';

  @override
  String get reliabilityOverall => 'Overall';

  @override
  String get reliabilityAcceptance => 'Acceptance';

  @override
  String get reliabilitySpeed => 'Response speed';

  @override
  String get reliabilityCancellation => 'Cancellation';

  @override
  String sampleSize(Object count) {
    return 'Based on $count bookings';
  }

  @override
  String get blockDates => 'Block dates';

  @override
  String get blocked => 'Blocked';

  @override
  String get openDay => 'Open';

  @override
  String get blockAdded => 'Dates blocked';

  @override
  String get noSupplier => 'No supplier is linked to this account.';

  @override
  String get markReturned => 'Mark returned';

  @override
  String get cmsPages => 'Pages';

  @override
  String get cmsDraft => 'Draft';

  @override
  String get cmsPublished => 'Published';

  @override
  String get cmsArchived => 'Archived';

  @override
  String get cmsTitleEn => 'Title (English)';

  @override
  String get cmsTitleAr => 'Title (Arabic)';

  @override
  String get cmsBodyEn => 'Body (English)';

  @override
  String get cmsBodyAr => 'Body (Arabic)';

  @override
  String get cmsDescriptionEn => 'Description (English)';

  @override
  String get cmsDescriptionAr => 'Description (Arabic)';

  @override
  String get cmsHeroImage => 'Hero image URL';

  @override
  String get cmsSeo => 'SEO';

  @override
  String get cmsSeoTitleEn => 'SEO title (English)';

  @override
  String get cmsSeoTitleAr => 'SEO title (Arabic)';

  @override
  String get cmsSeoDescEn => 'Meta description (English)';

  @override
  String get cmsSeoDescAr => 'Meta description (Arabic)';

  @override
  String get cmsCanonical => 'Canonical URL';

  @override
  String get cmsNoindex => 'Hide from search engines';

  @override
  String get cmsPublish => 'Publish';

  @override
  String get cmsPublishedToast => 'Page published';

  @override
  String get cmsRevisions => 'Revisions';

  @override
  String get cmsUpload => 'Upload image';

  @override
  String get cmsUploaded => 'Image uploaded';

  @override
  String get cmsMedia => 'Media';

  @override
  String get cmsAltEn => 'Alt text (English)';

  @override
  String get cmsAltAr => 'Alt text (Arabic)';

  @override
  String cmsTooLarge(Object mb) {
    return 'The image is larger than $mb MB.';
  }

  @override
  String get cmsUseAsHero => 'Use as hero image';

  @override
  String get auditTabPlaceholder =>
      'The supplier audit trail has no API yet. Ask Operations for the full history.';

  @override
  String get supplierPortal => 'Supplier portal';

  @override
  String get sectionLive => 'Live trips & transfers';

  @override
  String get back => 'Back';

  @override
  String get navCalendar => 'Calendar';

  @override
  String get navPayouts => 'Payouts';

  @override
  String get navAccount => 'Account';

  @override
  String secondsAgo(int n) {
    return '${n}s ago';
  }

  @override
  String feedUpdated(String feed, String ago) {
    return '$feed, updated $ago';
  }

  @override
  String queueSubtitle(int open, int critical) {
    return '$open open, $critical critical';
  }

  @override
  String get swipeHint => 'Swipe any item to resolve or snooze';

  @override
  String pulseSubtitle(String date) {
    return '$date in Dahab';
  }

  @override
  String get subsystemApi => 'API';

  @override
  String get subsystemDatabase => 'Database';

  @override
  String get subsystemPayments => 'Payments';

  @override
  String get subsystemAi => 'AI';

  @override
  String get kpiArrowsNote =>
      'Arrows compare with the previous reading. Green is better, coral is worse.';

  @override
  String get seeAll => 'See all';

  @override
  String get egp => 'EGP';

  @override
  String get required => 'Required';

  @override
  String get refundNeedsApprovalTitle => 'Needs a second admin approval';

  @override
  String get traveler => 'Traveler';

  @override
  String get supplierLabel => 'Supplier';

  @override
  String get controlSubtitle => 'Every change is logged with a reason';

  @override
  String get groupCommerce => 'Commerce';

  @override
  String get changeNeedsApproval => 'Changes need approval';

  @override
  String get killSwitchesNote => 'On stops the service';

  @override
  String get running => 'Running';

  @override
  String stoppedBy(String who, String time) {
    return 'Stopped by $who, $time';
  }

  @override
  String get maintenanceMode => 'Maintenance mode';

  @override
  String get maintenanceHint => 'Staff stay signed in while it\'s on';

  @override
  String get statusHealthyShort => 'Healthy';

  @override
  String get accessTitle => 'Access';

  @override
  String accessSubtitle(int users, int roles) {
    return '$users users, $roles roles';
  }

  @override
  String get reasonAskedOnSave => 'You\'ll be asked for a reason';

  @override
  String guestsCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n guests',
      one: '1 guest',
    );
    return '$_temp0';
  }

  @override
  String requestedAgo(String ago) {
    return 'Requested $ago';
  }

  @override
  String get paletteFootnote => 'Results only include what your role can open.';

  @override
  String get appNameLatin => 'Dahab Ops';

  @override
  String get groupCatalog => 'Catalogue';

  @override
  String get sectionCatalog => 'Catalogue';

  @override
  String get catMyListings => 'My listings';

  @override
  String get catSupplierHint =>
      'Edit your listings and submit them for review. Dahab staff publish approved changes.';

  @override
  String get catActions => 'Actions';

  @override
  String get catAddDay => 'Add day';

  @override
  String get catAddItem => 'Add item';

  @override
  String get catAddPhoto => 'Add photo';

  @override
  String get catAddTag => 'Add a tag and press enter';

  @override
  String get catAddTime => 'Add time';

  @override
  String get catArchive => 'Archive';

  @override
  String get catArchiveBody =>
      'Archived listings disappear from the site. Bookings and history are kept.';

  @override
  String catArchiveTitle(String name) {
    return 'Archive $name?';
  }

  @override
  String get catArchivedToast => 'Archived';

  @override
  String get catAvailable => 'Available';

  @override
  String get catCamera => 'Take photo';

  @override
  String get catLibrary => 'Choose from gallery';

  @override
  String get catCannotPublish => 'Can\'t publish yet';

  @override
  String get catCapacity => 'Capacity per slot';

  @override
  String get catCloseDates => 'Close these dates';

  @override
  String get catClosedShort => 'Closed';

  @override
  String get catConflictBody =>
      'Someone else saved this listing while you were editing. Keep your changes on top of theirs, or reload their version.';

  @override
  String get catConflictKeep => 'Keep mine';

  @override
  String get catConflictReload => 'Reload';

  @override
  String get catConflictShort => 'Changed elsewhere';

  @override
  String get catConflictTitle => 'Edited elsewhere';

  @override
  String get catCountDrafts => 'drafts';

  @override
  String get catCountReview => 'in review';

  @override
  String get catCover => 'Cover';

  @override
  String get catCustom => 'Custom';

  @override
  String catDay(int n) {
    return 'Day $n';
  }

  @override
  String get catDayBody => 'Plan';

  @override
  String get catDayTitle => 'Title';

  @override
  String get catDelete => 'Delete';

  @override
  String get catDeleteBody =>
      'Only drafts that were never booked can be deleted. Anything else is archived instead.';

  @override
  String catDeleteTitle(String name) {
    return 'Delete $name?';
  }

  @override
  String get catDeletedToast => 'Deleted';

  @override
  String get catDraftSaved => 'Draft saved';

  @override
  String get catDuplicate => 'Duplicate';

  @override
  String get catDuplicatedToast => 'Copy created as a draft';

  @override
  String get catEditPrice => 'Edit price';

  @override
  String get catEmptyBody => 'Nothing here yet. Tap New to add the first one.';

  @override
  String get catFilterSupplier => 'Filter by supplier';

  @override
  String catFromPrice(String price) {
    return 'from $price';
  }

  @override
  String get catHiddenToast => 'Hidden from the site';

  @override
  String get catHide => 'Hide';

  @override
  String catHoursShort(int h) {
    return '$h h';
  }

  @override
  String catMinutesShort(int m) {
    return '$m min';
  }

  @override
  String get catMinutesUnit => 'min';

  @override
  String get catInUseBody =>
      'This listing has bookings, so it can\'t be deleted. Archive it instead?';

  @override
  String get catInUseTitle => 'In use';

  @override
  String get catInvalidJson => 'Not valid JSON';

  @override
  String get catItemName => 'Item name';

  @override
  String get catLat => 'Latitude';

  @override
  String get catLng => 'Longitude';

  @override
  String get catMenu => 'Menu';

  @override
  String get catMenuOther => 'Other';

  @override
  String catMissingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count missing',
      one: '1 missing',
    );
    return '$_temp0';
  }

  @override
  String catMissingLang(String lang) {
    return '$lang is missing';
  }

  @override
  String catMissingTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count things missing before publishing',
      one: '1 thing missing before publishing',
    );
    return '$_temp0';
  }

  @override
  String get catNew => 'New';

  @override
  String get catNewSection => 'Or type a new section';

  @override
  String catNewType(String type) {
    return 'New · $type';
  }

  @override
  String get catNextStep => 'Save & next';

  @override
  String get catNightlyPrice => 'Price per night';

  @override
  String catNights(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nights',
      one: '1 night',
    );
    return '$_temp0';
  }

  @override
  String get catNoRooms => 'Add a room first';

  @override
  String get catNoSupplier => 'Choose a supplier';

  @override
  String get catNotSaved => 'Not saved yet';

  @override
  String get catOrders => 'Bookings & orders';

  @override
  String catPhotoHint(int count, int max) {
    return '$count of $max · long-press and drag to reorder · the first photo is the cover';
  }

  @override
  String get catPrice => 'Price';

  @override
  String catPriceReasonBody(String from, String to) {
    return '$from to $to is a change of more than 30%. Say why.';
  }

  @override
  String get catPriceReasonTitle => 'Large price change';

  @override
  String get catPublish => 'Publish';

  @override
  String get catPublishChanges => 'Publish changes';

  @override
  String get catPublishedToast => 'Published';

  @override
  String get catRangeHint =>
      'Tap a day, or long-press and drag across days, then set the price or close them.';

  @override
  String get catRates => 'Rates calendar';

  @override
  String get catRequired => 'Required';

  @override
  String get catRestore => 'Restore';

  @override
  String get catRestoredToast => 'Restored';

  @override
  String get catRooms => 'Rooms';

  @override
  String get catSaveDraft => 'Save draft';

  @override
  String get catSaveFailed => 'Not saved. Retrying on the next edit.';

  @override
  String get catSaving => 'Saving…';

  @override
  String get catSearchSuppliers => 'Search suppliers';

  @override
  String get catSection => 'Section';

  @override
  String get catSlots => 'Departures';

  @override
  String get catSlotsHint =>
      'Long-press and drag across days to set times and capacity, or close them.';

  @override
  String get catStatusArchived => 'Archived';

  @override
  String get catStatusDraft => 'Draft';

  @override
  String get catStatusHidden => 'Hidden';

  @override
  String get catStatusPublished => 'Published';

  @override
  String get catStatusReview => 'In review';

  @override
  String get catStepBasics => 'Basics';

  @override
  String get catStepPhotos => 'Photos';

  @override
  String get catStepPrice => 'Price';

  @override
  String get catSubmitReview => 'Submit for review';

  @override
  String get catSubmittedToast => 'Sent to Dahab for review';

  @override
  String get catTimes => 'Start times';

  @override
  String get catUnsaved => 'Unsaved changes';

  @override
  String get catUntitled => 'Untitled';

  @override
  String get catWeekdays => 'Apply on';

  @override
  String get killPaymentsTitle => 'Payments';

  @override
  String get killPaymentsDesc => 'Stops checkout and payment capture';

  @override
  String get killBookingsTitle => 'Bookings';

  @override
  String get killBookingsDesc => 'Stops new holds, bookings and orders';

  @override
  String get killAiTitle => 'AI features';

  @override
  String get killAiDesc => 'Stops AI-backed endpoints (DayGI, trip generation)';

  @override
  String get killSmsTitle => 'Outbound SMS';

  @override
  String get killSmsDesc => 'Stops outbound SMS';

  @override
  String get killSupplierSignupTitle => 'Supplier sign-up';

  @override
  String get killSupplierSignupDesc => 'Stops supplier self-signup';

  @override
  String get flagMaintenanceTitle => 'Maintenance mode';

  @override
  String get flagMaintenanceDesc => 'Non-staff API calls get 503';

  @override
  String get actorSystem => 'System';

  @override
  String get allPermissions => 'All permissions';

  @override
  String get listSeparator => ', ';

  @override
  String get roleTraveler => 'Traveler';

  @override
  String get roleSupplier => 'Supplier';

  @override
  String get roleOperations => 'Operations';

  @override
  String get roleProduct => 'Product';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get ccHubSubtitle => 'One desk for the web and both apps';

  @override
  String get ccGroupApp => 'App & content';

  @override
  String get ccGroupPlatform => 'Platform';

  @override
  String get ccTileExperience => 'App experience';

  @override
  String get ccTileExperienceSub => 'Maintenance, banner, switches, versions';

  @override
  String get ccTileHomepage => 'Homepage sections';

  @override
  String get ccTileHomepageSub => 'Order, visibility and section config';

  @override
  String get ccTileProgrammes => 'Trip programmes';

  @override
  String get ccTileProgrammesSub => 'The ready-made trips both apps render';

  @override
  String get ccTileNavigation => 'Navigation menus';

  @override
  String get ccTileNavigationSub => 'The CMS-managed web menus';

  @override
  String get ccTileCmsSub => 'Pages, publishing and media';

  @override
  String get ccTileSettingsSub => 'Typed settings with history and rollback';

  @override
  String get ccTileFlagsSub => 'Feature flags and targeting';

  @override
  String get ccTileIntegrationsSub => 'Live provider health';

  @override
  String get ccTileApprovalsSub => 'Queued changes awaiting a second admin';

  @override
  String get ccTileUsers => 'Users & roles';

  @override
  String get ccTileUsersSub => 'Accounts, roles and overrides';

  @override
  String get ccTileAuditSub => 'Every change, who made it and why';

  @override
  String get ccMaintenanceOn => 'Platform under maintenance';

  @override
  String get ccMaintenanceOnSub =>
      'Travelers see the maintenance screen until you lift it.';

  @override
  String ccKillsOn(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count capabilities switched off',
      one: '1 capability switched off',
    );
    return '$_temp0';
  }

  @override
  String get ccAllClear => 'Everything is live';

  @override
  String get ccAllClearSub => 'No maintenance, no engaged switches.';

  @override
  String get ccReadingApprovals => 'Approvals';

  @override
  String get ccReadingKills => 'Switches off';

  @override
  String get ccReadingIntegrations => 'Degraded';

  @override
  String get previewQuiet => 'Travelers see the app normally';

  @override
  String ccSaveSettingTitle(Object key) {
    return 'Change $key?';
  }

  @override
  String get ccMaintenanceHint =>
      'Flips every client to the maintenance screen.';

  @override
  String get ccPreviewEn => 'Preview - English';

  @override
  String get ccPreviewAr => 'Preview - Arabic';

  @override
  String get ccAnnouncementTitle => 'Announcement banner';

  @override
  String get ccAnnouncementNote => 'Shown at the top of every client';

  @override
  String get ccBannerOn => 'Banner is live';

  @override
  String get ccBannerOff => 'No banner';

  @override
  String get ccBannerInfo => 'Tone: info';

  @override
  String get ccBannerWarn => 'Tone: warning';

  @override
  String get ccBannerEnable => 'Show the announcement banner?';

  @override
  String get ccBannerDisable => 'Hide the announcement banner?';

  @override
  String get ccFeatureFlags => 'Feature flags';

  @override
  String get ccFlagsManageAll => 'Manage all';

  @override
  String ccRolloutReading(Object value) {
    return '$value rollout';
  }

  @override
  String get ccFlagOn => 'ON';

  @override
  String get ccFlagOff => 'OFF';

  @override
  String get ccFlagEnable => 'Enable';

  @override
  String get ccFlagDisable => 'Disable';

  @override
  String ccFlagEnableTitle(Object key) {
    return 'Enable $key?';
  }

  @override
  String ccFlagDisableTitle(Object key) {
    return 'Disable $key?';
  }

  @override
  String get ccFlagEngaged => 'OFF';

  @override
  String get ccFlagNormal => 'LIVE';

  @override
  String ccKillEngageTitle(Object title) {
    return 'Switch off $title?';
  }

  @override
  String ccKillReleaseTitle(Object title) {
    return 'Switch $title back on?';
  }

  @override
  String get ccGatesTitle => 'App version gates';

  @override
  String get ccGatesNote => 'Forces or nudges app updates';

  @override
  String get ccPlatformAndroid => 'Android';

  @override
  String get ccPlatformIos => 'iOS';

  @override
  String get ccMinVersion => 'Minimum version';

  @override
  String get ccLatestVersion => 'Latest version';

  @override
  String get ccStoreUrl => 'Store URL';

  @override
  String get ccSimulatorTitle => 'Simulate a build';

  @override
  String get ccSimulatorHint => 'App version, e.g. 1.2.0';

  @override
  String get ccSimulatorEmpty => 'Type a version to see the gate verdict.';

  @override
  String get ccVersionInvalid => 'Use a dotted version like 1.2.0.';

  @override
  String get ccGateBlocked => 'UPDATE BLOCKED';

  @override
  String get ccGateUpdate => 'UPDATE SUGGESTED';

  @override
  String get ccGateOk => 'UP TO DATE';

  @override
  String get ccHomepageEmpty => 'No homepage sections yet';

  @override
  String get ccHomepageHint =>
      'Drag to reorder. Order and visibility go live on the web instantly.';

  @override
  String get ccHomepageReordered => 'Order saved.';

  @override
  String get ccVisible => 'Visible';

  @override
  String get ccTitleEn => 'Title (English)';

  @override
  String get ccTitleAr => 'Title (Arabic)';

  @override
  String get ccConfigJson => 'Section config (JSON)';

  @override
  String get ccInvalidJson => 'This is not valid JSON.';

  @override
  String get ccConfigMustBeObject => 'The config must be a JSON object.';

  @override
  String get ccProgrammeNew => 'New programme';

  @override
  String get ccAll => 'All';

  @override
  String get ccAllDestinations => 'All destinations';

  @override
  String get ccDraft => 'Draft';

  @override
  String get ccArchived => 'Archived';

  @override
  String get ccDestDahab => 'Dahab';

  @override
  String get ccDestNuweiba => 'Nuweiba';

  @override
  String get ccDestSiwa => 'Siwa';

  @override
  String get ccProgrammesEmpty => 'No programmes match';

  @override
  String get ccProgrammesEmptyBody =>
      'Adjust the filters, or create a new programme.';

  @override
  String get ccProgrammeId => 'ID (stable, e.g. dahab-slow-weekend)';

  @override
  String get ccTaglineEn => 'Tagline (English)';

  @override
  String get ccTaglineAr => 'Tagline (Arabic)';

  @override
  String get ccDestination => 'Destination';

  @override
  String get ccPace => 'Pace';

  @override
  String get ccBudget => 'Default budget';

  @override
  String get ccDurationDays => 'Days';

  @override
  String get ccPriceEgp => 'From price (EGP)';

  @override
  String get ccPriceEstimate => 'Price is an estimate';

  @override
  String get ccPriceEstimateHint => 'True while no supplier quotes it yet';

  @override
  String get ccIdealForEn => 'Ideal for (English)';

  @override
  String get ccIdealForAr => 'Ideal for (Arabic)';

  @override
  String get ccHighlightsEn => 'Highlights (English)';

  @override
  String get ccHighlightsAr => 'Highlights (Arabic)';

  @override
  String get ccCommaSeparated => 'Separate items with commas';

  @override
  String get ccDayByDay => 'Day by day';

  @override
  String get ccAddDay => 'Add day';

  @override
  String get ccNoDaysYet => 'No days planned yet.';

  @override
  String get ccSubtitleEn => 'Subtitle (English)';

  @override
  String get ccTimeEstimate => 'Time estimate';

  @override
  String get ccCreate => 'Create programme';

  @override
  String get ccProgrammeCreateConfirm => 'Create this programme?';

  @override
  String get ccProgrammePublishConfirm => 'Publish this programme?';

  @override
  String get ccProgrammePublishBody =>
      'It appears on the web and the REHLA app immediately.';

  @override
  String get ccProgrammeArchiveConfirm => 'Archive this programme?';

  @override
  String get ccProgrammeArchiveBody =>
      'It disappears from both apps but stays in the dashboard.';

  @override
  String get ccArchivedToast => 'Programme archived.';

  @override
  String get ccProgrammeDeleteConfirm => 'Delete this programme?';

  @override
  String get ccProgrammeDeleteBody =>
      'This cannot be undone. Consider archiving instead.';

  @override
  String get ccProgrammeDeleted => 'Programme deleted.';

  @override
  String get deleteLabel => 'Delete';

  @override
  String get noticeFailed => 'The change could not be made.';

  @override
  String get ccNavItemNew => 'New navigation item';

  @override
  String get ccNavItemEdit => 'Edit navigation item';

  @override
  String get ccNavEmpty => 'No items in this menu';

  @override
  String get ccNavEmptyBody => 'Create the first item for this menu.';

  @override
  String get ccNavRoute => 'Route';

  @override
  String get ccNavRouteHint => 'In-app path like /hotels';

  @override
  String get ccNavExternal => 'External URL';

  @override
  String get ccNavOrder => 'Order';

  @override
  String get ccHidden => 'HIDDEN';

  @override
  String ccNavDeleteTitle(Object label) {
    return 'Delete $label?';
  }

  @override
  String get ccNavLabelRequired => 'A label is required.';
}
