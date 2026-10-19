import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Dahab Ops'**
  String get appName;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @loadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get loadMore;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get justNow;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.'**
  String get errorGeneric;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Can\'t reach the Dahab servers. Check your connection.'**
  String get errorNetwork;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'The server took too long to answer.'**
  String get errorTimeout;

  /// No description provided for @errorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Your session ended. Sign in again.'**
  String get errorUnauthorized;

  /// No description provided for @errorForbidden.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission for this.'**
  String get errorForbidden;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find that.'**
  String get errorNotFound;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'The server had a problem. It has been logged.'**
  String get errorServer;

  /// No description provided for @errorKillSwitch.
  ///
  /// In en, this message translates to:
  /// **'This capability is switched off right now.'**
  String get errorKillSwitch;

  /// No description provided for @errorMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Dahab is in maintenance mode.'**
  String get errorMaintenance;

  /// No description provided for @errorViewAsReadonly.
  ///
  /// In en, this message translates to:
  /// **'View-as is read-only. End it to make changes.'**
  String get errorViewAsReadonly;

  /// No description provided for @correlationId.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get correlationId;

  /// No description provided for @copyReference.
  ///
  /// In en, this message translates to:
  /// **'Copy reference'**
  String get copyReference;

  /// No description provided for @offlineBanner.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. Showing the last data we have.'**
  String get offlineBanner;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to run the day in Dahab'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'For Dahab staff and partner suppliers. Travelers use the Dahab app.'**
  String get loginSubtitle;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get emailInvalid;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your password.'**
  String get passwordRequired;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Email or password is incorrect.'**
  String get invalidCredentials;

  /// No description provided for @notStaff.
  ///
  /// In en, this message translates to:
  /// **'This account has no staff access.'**
  String get notStaff;

  /// No description provided for @restoringSession.
  ///
  /// In en, this message translates to:
  /// **'Restoring your session…'**
  String get restoringSession;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get logout;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Sign out of Dahab Ops on this device?'**
  String get logoutConfirm;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @unlockWithFaceId.
  ///
  /// In en, this message translates to:
  /// **'Unlock with Face ID'**
  String get unlockWithFaceId;

  /// No description provided for @staffOnlyNote.
  ///
  /// In en, this message translates to:
  /// **'Staff only. This device is registered as {device}. Sessions end after 12 hours.'**
  String staffOnlyNote(String device);

  /// No description provided for @buildStamp.
  ///
  /// In en, this message translates to:
  /// **'Build 1.0.0 (204)'**
  String get buildStamp;

  /// No description provided for @controlTitle.
  ///
  /// In en, this message translates to:
  /// **'Control'**
  String get controlTitle;

  /// No description provided for @myDevices.
  ///
  /// In en, this message translates to:
  /// **'My devices'**
  String get myDevices;

  /// No description provided for @thisDevice.
  ///
  /// In en, this message translates to:
  /// **'This device'**
  String get thisDevice;

  /// No description provided for @revokeDevice.
  ///
  /// In en, this message translates to:
  /// **'Sign out device'**
  String get revokeDevice;

  /// No description provided for @deviceRevoked.
  ///
  /// In en, this message translates to:
  /// **'Device signed out'**
  String get deviceRevoked;

  /// No description provided for @devicesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No devices are signed in.'**
  String get devicesEmpty;

  /// No description provided for @appLocked.
  ///
  /// In en, this message translates to:
  /// **'Dahab Ops is locked'**
  String get appLocked;

  /// No description provided for @appLockedBody.
  ///
  /// In en, this message translates to:
  /// **'Unlock to continue where you left off.'**
  String get appLockedBody;

  /// No description provided for @unlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlock;

  /// No description provided for @unlockReason.
  ///
  /// In en, this message translates to:
  /// **'Unlock Dahab Ops'**
  String get unlockReason;

  /// No description provided for @biometricLock.
  ///
  /// In en, this message translates to:
  /// **'Biometric app lock'**
  String get biometricLock;

  /// No description provided for @biometricLockHint.
  ///
  /// In en, this message translates to:
  /// **'Ask for Face ID or fingerprint when you come back to the app.'**
  String get biometricLockHint;

  /// No description provided for @biometricUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Biometrics aren\'t set up on this device.'**
  String get biometricUnavailable;

  /// No description provided for @navPulse.
  ///
  /// In en, this message translates to:
  /// **'Pulse'**
  String get navPulse;

  /// No description provided for @navQueue.
  ///
  /// In en, this message translates to:
  /// **'Queue'**
  String get navQueue;

  /// No description provided for @navLive.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get navLive;

  /// No description provided for @navInbox.
  ///
  /// In en, this message translates to:
  /// **'Inbox'**
  String get navInbox;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @navInventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get navInventory;

  /// No description provided for @navRevenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get navRevenue;

  /// No description provided for @sectionOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get sectionOverview;

  /// No description provided for @sectionCore.
  ///
  /// In en, this message translates to:
  /// **'Intelligence Core'**
  String get sectionCore;

  /// No description provided for @sectionTrips.
  ///
  /// In en, this message translates to:
  /// **'Live Trips'**
  String get sectionTrips;

  /// No description provided for @sectionTransfers.
  ///
  /// In en, this message translates to:
  /// **'Transfers'**
  String get sectionTransfers;

  /// No description provided for @sectionExceptions.
  ///
  /// In en, this message translates to:
  /// **'Exceptions'**
  String get sectionExceptions;

  /// No description provided for @sectionCommerce.
  ///
  /// In en, this message translates to:
  /// **'Commerce'**
  String get sectionCommerce;

  /// No description provided for @sectionAccommodations.
  ///
  /// In en, this message translates to:
  /// **'Accommodations'**
  String get sectionAccommodations;

  /// No description provided for @sectionStays.
  ///
  /// In en, this message translates to:
  /// **'Stays'**
  String get sectionStays;

  /// No description provided for @sectionSuppliers.
  ///
  /// In en, this message translates to:
  /// **'Suppliers'**
  String get sectionSuppliers;

  /// No description provided for @sectionIntelligence.
  ///
  /// In en, this message translates to:
  /// **'Intelligence'**
  String get sectionIntelligence;

  /// No description provided for @sectionOpportunities.
  ///
  /// In en, this message translates to:
  /// **'Opportunities'**
  String get sectionOpportunities;

  /// No description provided for @sectionKnowledge.
  ///
  /// In en, this message translates to:
  /// **'Knowledge'**
  String get sectionKnowledge;

  /// No description provided for @sectionSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get sectionSupport;

  /// No description provided for @sectionSms.
  ///
  /// In en, this message translates to:
  /// **'SMS Center'**
  String get sectionSms;

  /// No description provided for @sectionNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get sectionNotifications;

  /// No description provided for @sectionAudit.
  ///
  /// In en, this message translates to:
  /// **'Audit Log'**
  String get sectionAudit;

  /// No description provided for @sectionFlags.
  ///
  /// In en, this message translates to:
  /// **'Feature Flags'**
  String get sectionFlags;

  /// No description provided for @sectionJobs.
  ///
  /// In en, this message translates to:
  /// **'Market Jobs'**
  String get sectionJobs;

  /// No description provided for @sectionHealth.
  ///
  /// In en, this message translates to:
  /// **'System Health'**
  String get sectionHealth;

  /// No description provided for @sectionCms.
  ///
  /// In en, this message translates to:
  /// **'CMS Content'**
  String get sectionCms;

  /// No description provided for @sectionPricing.
  ///
  /// In en, this message translates to:
  /// **'Pricing & Inventory'**
  String get sectionPricing;

  /// No description provided for @sectionDining.
  ///
  /// In en, this message translates to:
  /// **'Dining Orders'**
  String get sectionDining;

  /// No description provided for @sectionMarket.
  ///
  /// In en, this message translates to:
  /// **'Market Intelligence'**
  String get sectionMarket;

  /// No description provided for @supplierInbox.
  ///
  /// In en, this message translates to:
  /// **'Supplier inbox'**
  String get supplierInbox;

  /// No description provided for @supplierInventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get supplierInventory;

  /// No description provided for @supplierResources.
  ///
  /// In en, this message translates to:
  /// **'Resources'**
  String get supplierResources;

  /// No description provided for @supplierStays.
  ///
  /// In en, this message translates to:
  /// **'Stays'**
  String get supplierStays;

  /// No description provided for @supplierRentals.
  ///
  /// In en, this message translates to:
  /// **'Rentals'**
  String get supplierRentals;

  /// No description provided for @supplierRevenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get supplierRevenue;

  /// No description provided for @supplierReliability.
  ///
  /// In en, this message translates to:
  /// **'Reliability'**
  String get supplierReliability;

  /// No description provided for @supplierAudit.
  ///
  /// In en, this message translates to:
  /// **'Activity log'**
  String get supplierAudit;

  /// No description provided for @controlUsers.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get controlUsers;

  /// No description provided for @controlInvite.
  ///
  /// In en, this message translates to:
  /// **'Invite staff'**
  String get controlInvite;

  /// No description provided for @controlRoles.
  ///
  /// In en, this message translates to:
  /// **'Roles & permissions'**
  String get controlRoles;

  /// No description provided for @controlSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get controlSettings;

  /// No description provided for @controlFlags.
  ///
  /// In en, this message translates to:
  /// **'Flags & kill switches'**
  String get controlFlags;

  /// No description provided for @controlMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance mode'**
  String get controlMaintenance;

  /// No description provided for @controlIntegrations.
  ///
  /// In en, this message translates to:
  /// **'Integrations'**
  String get controlIntegrations;

  /// No description provided for @controlApprovals.
  ///
  /// In en, this message translates to:
  /// **'Approvals'**
  String get controlApprovals;

  /// No description provided for @controlAudit.
  ///
  /// In en, this message translates to:
  /// **'Audit timeline'**
  String get controlAudit;

  /// No description provided for @groupCore.
  ///
  /// In en, this message translates to:
  /// **'Core'**
  String get groupCore;

  /// No description provided for @groupDomain.
  ///
  /// In en, this message translates to:
  /// **'Operations'**
  String get groupDomain;

  /// No description provided for @groupSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get groupSystem;

  /// No description provided for @groupSupplier.
  ///
  /// In en, this message translates to:
  /// **'Supplier'**
  String get groupSupplier;

  /// No description provided for @groupMarket.
  ///
  /// In en, this message translates to:
  /// **'Market & content'**
  String get groupMarket;

  /// No description provided for @groupControl.
  ///
  /// In en, this message translates to:
  /// **'Control'**
  String get groupControl;

  /// No description provided for @groupAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get groupAccount;

  /// No description provided for @comingNextTitle.
  ///
  /// In en, this message translates to:
  /// **'Coming next'**
  String get comingNextTitle;

  /// No description provided for @comingNextBody.
  ///
  /// In en, this message translates to:
  /// **'This section is being rebuilt for mobile. Until it lands, use the web command center.'**
  String get comingNextBody;

  /// No description provided for @comingNextAccess.
  ///
  /// In en, this message translates to:
  /// **'Your access'**
  String get comingNextAccess;

  /// No description provided for @pulseTitle.
  ///
  /// In en, this message translates to:
  /// **'Pulse'**
  String get pulseTitle;

  /// No description provided for @statusHealthy.
  ///
  /// In en, this message translates to:
  /// **'All systems healthy'**
  String get statusHealthy;

  /// No description provided for @statusDegraded.
  ///
  /// In en, this message translates to:
  /// **'Degraded'**
  String get statusDegraded;

  /// No description provided for @statusActionRequired.
  ///
  /// In en, this message translates to:
  /// **'Action required'**
  String get statusActionRequired;

  /// No description provided for @live.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get live;

  /// No description provided for @polling.
  ///
  /// In en, this message translates to:
  /// **'Polling'**
  String get polling;

  /// No description provided for @reconnecting.
  ///
  /// In en, this message translates to:
  /// **'Reconnecting'**
  String get reconnecting;

  /// No description provided for @kpiActiveTrips.
  ///
  /// In en, this message translates to:
  /// **'Active trips'**
  String get kpiActiveTrips;

  /// No description provided for @kpiPendingBookings.
  ///
  /// In en, this message translates to:
  /// **'Pending bookings'**
  String get kpiPendingBookings;

  /// No description provided for @kpiSupplierConfirmations.
  ///
  /// In en, this message translates to:
  /// **'Supplier confirmations'**
  String get kpiSupplierConfirmations;

  /// No description provided for @kpiPaymentIssues.
  ///
  /// In en, this message translates to:
  /// **'Payment issues'**
  String get kpiPaymentIssues;

  /// No description provided for @kpiExceptions.
  ///
  /// In en, this message translates to:
  /// **'Exceptions'**
  String get kpiExceptions;

  /// No description provided for @kpiAtRisk.
  ///
  /// In en, this message translates to:
  /// **'At-risk trips'**
  String get kpiAtRisk;

  /// No description provided for @kpiUnreadSupport.
  ///
  /// In en, this message translates to:
  /// **'Open support'**
  String get kpiUnreadSupport;

  /// No description provided for @kpiActiveTransfers.
  ///
  /// In en, this message translates to:
  /// **'Active transfers'**
  String get kpiActiveTransfers;

  /// No description provided for @actionQueue.
  ///
  /// In en, this message translates to:
  /// **'Action queue'**
  String get actionQueue;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @queueEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing needs you right now'**
  String get queueEmpty;

  /// No description provided for @queueEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'New work appears here the moment it lands.'**
  String get queueEmptyBody;

  /// No description provided for @priorityCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get priorityCritical;

  /// No description provided for @priorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get priorityHigh;

  /// No description provided for @priorityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get priorityMedium;

  /// No description provided for @priorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get priorityLow;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search bookings, people, suppliers…'**
  String get searchHint;

  /// No description provided for @recent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recent;

  /// No description provided for @clearRecent.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearRecent;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No matches'**
  String get noResults;

  /// No description provided for @searchEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Search bookings, users, suppliers and properties you can access.'**
  String get searchEmptyBody;

  /// No description provided for @typeBooking.
  ///
  /// In en, this message translates to:
  /// **'Booking'**
  String get typeBooking;

  /// No description provided for @typeUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get typeUser;

  /// No description provided for @typeSupplier.
  ///
  /// In en, this message translates to:
  /// **'Supplier'**
  String get typeSupplier;

  /// No description provided for @typeProperty.
  ///
  /// In en, this message translates to:
  /// **'Property'**
  String get typeProperty;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @ascending.
  ///
  /// In en, this message translates to:
  /// **'Ascending'**
  String get ascending;

  /// No description provided for @descending.
  ///
  /// In en, this message translates to:
  /// **'Descending'**
  String get descending;

  /// No description provided for @newest.
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get newest;

  /// No description provided for @oldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest first'**
  String get oldest;

  /// No description provided for @nameSort.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameSort;

  /// No description provided for @lastSeenSort.
  ///
  /// In en, this message translates to:
  /// **'Last seen'**
  String get lastSeenSort;

  /// No description provided for @dangerReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get dangerReasonLabel;

  /// No description provided for @dangerReasonHint.
  ///
  /// In en, this message translates to:
  /// **'Why are you doing this? It is saved to the audit log.'**
  String get dangerReasonHint;

  /// No description provided for @dangerReasonTooShort.
  ///
  /// In en, this message translates to:
  /// **'Write at least 3 characters.'**
  String get dangerReasonTooShort;

  /// No description provided for @approvalNotice.
  ///
  /// In en, this message translates to:
  /// **'This change needs a second admin. It will be queued for approval.'**
  String get approvalNotice;

  /// No description provided for @biometricConfirmReason.
  ///
  /// In en, this message translates to:
  /// **'Confirm this sensitive action'**
  String get biometricConfirmReason;

  /// No description provided for @biometricFailed.
  ///
  /// In en, this message translates to:
  /// **'Biometric check failed.'**
  String get biometricFailed;

  /// No description provided for @noAccessTitle.
  ///
  /// In en, this message translates to:
  /// **'No access'**
  String get noAccessTitle;

  /// No description provided for @noAccessBody.
  ///
  /// In en, this message translates to:
  /// **'Ask an admin for the permission below.'**
  String get noAccessBody;

  /// No description provided for @usersTitle.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get usersTitle;

  /// No description provided for @usersSearch.
  ///
  /// In en, this message translates to:
  /// **'Search name or email'**
  String get usersSearch;

  /// No description provided for @filterRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get filterRole;

  /// No description provided for @filterStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get filterStatus;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statusActive;

  /// No description provided for @statusSuspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get statusSuspended;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @changeRole.
  ///
  /// In en, this message translates to:
  /// **'Change role'**
  String get changeRole;

  /// No description provided for @suspend.
  ///
  /// In en, this message translates to:
  /// **'Suspend'**
  String get suspend;

  /// No description provided for @reactivate.
  ///
  /// In en, this message translates to:
  /// **'Reactivate'**
  String get reactivate;

  /// No description provided for @suspendTitle.
  ///
  /// In en, this message translates to:
  /// **'Suspend this user?'**
  String get suspendTitle;

  /// No description provided for @suspendBody.
  ///
  /// In en, this message translates to:
  /// **'They are signed out everywhere and cannot sign in until reactivated.'**
  String get suspendBody;

  /// No description provided for @overrides.
  ///
  /// In en, this message translates to:
  /// **'Permission overrides'**
  String get overrides;

  /// No description provided for @overridesHint.
  ///
  /// In en, this message translates to:
  /// **'Overrides win over the role. Deny beats grant.'**
  String get overridesHint;

  /// No description provided for @addOverride.
  ///
  /// In en, this message translates to:
  /// **'Add override'**
  String get addOverride;

  /// No description provided for @grant.
  ///
  /// In en, this message translates to:
  /// **'Grant'**
  String get grant;

  /// No description provided for @deny.
  ///
  /// In en, this message translates to:
  /// **'Deny'**
  String get deny;

  /// No description provided for @effectivePermissions.
  ///
  /// In en, this message translates to:
  /// **'Effective permissions'**
  String get effectivePermissions;

  /// No description provided for @revokeSessions.
  ///
  /// In en, this message translates to:
  /// **'Revoke all sessions'**
  String get revokeSessions;

  /// No description provided for @revokeSessionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign this user out everywhere?'**
  String get revokeSessionsTitle;

  /// No description provided for @devices.
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get devices;

  /// No description provided for @viewAs.
  ///
  /// In en, this message translates to:
  /// **'View as this user'**
  String get viewAs;

  /// No description provided for @endViewAs.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get endViewAs;

  /// No description provided for @inviteStaff.
  ///
  /// In en, this message translates to:
  /// **'Invite staff'**
  String get inviteStaff;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @supplierId.
  ///
  /// In en, this message translates to:
  /// **'Supplier ID'**
  String get supplierId;

  /// No description provided for @invite.
  ///
  /// In en, this message translates to:
  /// **'Send invite'**
  String get invite;

  /// No description provided for @tempPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Temporary password'**
  String get tempPasswordTitle;

  /// No description provided for @tempPasswordBody.
  ///
  /// In en, this message translates to:
  /// **'Shown once. Share it through a secure channel; it must be changed at first sign in.'**
  String get tempPasswordBody;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a name.'**
  String get nameRequired;

  /// No description provided for @roleRequired.
  ///
  /// In en, this message translates to:
  /// **'Pick a role.'**
  String get roleRequired;

  /// No description provided for @rolesTitle.
  ///
  /// In en, this message translates to:
  /// **'Roles & permissions'**
  String get rolesTitle;

  /// No description provided for @systemRole.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemRole;

  /// No description provided for @permissionMatrix.
  ///
  /// In en, this message translates to:
  /// **'Permission matrix'**
  String get permissionMatrix;

  /// No description provided for @dangerous.
  ///
  /// In en, this message translates to:
  /// **'Dangerous'**
  String get dangerous;

  /// No description provided for @newRole.
  ///
  /// In en, this message translates to:
  /// **'New role'**
  String get newRole;

  /// No description provided for @roleName.
  ///
  /// In en, this message translates to:
  /// **'Role name'**
  String get roleName;

  /// No description provided for @roleDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get roleDescription;

  /// No description provided for @deleteRole.
  ///
  /// In en, this message translates to:
  /// **'Delete role'**
  String get deleteRole;

  /// No description provided for @deleteRoleTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this role?'**
  String get deleteRoleTitle;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @rollback.
  ///
  /// In en, this message translates to:
  /// **'Roll back'**
  String get rollback;

  /// No description provided for @invalidJson.
  ///
  /// In en, this message translates to:
  /// **'That isn\'t valid JSON.'**
  String get invalidJson;

  /// No description provided for @invalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a number.'**
  String get invalidNumber;

  /// No description provided for @flagsTitle.
  ///
  /// In en, this message translates to:
  /// **'Flags & kill switches'**
  String get flagsTitle;

  /// No description provided for @killSwitches.
  ///
  /// In en, this message translates to:
  /// **'Kill switches'**
  String get killSwitches;

  /// No description provided for @featureFlags.
  ///
  /// In en, this message translates to:
  /// **'Feature flags'**
  String get featureFlags;

  /// No description provided for @rollout.
  ///
  /// In en, this message translates to:
  /// **'Rollout'**
  String get rollout;

  /// No description provided for @killSwitchWarning.
  ///
  /// In en, this message translates to:
  /// **'Turning this on switches the capability off for every user, immediately.'**
  String get killSwitchWarning;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get disabled;

  /// No description provided for @maintenanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Maintenance mode'**
  String get maintenanceTitle;

  /// No description provided for @maintenanceOn.
  ///
  /// In en, this message translates to:
  /// **'Maintenance is on'**
  String get maintenanceOn;

  /// No description provided for @maintenanceOff.
  ///
  /// In en, this message translates to:
  /// **'Maintenance is off'**
  String get maintenanceOff;

  /// No description provided for @maintenanceBody.
  ///
  /// In en, this message translates to:
  /// **'While on, travelers and suppliers get a maintenance page. Staff and sign-in keep working.'**
  String get maintenanceBody;

  /// No description provided for @messageEn.
  ///
  /// In en, this message translates to:
  /// **'Message (English)'**
  String get messageEn;

  /// No description provided for @messageAr.
  ///
  /// In en, this message translates to:
  /// **'Message (Arabic)'**
  String get messageAr;

  /// No description provided for @saveMessage.
  ///
  /// In en, this message translates to:
  /// **'Save message'**
  String get saveMessage;

  /// No description provided for @integrationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Integrations'**
  String get integrationsTitle;

  /// No description provided for @checkNow.
  ///
  /// In en, this message translates to:
  /// **'Check now'**
  String get checkNow;

  /// No description provided for @latency.
  ///
  /// In en, this message translates to:
  /// **'Latency'**
  String get latency;

  /// No description provided for @mode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get mode;

  /// No description provided for @sandbox.
  ///
  /// In en, this message translates to:
  /// **'Sandbox'**
  String get sandbox;

  /// No description provided for @liveMode.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get liveMode;

  /// No description provided for @keyHint.
  ///
  /// In en, this message translates to:
  /// **'Key'**
  String get keyHint;

  /// No description provided for @statusDown.
  ///
  /// In en, this message translates to:
  /// **'Down'**
  String get statusDown;

  /// No description provided for @statusOff.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get statusOff;

  /// No description provided for @statusUnconfigured.
  ///
  /// In en, this message translates to:
  /// **'Not configured'**
  String get statusUnconfigured;

  /// No description provided for @approvalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Approvals'**
  String get approvalsTitle;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @decisionNote.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get decisionNote;

  /// No description provided for @ownHidden.
  ///
  /// In en, this message translates to:
  /// **'Requests you made are hidden. Another admin decides them.'**
  String get ownHidden;

  /// No description provided for @approvalsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No approvals waiting'**
  String get approvalsEmpty;

  /// No description provided for @auditTitle.
  ///
  /// In en, this message translates to:
  /// **'Audit timeline'**
  String get auditTitle;

  /// No description provided for @actor.
  ///
  /// In en, this message translates to:
  /// **'Actor'**
  String get actor;

  /// No description provided for @action.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get action;

  /// No description provided for @entity.
  ///
  /// In en, this message translates to:
  /// **'Entity'**
  String get entity;

  /// No description provided for @dateRange.
  ///
  /// In en, this message translates to:
  /// **'Date range'**
  String get dateRange;

  /// No description provided for @before.
  ///
  /// In en, this message translates to:
  /// **'Before'**
  String get before;

  /// No description provided for @after.
  ///
  /// In en, this message translates to:
  /// **'After'**
  String get after;

  /// No description provided for @noChanges.
  ///
  /// In en, this message translates to:
  /// **'No field changes recorded.'**
  String get noChanges;

  /// No description provided for @auditEmpty.
  ///
  /// In en, this message translates to:
  /// **'No audit events match'**
  String get auditEmpty;

  /// No description provided for @device.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get device;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeAbyss.
  ///
  /// In en, this message translates to:
  /// **'Abyss'**
  String get themeAbyss;

  /// No description provided for @themeSalt.
  ///
  /// In en, this message translates to:
  /// **'Salt'**
  String get themeSalt;

  /// No description provided for @themeHighContrast.
  ///
  /// In en, this message translates to:
  /// **'High contrast'**
  String get themeHighContrast;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @signedInAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in as'**
  String get signedInAs;

  /// No description provided for @emptyList.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get emptyList;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @payload.
  ///
  /// In en, this message translates to:
  /// **'Payload'**
  String get payload;

  /// No description provided for @commandPalette.
  ///
  /// In en, this message translates to:
  /// **'Command palette'**
  String get commandPalette;

  /// No description provided for @actionFailed.
  ///
  /// In en, this message translates to:
  /// **'That didn\'t go through.'**
  String get actionFailed;

  /// No description provided for @updatedAgo.
  ///
  /// In en, this message translates to:
  /// **'Updated {time}'**
  String updatedAgo(String time);

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 min ago} other{{count} min ago}}'**
  String minutesAgo(int count);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 h ago} other{{count} h ago}}'**
  String hoursAgo(int count);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{yesterday} other{{count} days ago}}'**
  String daysAgo(int count);

  /// No description provided for @approvalQueued.
  ///
  /// In en, this message translates to:
  /// **'Queued for approval · {id}'**
  String approvalQueued(String id);

  /// No description provided for @lastSeen.
  ///
  /// In en, this message translates to:
  /// **'Last seen {time}'**
  String lastSeen(String time);

  /// No description provided for @deviceCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No devices} =1{1 device} other{{count} devices}}'**
  String deviceCount(int count);

  /// No description provided for @usersCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No users} =1{1 user} other{{count} users}}'**
  String usersCount(int count);

  /// No description provided for @revokedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 session revoked} other{{count} sessions revoked}}'**
  String revokedCount(int count);

  /// No description provided for @viewAsBanner.
  ///
  /// In en, this message translates to:
  /// **'Viewing as {email} · read-only'**
  String viewAsBanner(String email);

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'v{version}'**
  String versionLabel(int version);

  /// No description provided for @rollbackTo.
  ///
  /// In en, this message translates to:
  /// **'Roll back to v{version}?'**
  String rollbackTo(int version);

  /// No description provided for @requestedBy.
  ///
  /// In en, this message translates to:
  /// **'Requested by {name}'**
  String requestedBy(String name);

  /// No description provided for @changesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No changes} =1{1 change} other{{count} changes}}'**
  String changesCount(int count);

  /// No description provided for @permissionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 permission} other{{count} permissions}}'**
  String permissionsCount(int count);

  /// No description provided for @grantedOf.
  ///
  /// In en, this message translates to:
  /// **'{granted} of {total}'**
  String grantedOf(int granted, int total);

  /// No description provided for @latencyMs.
  ///
  /// In en, this message translates to:
  /// **'{ms} ms'**
  String latencyMs(int ms);

  /// No description provided for @confirmToggle.
  ///
  /// In en, this message translates to:
  /// **'Turn {name} {state}?'**
  String confirmToggle(String name, String state);

  /// No description provided for @changeRoleTo.
  ///
  /// In en, this message translates to:
  /// **'Change role to {role}?'**
  String changeRoleTo(String role);

  /// No description provided for @saveSettingTitle.
  ///
  /// In en, this message translates to:
  /// **'Save {key}?'**
  String saveSettingTitle(String key);

  /// No description provided for @queueTitle.
  ///
  /// In en, this message translates to:
  /// **'Queue'**
  String get queueTitle;

  /// No description provided for @needsAction.
  ///
  /// In en, this message translates to:
  /// **'Needs action'**
  String get needsAction;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get filterCritical;

  /// No description provided for @filterSuppliers.
  ///
  /// In en, this message translates to:
  /// **'Suppliers'**
  String get filterSuppliers;

  /// No description provided for @filterPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get filterPayments;

  /// No description provided for @filterSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get filterSupport;

  /// No description provided for @snooze.
  ///
  /// In en, this message translates to:
  /// **'Snooze'**
  String get snooze;

  /// No description provided for @resolve.
  ///
  /// In en, this message translates to:
  /// **'Resolve'**
  String get resolve;

  /// No description provided for @overdue.
  ///
  /// In en, this message translates to:
  /// **'overdue'**
  String get overdue;

  /// No description provided for @slaLeft.
  ///
  /// In en, this message translates to:
  /// **'left'**
  String get slaLeft;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @declineBookingTitle.
  ///
  /// In en, this message translates to:
  /// **'Decline this booking?'**
  String get declineBookingTitle;

  /// No description provided for @declineReasonHint.
  ///
  /// In en, this message translates to:
  /// **'Tell the desk why (wind, overbooked, …)'**
  String get declineReasonHint;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @guests.
  ///
  /// In en, this message translates to:
  /// **'Guests'**
  String get guests;

  /// No description provided for @commissionRate.
  ///
  /// In en, this message translates to:
  /// **'Commission'**
  String get commissionRate;

  /// No description provided for @commissionNeedsApproval.
  ///
  /// In en, this message translates to:
  /// **'Changes need approval'**
  String get commissionNeedsApproval;

  /// No description provided for @rebook.
  ///
  /// In en, this message translates to:
  /// **'Rebook'**
  String get rebook;

  /// No description provided for @reviewRefund.
  ///
  /// In en, this message translates to:
  /// **'Review refund'**
  String get reviewRefund;

  /// No description provided for @timelineBooked.
  ///
  /// In en, this message translates to:
  /// **'Booked'**
  String get timelineBooked;

  /// No description provided for @timelinePaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get timelinePaid;

  /// No description provided for @timelinePickup.
  ///
  /// In en, this message translates to:
  /// **'Pickup'**
  String get timelinePickup;

  /// No description provided for @paymentsLedger.
  ///
  /// In en, this message translates to:
  /// **'Payments ledger'**
  String get paymentsLedger;

  /// No description provided for @ledgerCharge.
  ///
  /// In en, this message translates to:
  /// **'Charge'**
  String get ledgerCharge;

  /// No description provided for @ledgerCommission.
  ///
  /// In en, this message translates to:
  /// **'Commission {rate}'**
  String ledgerCommission(Object rate);

  /// No description provided for @ledgerPayout.
  ///
  /// In en, this message translates to:
  /// **'Supplier payout'**
  String get ledgerPayout;

  /// No description provided for @ledgerNet.
  ///
  /// In en, this message translates to:
  /// **'Net to Dahab'**
  String get ledgerNet;

  /// No description provided for @refund.
  ///
  /// In en, this message translates to:
  /// **'Refund'**
  String get refund;

  /// No description provided for @refundAction.
  ///
  /// In en, this message translates to:
  /// **'Refund a booking'**
  String get refundAction;

  /// No description provided for @refundSheetSub.
  ///
  /// In en, this message translates to:
  /// **'Paid {paid}. Choose how much of it goes back.'**
  String refundSheetSub(Object paid);

  /// No description provided for @refundOf.
  ///
  /// In en, this message translates to:
  /// **'of {paid}'**
  String refundOf(Object paid);

  /// No description provided for @refundFull.
  ///
  /// In en, this message translates to:
  /// **'Full'**
  String get refundFull;

  /// No description provided for @refundReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get refundReason;

  /// No description provided for @reasonSupplierCancelled.
  ///
  /// In en, this message translates to:
  /// **'Supplier cancelled'**
  String get reasonSupplierCancelled;

  /// No description provided for @reasonWeather.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get reasonWeather;

  /// No description provided for @reasonNotDelivered.
  ///
  /// In en, this message translates to:
  /// **'Not delivered'**
  String get reasonNotDelivered;

  /// No description provided for @reasonDuplicateCharge.
  ///
  /// In en, this message translates to:
  /// **'Duplicate charge'**
  String get reasonDuplicateCharge;

  /// No description provided for @refundNoteHint.
  ///
  /// In en, this message translates to:
  /// **'What happened, in one or two lines'**
  String get refundNoteHint;

  /// No description provided for @refundNeedsApproval.
  ///
  /// In en, this message translates to:
  /// **'Above the approval threshold: a second admin approves after you.'**
  String get refundNeedsApproval;

  /// No description provided for @requestApprovalWithFaceId.
  ///
  /// In en, this message translates to:
  /// **'Request approval with Face ID'**
  String get requestApprovalWithFaceId;

  /// No description provided for @refundAuditNote.
  ///
  /// In en, this message translates to:
  /// **'Logged to the audit trail under your name.'**
  String get refundAuditNote;

  /// No description provided for @refundToGuest.
  ///
  /// In en, this message translates to:
  /// **'To guest card'**
  String get refundToGuest;

  /// No description provided for @refundCommissionReversed.
  ///
  /// In en, this message translates to:
  /// **'Commission reversed'**
  String get refundCommissionReversed;

  /// No description provided for @refundFromPayout.
  ///
  /// In en, this message translates to:
  /// **'Taken from supplier payout'**
  String get refundFromPayout;

  /// No description provided for @refundQueuedTitle.
  ///
  /// In en, this message translates to:
  /// **'Queued for a second admin'**
  String get refundQueuedTitle;

  /// No description provided for @refundQueuedBody.
  ///
  /// In en, this message translates to:
  /// **'The guest is refunded once an admin approves.'**
  String get refundQueuedBody;

  /// No description provided for @refundDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Refund issued'**
  String get refundDoneTitle;

  /// No description provided for @refundDoneBody.
  ///
  /// In en, this message translates to:
  /// **'{amount} goes back to the guest card.'**
  String refundDoneBody(Object amount);

  /// No description provided for @inboxWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting on you'**
  String get inboxWaiting;

  /// No description provided for @inboxEarnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get inboxEarnings;

  /// No description provided for @inboxReliability.
  ///
  /// In en, this message translates to:
  /// **'Reliability'**
  String get inboxReliability;

  /// No description provided for @inboxPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get inboxPending;

  /// No description provided for @inboxConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get inboxConfirmed;

  /// No description provided for @inboxDeclined.
  ///
  /// In en, this message translates to:
  /// **'Declined'**
  String get inboxDeclined;

  /// No description provided for @kpiUnreadNotifications.
  ///
  /// In en, this message translates to:
  /// **'Unread notifications'**
  String get kpiUnreadNotifications;

  /// No description provided for @actionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actionsTitle;

  /// No description provided for @saveRole.
  ///
  /// In en, this message translates to:
  /// **'Save role'**
  String get saveRole;

  /// No description provided for @valueLabel.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get valueLabel;

  /// No description provided for @editOverrides.
  ///
  /// In en, this message translates to:
  /// **'Edit overrides'**
  String get editOverrides;

  /// No description provided for @effectivePermissionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} permissions in effect'**
  String effectivePermissionsCount(Object count);

  /// No description provided for @dangerConfirmBiometric.
  ///
  /// In en, this message translates to:
  /// **'Confirm with Face ID'**
  String get dangerConfirmBiometric;

  /// No description provided for @dangerAuditNote.
  ///
  /// In en, this message translates to:
  /// **'Logged to the audit trail with your reason.'**
  String get dangerAuditNote;

  /// No description provided for @dangerApprovalTitle.
  ///
  /// In en, this message translates to:
  /// **'Needs a second admin'**
  String get dangerApprovalTitle;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorTitle;

  /// No description provided for @errorConflict.
  ///
  /// In en, this message translates to:
  /// **'Someone changed this first. Refresh and try again.'**
  String get errorConflict;

  /// No description provided for @errorValidation.
  ///
  /// In en, this message translates to:
  /// **'Some fields need attention.'**
  String get errorValidation;

  /// No description provided for @offlineShort.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offlineShort;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFilters;

  /// No description provided for @slaMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 min} other{{count} min}}'**
  String slaMinutes(int count);

  /// No description provided for @timelineNow.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get timelineNow;

  /// No description provided for @readOnly.
  ///
  /// In en, this message translates to:
  /// **'Read only'**
  String get readOnly;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @viewAsStart.
  ///
  /// In en, this message translates to:
  /// **'View as this user'**
  String get viewAsStart;

  /// No description provided for @viewAsStartBody.
  ///
  /// In en, this message translates to:
  /// **'Your session becomes read-only and shows what they see.'**
  String get viewAsStartBody;

  /// No description provided for @viewAsEnded.
  ///
  /// In en, this message translates to:
  /// **'View-as ended'**
  String get viewAsEnded;

  /// No description provided for @copyPassword.
  ///
  /// In en, this message translates to:
  /// **'Copy password'**
  String get copyPassword;

  /// No description provided for @dateFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get dateFrom;

  /// No description provided for @dateTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get dateTo;

  /// No description provided for @showChanges.
  ///
  /// In en, this message translates to:
  /// **'Show changes'**
  String get showChanges;

  /// No description provided for @hideChanges.
  ///
  /// In en, this message translates to:
  /// **'Hide changes'**
  String get hideChanges;

  /// No description provided for @currentValue.
  ///
  /// In en, this message translates to:
  /// **'Current value'**
  String get currentValue;

  /// No description provided for @newValue.
  ///
  /// In en, this message translates to:
  /// **'New value'**
  String get newValue;

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No earlier versions.'**
  String get historyEmpty;

  /// No description provided for @integrationEnabled.
  ///
  /// In en, this message translates to:
  /// **'Integration enabled'**
  String get integrationEnabled;

  /// No description provided for @switchModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Switch {name} to {mode}?'**
  String switchModeTitle(Object name, Object mode);

  /// No description provided for @toggleTitle.
  ///
  /// In en, this message translates to:
  /// **'Turn {name} {state}?'**
  String toggleTitle(Object name, Object state);

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'on'**
  String get on;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'off'**
  String get off;

  /// No description provided for @decidedToast.
  ///
  /// In en, this message translates to:
  /// **'Decision recorded'**
  String get decidedToast;

  /// No description provided for @approvalsHistory.
  ///
  /// In en, this message translates to:
  /// **'Decided'**
  String get approvalsHistory;

  /// No description provided for @openUser.
  ///
  /// In en, this message translates to:
  /// **'Open user'**
  String get openUser;

  /// No description provided for @statusChangeTitle.
  ///
  /// In en, this message translates to:
  /// **'Change status to {status}?'**
  String statusChangeTitle(Object status);

  /// No description provided for @addPermission.
  ///
  /// In en, this message translates to:
  /// **'Add permission'**
  String get addPermission;

  /// No description provided for @pickPermission.
  ///
  /// In en, this message translates to:
  /// **'Pick a permission'**
  String get pickPermission;

  /// No description provided for @unsavedChanges.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 unsaved change} other{{count} unsaved changes}}'**
  String unsavedChanges(int count);

  /// No description provided for @dangerousCount.
  ///
  /// In en, this message translates to:
  /// **'{count} dangerous'**
  String dangerousCount(Object count);

  /// No description provided for @inviteDone.
  ///
  /// In en, this message translates to:
  /// **'Invitation created'**
  String get inviteDone;

  /// No description provided for @createRole.
  ///
  /// In en, this message translates to:
  /// **'Create role'**
  String get createRole;

  /// No description provided for @maintenanceActive.
  ///
  /// In en, this message translates to:
  /// **'Maintenance is on'**
  String get maintenanceActive;

  /// No description provided for @maintenanceInactive.
  ///
  /// In en, this message translates to:
  /// **'Site is serving normally'**
  String get maintenanceInactive;

  /// No description provided for @checkedAgo.
  ///
  /// In en, this message translates to:
  /// **'Checked {time}'**
  String checkedAgo(Object time);

  /// No description provided for @controlHubSub.
  ///
  /// In en, this message translates to:
  /// **'Every change asks for a reason and is audited.'**
  String get controlHubSub;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get userNotFound;

  /// No description provided for @auditOps.
  ///
  /// In en, this message translates to:
  /// **'Operations audit'**
  String get auditOps;

  /// No description provided for @filterApply.
  ///
  /// In en, this message translates to:
  /// **'Apply filters'**
  String get filterApply;

  /// No description provided for @systemRoleLocked.
  ///
  /// In en, this message translates to:
  /// **'System roles can change permissions but not be renamed or deleted.'**
  String get systemRoleLocked;

  /// No description provided for @fStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get fStatus;

  /// No description provided for @fTraveler.
  ///
  /// In en, this message translates to:
  /// **'Traveler'**
  String get fTraveler;

  /// No description provided for @fAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get fAmount;

  /// No description provided for @fScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get fScheduled;

  /// No description provided for @fPickup.
  ///
  /// In en, this message translates to:
  /// **'Pickup'**
  String get fPickup;

  /// No description provided for @fDropoff.
  ///
  /// In en, this message translates to:
  /// **'Drop-off'**
  String get fDropoff;

  /// No description provided for @fDriver.
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get fDriver;

  /// No description provided for @fVehicle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get fVehicle;

  /// No description provided for @fSupplier.
  ///
  /// In en, this message translates to:
  /// **'Supplier'**
  String get fSupplier;

  /// No description provided for @fService.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get fService;

  /// No description provided for @fCreated.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get fCreated;

  /// No description provided for @fChannel.
  ///
  /// In en, this message translates to:
  /// **'Channel'**
  String get fChannel;

  /// No description provided for @fRecipient.
  ///
  /// In en, this message translates to:
  /// **'Recipient'**
  String get fRecipient;

  /// No description provided for @fMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get fMessage;

  /// No description provided for @fCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get fCategory;

  /// No description provided for @fPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get fPriority;

  /// No description provided for @fVenue.
  ///
  /// In en, this message translates to:
  /// **'Venue'**
  String get fVenue;

  /// No description provided for @fEta.
  ///
  /// In en, this message translates to:
  /// **'ETA'**
  String get fEta;

  /// No description provided for @fType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get fType;

  /// No description provided for @fBooking.
  ///
  /// In en, this message translates to:
  /// **'Booking'**
  String get fBooking;

  /// No description provided for @fTrip.
  ///
  /// In en, this message translates to:
  /// **'Trip'**
  String get fTrip;

  /// No description provided for @fDays.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get fDays;

  /// No description provided for @fTravelers.
  ///
  /// In en, this message translates to:
  /// **'Travelers'**
  String get fTravelers;

  /// No description provided for @fBudget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get fBudget;

  /// No description provided for @fPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get fPaid;

  /// No description provided for @fEstimated.
  ///
  /// In en, this message translates to:
  /// **'Estimated'**
  String get fEstimated;

  /// No description provided for @fRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get fRating;

  /// No description provided for @fArea.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get fArea;

  /// No description provided for @fTier.
  ///
  /// In en, this message translates to:
  /// **'Tier'**
  String get fTier;

  /// No description provided for @fPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get fPhone;

  /// No description provided for @fConfirmationRate.
  ///
  /// In en, this message translates to:
  /// **'Confirmation rate'**
  String get fConfirmationRate;

  /// No description provided for @fRejectionRate.
  ///
  /// In en, this message translates to:
  /// **'Rejection rate'**
  String get fRejectionRate;

  /// No description provided for @fCapacity.
  ///
  /// In en, this message translates to:
  /// **'Capacity'**
  String get fCapacity;

  /// No description provided for @fReserved.
  ///
  /// In en, this message translates to:
  /// **'Reserved'**
  String get fReserved;

  /// No description provided for @fPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get fPrice;

  /// No description provided for @fBasePrice.
  ///
  /// In en, this message translates to:
  /// **'Base price'**
  String get fBasePrice;

  /// No description provided for @fDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get fDate;

  /// No description provided for @fNights.
  ///
  /// In en, this message translates to:
  /// **'Nights'**
  String get fNights;

  /// No description provided for @fCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Check-in'**
  String get fCheckIn;

  /// No description provided for @fCheckOut.
  ///
  /// In en, this message translates to:
  /// **'Check-out'**
  String get fCheckOut;

  /// No description provided for @fDeposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get fDeposit;

  /// No description provided for @fSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get fSchedule;

  /// No description provided for @fLastRun.
  ///
  /// In en, this message translates to:
  /// **'Last run'**
  String get fLastRun;

  /// No description provided for @fNextRun.
  ///
  /// In en, this message translates to:
  /// **'Next run'**
  String get fNextRun;

  /// No description provided for @fFailures.
  ///
  /// In en, this message translates to:
  /// **'Failures'**
  String get fFailures;

  /// No description provided for @fSource.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get fSource;

  /// No description provided for @fConfidence.
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get fConfidence;

  /// No description provided for @fDebit.
  ///
  /// In en, this message translates to:
  /// **'Debit'**
  String get fDebit;

  /// No description provided for @fCredit.
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get fCredit;

  /// No description provided for @fSeverity.
  ///
  /// In en, this message translates to:
  /// **'Severity'**
  String get fSeverity;

  /// No description provided for @fMargin.
  ///
  /// In en, this message translates to:
  /// **'Margin'**
  String get fMargin;

  /// No description provided for @fReply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get fReply;

  /// No description provided for @fRooms.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get fRooms;

  /// No description provided for @fQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get fQuantity;

  /// No description provided for @fDailyRate.
  ///
  /// In en, this message translates to:
  /// **'Daily rate'**
  String get fDailyRate;

  /// No description provided for @fSlug.
  ///
  /// In en, this message translates to:
  /// **'Slug'**
  String get fSlug;

  /// No description provided for @fUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get fUpdated;

  /// No description provided for @tabTrips.
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get tabTrips;

  /// No description provided for @tabTransfers.
  ///
  /// In en, this message translates to:
  /// **'Transfers'**
  String get tabTransfers;

  /// No description provided for @tabProperties.
  ///
  /// In en, this message translates to:
  /// **'Properties'**
  String get tabProperties;

  /// No description provided for @tabStayBookings.
  ///
  /// In en, this message translates to:
  /// **'Stay bookings'**
  String get tabStayBookings;

  /// No description provided for @tabLedger.
  ///
  /// In en, this message translates to:
  /// **'Ledger'**
  String get tabLedger;

  /// No description provided for @tabRefunds.
  ///
  /// In en, this message translates to:
  /// **'Refunds'**
  String get tabRefunds;

  /// No description provided for @tabFailedPayments.
  ///
  /// In en, this message translates to:
  /// **'Failed payments'**
  String get tabFailedPayments;

  /// No description provided for @tabListings.
  ///
  /// In en, this message translates to:
  /// **'Listings'**
  String get tabListings;

  /// No description provided for @tabBookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get tabBookings;

  /// No description provided for @changeStatus.
  ///
  /// In en, this message translates to:
  /// **'Change status'**
  String get changeStatus;

  /// No description provided for @openBooking.
  ///
  /// In en, this message translates to:
  /// **'Open booking'**
  String get openBooking;

  /// No description provided for @acknowledge.
  ///
  /// In en, this message translates to:
  /// **'Acknowledge'**
  String get acknowledge;

  /// No description provided for @acknowledged.
  ///
  /// In en, this message translates to:
  /// **'Acknowledged'**
  String get acknowledged;

  /// No description provided for @sourceAlert.
  ///
  /// In en, this message translates to:
  /// **'Market alert'**
  String get sourceAlert;

  /// No description provided for @sourceSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get sourceSupport;

  /// No description provided for @sourceReview.
  ///
  /// In en, this message translates to:
  /// **'Review queue'**
  String get sourceReview;

  /// No description provided for @sourceGap.
  ///
  /// In en, this message translates to:
  /// **'Knowledge gap'**
  String get sourceGap;

  /// No description provided for @openSupport.
  ///
  /// In en, this message translates to:
  /// **'Open in support'**
  String get openSupport;

  /// No description provided for @captured.
  ///
  /// In en, this message translates to:
  /// **'Captured'**
  String get captured;

  /// No description provided for @refunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get refunded;

  /// No description provided for @commission.
  ///
  /// In en, this message translates to:
  /// **'Commission'**
  String get commission;

  /// No description provided for @escrow.
  ///
  /// In en, this message translates to:
  /// **'Escrow'**
  String get escrow;

  /// No description provided for @ledgerIntact.
  ///
  /// In en, this message translates to:
  /// **'Ledger chain intact'**
  String get ledgerIntact;

  /// No description provided for @ledgerBroken.
  ///
  /// In en, this message translates to:
  /// **'Ledger chain broken'**
  String get ledgerBroken;

  /// No description provided for @replyHint.
  ///
  /// In en, this message translates to:
  /// **'Write a reply to the traveler'**
  String get replyHint;

  /// No description provided for @sendReply.
  ///
  /// In en, this message translates to:
  /// **'Send reply'**
  String get sendReply;

  /// No description provided for @replySent.
  ///
  /// In en, this message translates to:
  /// **'Reply sent'**
  String get replySent;

  /// No description provided for @urgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get urgent;

  /// No description provided for @sendSms.
  ///
  /// In en, this message translates to:
  /// **'Send SMS'**
  String get sendSms;

  /// No description provided for @smsSent.
  ///
  /// In en, this message translates to:
  /// **'SMS sent'**
  String get smsSent;

  /// No description provided for @smsReplayed.
  ///
  /// In en, this message translates to:
  /// **'Already sent. This is the first result.'**
  String get smsReplayed;

  /// No description provided for @recipientName.
  ///
  /// In en, this message translates to:
  /// **'Recipient name'**
  String get recipientName;

  /// No description provided for @sendNotification.
  ///
  /// In en, this message translates to:
  /// **'Send notification'**
  String get sendNotification;

  /// No description provided for @notificationsSendUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Sending from the app is not available yet: the server has no send endpoint. Use the web console.'**
  String get notificationsSendUnavailable;

  /// No description provided for @unread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get unread;

  /// No description provided for @openPortal.
  ///
  /// In en, this message translates to:
  /// **'Open supplier portal'**
  String get openPortal;

  /// No description provided for @deactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get deactivate;

  /// No description provided for @activate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get activate;

  /// No description provided for @stayApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get stayApprove;

  /// No description provided for @stayDecline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get stayDecline;

  /// No description provided for @stayCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Check in'**
  String get stayCheckIn;

  /// No description provided for @stayComplete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get stayComplete;

  /// No description provided for @stayCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel stay'**
  String get stayCancel;

  /// No description provided for @editPrice.
  ///
  /// In en, this message translates to:
  /// **'Edit price'**
  String get editPrice;

  /// No description provided for @priceChanged.
  ///
  /// In en, this message translates to:
  /// **'Price updated'**
  String get priceChanged;

  /// No description provided for @inventorySlots.
  ///
  /// In en, this message translates to:
  /// **'Inventory slots'**
  String get inventorySlots;

  /// No description provided for @advanceTo.
  ///
  /// In en, this message translates to:
  /// **'Mark {status}'**
  String advanceTo(Object status);

  /// No description provided for @cancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Cancel order'**
  String get cancelOrder;

  /// No description provided for @runNow.
  ///
  /// In en, this message translates to:
  /// **'Run now'**
  String get runNow;

  /// No description provided for @jobQueued.
  ///
  /// In en, this message translates to:
  /// **'Job triggered'**
  String get jobQueued;

  /// No description provided for @activeJobs.
  ///
  /// In en, this message translates to:
  /// **'{count} active jobs'**
  String activeJobs(Object count);

  /// No description provided for @healthDatabase.
  ///
  /// In en, this message translates to:
  /// **'Database'**
  String get healthDatabase;

  /// No description provided for @healthLedger.
  ///
  /// In en, this message translates to:
  /// **'Ledger'**
  String get healthLedger;

  /// No description provided for @healthAi.
  ///
  /// In en, this message translates to:
  /// **'AI'**
  String get healthAi;

  /// No description provided for @healthPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get healthPayments;

  /// No description provided for @healthPush.
  ///
  /// In en, this message translates to:
  /// **'Push'**
  String get healthPush;

  /// No description provided for @healthReadiness.
  ///
  /// In en, this message translates to:
  /// **'Commercial readiness'**
  String get healthReadiness;

  /// No description provided for @simulated.
  ///
  /// In en, this message translates to:
  /// **'Simulated'**
  String get simulated;

  /// No description provided for @configured.
  ///
  /// In en, this message translates to:
  /// **'Configured'**
  String get configured;

  /// No description provided for @notConfigured.
  ///
  /// In en, this message translates to:
  /// **'Not configured'**
  String get notConfigured;

  /// No description provided for @knowledgeGaps.
  ///
  /// In en, this message translates to:
  /// **'Gaps'**
  String get knowledgeGaps;

  /// No description provided for @knowledgeConflicts.
  ///
  /// In en, this message translates to:
  /// **'Conflicts'**
  String get knowledgeConflicts;

  /// No description provided for @knowledgeReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get knowledgeReview;

  /// No description provided for @knowledgeStale.
  ///
  /// In en, this message translates to:
  /// **'Stale facts'**
  String get knowledgeStale;

  /// No description provided for @evidence.
  ///
  /// In en, this message translates to:
  /// **'Evidence'**
  String get evidence;

  /// No description provided for @marketSuppliers.
  ///
  /// In en, this message translates to:
  /// **'Suppliers tracked'**
  String get marketSuppliers;

  /// No description provided for @marketOffers.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get marketOffers;

  /// No description provided for @marketObservations.
  ///
  /// In en, this message translates to:
  /// **'Price observations'**
  String get marketObservations;

  /// No description provided for @marketChanges.
  ///
  /// In en, this message translates to:
  /// **'Recent changes'**
  String get marketChanges;

  /// No description provided for @marketFreshness.
  ///
  /// In en, this message translates to:
  /// **'Freshness'**
  String get marketFreshness;

  /// No description provided for @marketSources.
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get marketSources;

  /// No description provided for @priceIndex.
  ///
  /// In en, this message translates to:
  /// **'Price observations (EGP)'**
  String get priceIndex;

  /// No description provided for @refreshMarket.
  ///
  /// In en, this message translates to:
  /// **'Refresh market data'**
  String get refreshMarket;

  /// No description provided for @revenueGross.
  ///
  /// In en, this message translates to:
  /// **'Gross bookings'**
  String get revenueGross;

  /// No description provided for @revenuePayout.
  ///
  /// In en, this message translates to:
  /// **'Payout'**
  String get revenuePayout;

  /// No description provided for @revenueEscrow.
  ///
  /// In en, this message translates to:
  /// **'In escrow'**
  String get revenueEscrow;

  /// No description provided for @revenueCompletion.
  ///
  /// In en, this message translates to:
  /// **'Completion'**
  String get revenueCompletion;

  /// No description provided for @revenueDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily gross vs payout'**
  String get revenueDaily;

  /// No description provided for @revenueByService.
  ///
  /// In en, this message translates to:
  /// **'By service'**
  String get revenueByService;

  /// No description provided for @days30.
  ///
  /// In en, this message translates to:
  /// **'30 days'**
  String get days30;

  /// No description provided for @days7.
  ///
  /// In en, this message translates to:
  /// **'7 days'**
  String get days7;

  /// No description provided for @days90.
  ///
  /// In en, this message translates to:
  /// **'90 days'**
  String get days90;

  /// No description provided for @reliabilityOverall.
  ///
  /// In en, this message translates to:
  /// **'Overall'**
  String get reliabilityOverall;

  /// No description provided for @reliabilityAcceptance.
  ///
  /// In en, this message translates to:
  /// **'Acceptance'**
  String get reliabilityAcceptance;

  /// No description provided for @reliabilitySpeed.
  ///
  /// In en, this message translates to:
  /// **'Response speed'**
  String get reliabilitySpeed;

  /// No description provided for @reliabilityCancellation.
  ///
  /// In en, this message translates to:
  /// **'Cancellation'**
  String get reliabilityCancellation;

  /// No description provided for @sampleSize.
  ///
  /// In en, this message translates to:
  /// **'Based on {count} bookings'**
  String sampleSize(Object count);

  /// No description provided for @blockDates.
  ///
  /// In en, this message translates to:
  /// **'Block dates'**
  String get blockDates;

  /// No description provided for @blocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get blocked;

  /// No description provided for @openDay.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get openDay;

  /// No description provided for @blockAdded.
  ///
  /// In en, this message translates to:
  /// **'Dates blocked'**
  String get blockAdded;

  /// No description provided for @noSupplier.
  ///
  /// In en, this message translates to:
  /// **'No supplier is linked to this account.'**
  String get noSupplier;

  /// No description provided for @markReturned.
  ///
  /// In en, this message translates to:
  /// **'Mark returned'**
  String get markReturned;

  /// No description provided for @cmsPages.
  ///
  /// In en, this message translates to:
  /// **'Pages'**
  String get cmsPages;

  /// No description provided for @cmsDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get cmsDraft;

  /// No description provided for @cmsPublished.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get cmsPublished;

  /// No description provided for @cmsArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get cmsArchived;

  /// No description provided for @cmsTitleEn.
  ///
  /// In en, this message translates to:
  /// **'Title (English)'**
  String get cmsTitleEn;

  /// No description provided for @cmsTitleAr.
  ///
  /// In en, this message translates to:
  /// **'Title (Arabic)'**
  String get cmsTitleAr;

  /// No description provided for @cmsBodyEn.
  ///
  /// In en, this message translates to:
  /// **'Body (English)'**
  String get cmsBodyEn;

  /// No description provided for @cmsBodyAr.
  ///
  /// In en, this message translates to:
  /// **'Body (Arabic)'**
  String get cmsBodyAr;

  /// No description provided for @cmsDescriptionEn.
  ///
  /// In en, this message translates to:
  /// **'Description (English)'**
  String get cmsDescriptionEn;

  /// No description provided for @cmsDescriptionAr.
  ///
  /// In en, this message translates to:
  /// **'Description (Arabic)'**
  String get cmsDescriptionAr;

  /// No description provided for @cmsHeroImage.
  ///
  /// In en, this message translates to:
  /// **'Hero image URL'**
  String get cmsHeroImage;

  /// No description provided for @cmsSeo.
  ///
  /// In en, this message translates to:
  /// **'SEO'**
  String get cmsSeo;

  /// No description provided for @cmsSeoTitleEn.
  ///
  /// In en, this message translates to:
  /// **'SEO title (English)'**
  String get cmsSeoTitleEn;

  /// No description provided for @cmsSeoTitleAr.
  ///
  /// In en, this message translates to:
  /// **'SEO title (Arabic)'**
  String get cmsSeoTitleAr;

  /// No description provided for @cmsSeoDescEn.
  ///
  /// In en, this message translates to:
  /// **'Meta description (English)'**
  String get cmsSeoDescEn;

  /// No description provided for @cmsSeoDescAr.
  ///
  /// In en, this message translates to:
  /// **'Meta description (Arabic)'**
  String get cmsSeoDescAr;

  /// No description provided for @cmsCanonical.
  ///
  /// In en, this message translates to:
  /// **'Canonical URL'**
  String get cmsCanonical;

  /// No description provided for @cmsNoindex.
  ///
  /// In en, this message translates to:
  /// **'Hide from search engines'**
  String get cmsNoindex;

  /// No description provided for @cmsPublish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get cmsPublish;

  /// No description provided for @cmsPublishedToast.
  ///
  /// In en, this message translates to:
  /// **'Page published'**
  String get cmsPublishedToast;

  /// No description provided for @cmsRevisions.
  ///
  /// In en, this message translates to:
  /// **'Revisions'**
  String get cmsRevisions;

  /// No description provided for @cmsUpload.
  ///
  /// In en, this message translates to:
  /// **'Upload image'**
  String get cmsUpload;

  /// No description provided for @cmsUploaded.
  ///
  /// In en, this message translates to:
  /// **'Image uploaded'**
  String get cmsUploaded;

  /// No description provided for @cmsMedia.
  ///
  /// In en, this message translates to:
  /// **'Media'**
  String get cmsMedia;

  /// No description provided for @cmsAltEn.
  ///
  /// In en, this message translates to:
  /// **'Alt text (English)'**
  String get cmsAltEn;

  /// No description provided for @cmsAltAr.
  ///
  /// In en, this message translates to:
  /// **'Alt text (Arabic)'**
  String get cmsAltAr;

  /// No description provided for @cmsTooLarge.
  ///
  /// In en, this message translates to:
  /// **'The image is larger than {mb} MB.'**
  String cmsTooLarge(Object mb);

  /// No description provided for @cmsUseAsHero.
  ///
  /// In en, this message translates to:
  /// **'Use as hero image'**
  String get cmsUseAsHero;

  /// No description provided for @auditTabPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'The supplier audit trail has no API yet. Ask Operations for the full history.'**
  String get auditTabPlaceholder;

  /// No description provided for @supplierPortal.
  ///
  /// In en, this message translates to:
  /// **'Supplier portal'**
  String get supplierPortal;

  /// No description provided for @sectionLive.
  ///
  /// In en, this message translates to:
  /// **'Live trips & transfers'**
  String get sectionLive;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @navCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get navCalendar;

  /// No description provided for @navPayouts.
  ///
  /// In en, this message translates to:
  /// **'Payouts'**
  String get navPayouts;

  /// No description provided for @navAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get navAccount;

  /// No description provided for @secondsAgo.
  ///
  /// In en, this message translates to:
  /// **'{n}s ago'**
  String secondsAgo(int n);

  /// No description provided for @feedUpdated.
  ///
  /// In en, this message translates to:
  /// **'{feed}, updated {ago}'**
  String feedUpdated(String feed, String ago);

  /// No description provided for @queueSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{open} open, {critical} critical'**
  String queueSubtitle(int open, int critical);

  /// No description provided for @swipeHint.
  ///
  /// In en, this message translates to:
  /// **'Swipe any item to resolve or snooze'**
  String get swipeHint;

  /// No description provided for @pulseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{date} in Dahab'**
  String pulseSubtitle(String date);

  /// No description provided for @subsystemApi.
  ///
  /// In en, this message translates to:
  /// **'API'**
  String get subsystemApi;

  /// No description provided for @subsystemDatabase.
  ///
  /// In en, this message translates to:
  /// **'Database'**
  String get subsystemDatabase;

  /// No description provided for @subsystemPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get subsystemPayments;

  /// No description provided for @subsystemAi.
  ///
  /// In en, this message translates to:
  /// **'AI'**
  String get subsystemAi;

  /// No description provided for @kpiArrowsNote.
  ///
  /// In en, this message translates to:
  /// **'Arrows compare with the previous reading. Green is better, coral is worse.'**
  String get kpiArrowsNote;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @egp.
  ///
  /// In en, this message translates to:
  /// **'EGP'**
  String get egp;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @refundNeedsApprovalTitle.
  ///
  /// In en, this message translates to:
  /// **'Needs a second admin approval'**
  String get refundNeedsApprovalTitle;

  /// No description provided for @traveler.
  ///
  /// In en, this message translates to:
  /// **'Traveler'**
  String get traveler;

  /// No description provided for @supplierLabel.
  ///
  /// In en, this message translates to:
  /// **'Supplier'**
  String get supplierLabel;

  /// No description provided for @controlSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Every change is logged with a reason'**
  String get controlSubtitle;

  /// No description provided for @groupCommerce.
  ///
  /// In en, this message translates to:
  /// **'Commerce'**
  String get groupCommerce;

  /// No description provided for @changeNeedsApproval.
  ///
  /// In en, this message translates to:
  /// **'Changes need approval'**
  String get changeNeedsApproval;

  /// No description provided for @killSwitchesNote.
  ///
  /// In en, this message translates to:
  /// **'On stops the service'**
  String get killSwitchesNote;

  /// No description provided for @running.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get running;

  /// No description provided for @stoppedBy.
  ///
  /// In en, this message translates to:
  /// **'Stopped by {who}, {time}'**
  String stoppedBy(String who, String time);

  /// No description provided for @maintenanceMode.
  ///
  /// In en, this message translates to:
  /// **'Maintenance mode'**
  String get maintenanceMode;

  /// No description provided for @maintenanceHint.
  ///
  /// In en, this message translates to:
  /// **'Staff stay signed in while it\'s on'**
  String get maintenanceHint;

  /// No description provided for @statusHealthyShort.
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get statusHealthyShort;

  /// No description provided for @accessTitle.
  ///
  /// In en, this message translates to:
  /// **'Access'**
  String get accessTitle;

  /// No description provided for @accessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{users} users, {roles} roles'**
  String accessSubtitle(int users, int roles);

  /// No description provided for @reasonAskedOnSave.
  ///
  /// In en, this message translates to:
  /// **'You\'ll be asked for a reason'**
  String get reasonAskedOnSave;

  /// No description provided for @guestsCount.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{1 guest} other{{n} guests}}'**
  String guestsCount(int n);

  /// No description provided for @requestedAgo.
  ///
  /// In en, this message translates to:
  /// **'Requested {ago}'**
  String requestedAgo(String ago);

  /// No description provided for @paletteFootnote.
  ///
  /// In en, this message translates to:
  /// **'Results only include what your role can open.'**
  String get paletteFootnote;

  /// No description provided for @appNameLatin.
  ///
  /// In en, this message translates to:
  /// **'Dahab Ops'**
  String get appNameLatin;

  /// No description provided for @groupCatalog.
  ///
  /// In en, this message translates to:
  /// **'Catalogue'**
  String get groupCatalog;

  /// No description provided for @sectionCatalog.
  ///
  /// In en, this message translates to:
  /// **'Catalogue'**
  String get sectionCatalog;

  /// No description provided for @catMyListings.
  ///
  /// In en, this message translates to:
  /// **'My listings'**
  String get catMyListings;

  /// No description provided for @catSupplierHint.
  ///
  /// In en, this message translates to:
  /// **'Edit your listings and submit them for review. Dahab staff publish approved changes.'**
  String get catSupplierHint;

  /// No description provided for @catActions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get catActions;

  /// No description provided for @catAddDay.
  ///
  /// In en, this message translates to:
  /// **'Add day'**
  String get catAddDay;

  /// No description provided for @catAddItem.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get catAddItem;

  /// No description provided for @catAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get catAddPhoto;

  /// No description provided for @catAddTag.
  ///
  /// In en, this message translates to:
  /// **'Add a tag and press enter'**
  String get catAddTag;

  /// No description provided for @catAddTime.
  ///
  /// In en, this message translates to:
  /// **'Add time'**
  String get catAddTime;

  /// No description provided for @catArchive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get catArchive;

  /// No description provided for @catArchiveBody.
  ///
  /// In en, this message translates to:
  /// **'Archived listings disappear from the site. Bookings and history are kept.'**
  String get catArchiveBody;

  /// No description provided for @catArchiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Archive {name}?'**
  String catArchiveTitle(String name);

  /// No description provided for @catArchivedToast.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get catArchivedToast;

  /// No description provided for @catAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get catAvailable;

  /// No description provided for @catCamera.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get catCamera;

  /// No description provided for @catLibrary.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get catLibrary;

  /// No description provided for @catCannotPublish.
  ///
  /// In en, this message translates to:
  /// **'Can\'t publish yet'**
  String get catCannotPublish;

  /// No description provided for @catCapacity.
  ///
  /// In en, this message translates to:
  /// **'Capacity per slot'**
  String get catCapacity;

  /// No description provided for @catCloseDates.
  ///
  /// In en, this message translates to:
  /// **'Close these dates'**
  String get catCloseDates;

  /// No description provided for @catClosedShort.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get catClosedShort;

  /// No description provided for @catConflictBody.
  ///
  /// In en, this message translates to:
  /// **'Someone else saved this listing while you were editing. Keep your changes on top of theirs, or reload their version.'**
  String get catConflictBody;

  /// No description provided for @catConflictKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep mine'**
  String get catConflictKeep;

  /// No description provided for @catConflictReload.
  ///
  /// In en, this message translates to:
  /// **'Reload'**
  String get catConflictReload;

  /// No description provided for @catConflictShort.
  ///
  /// In en, this message translates to:
  /// **'Changed elsewhere'**
  String get catConflictShort;

  /// No description provided for @catConflictTitle.
  ///
  /// In en, this message translates to:
  /// **'Edited elsewhere'**
  String get catConflictTitle;

  /// No description provided for @catCountDrafts.
  ///
  /// In en, this message translates to:
  /// **'drafts'**
  String get catCountDrafts;

  /// No description provided for @catCountReview.
  ///
  /// In en, this message translates to:
  /// **'in review'**
  String get catCountReview;

  /// No description provided for @catCover.
  ///
  /// In en, this message translates to:
  /// **'Cover'**
  String get catCover;

  /// No description provided for @catCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get catCustom;

  /// No description provided for @catDay.
  ///
  /// In en, this message translates to:
  /// **'Day {n}'**
  String catDay(int n);

  /// No description provided for @catDayBody.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get catDayBody;

  /// No description provided for @catDayTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get catDayTitle;

  /// No description provided for @catDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get catDelete;

  /// No description provided for @catDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'Only drafts that were never booked can be deleted. Anything else is archived instead.'**
  String get catDeleteBody;

  /// No description provided for @catDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String catDeleteTitle(String name);

  /// No description provided for @catDeletedToast.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get catDeletedToast;

  /// No description provided for @catDraftSaved.
  ///
  /// In en, this message translates to:
  /// **'Draft saved'**
  String get catDraftSaved;

  /// No description provided for @catDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get catDuplicate;

  /// No description provided for @catDuplicatedToast.
  ///
  /// In en, this message translates to:
  /// **'Copy created as a draft'**
  String get catDuplicatedToast;

  /// No description provided for @catEditPrice.
  ///
  /// In en, this message translates to:
  /// **'Edit price'**
  String get catEditPrice;

  /// No description provided for @catEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet. Tap New to add the first one.'**
  String get catEmptyBody;

  /// No description provided for @catFilterSupplier.
  ///
  /// In en, this message translates to:
  /// **'Filter by supplier'**
  String get catFilterSupplier;

  /// No description provided for @catFromPrice.
  ///
  /// In en, this message translates to:
  /// **'from {price}'**
  String catFromPrice(String price);

  /// No description provided for @catHiddenToast.
  ///
  /// In en, this message translates to:
  /// **'Hidden from the site'**
  String get catHiddenToast;

  /// No description provided for @catHide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get catHide;

  /// No description provided for @catHoursShort.
  ///
  /// In en, this message translates to:
  /// **'{h} h'**
  String catHoursShort(int h);

  /// No description provided for @catMinutesShort.
  ///
  /// In en, this message translates to:
  /// **'{m} min'**
  String catMinutesShort(int m);

  /// No description provided for @catMinutesUnit.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get catMinutesUnit;

  /// No description provided for @catInUseBody.
  ///
  /// In en, this message translates to:
  /// **'This listing has bookings, so it can\'t be deleted. Archive it instead?'**
  String get catInUseBody;

  /// No description provided for @catInUseTitle.
  ///
  /// In en, this message translates to:
  /// **'In use'**
  String get catInUseTitle;

  /// No description provided for @catInvalidJson.
  ///
  /// In en, this message translates to:
  /// **'Not valid JSON'**
  String get catInvalidJson;

  /// No description provided for @catItemName.
  ///
  /// In en, this message translates to:
  /// **'Item name'**
  String get catItemName;

  /// No description provided for @catLat.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get catLat;

  /// No description provided for @catLng.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get catLng;

  /// No description provided for @catMenu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get catMenu;

  /// No description provided for @catMenuOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get catMenuOther;

  /// No description provided for @catMissingCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 missing} other{{count} missing}}'**
  String catMissingCount(int count);

  /// No description provided for @catMissingLang.
  ///
  /// In en, this message translates to:
  /// **'{lang} is missing'**
  String catMissingLang(String lang);

  /// No description provided for @catMissingTitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 thing missing before publishing} other{{count} things missing before publishing}}'**
  String catMissingTitle(int count);

  /// No description provided for @catNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get catNew;

  /// No description provided for @catNewSection.
  ///
  /// In en, this message translates to:
  /// **'Or type a new section'**
  String get catNewSection;

  /// No description provided for @catNewType.
  ///
  /// In en, this message translates to:
  /// **'New · {type}'**
  String catNewType(String type);

  /// No description provided for @catNextStep.
  ///
  /// In en, this message translates to:
  /// **'Save & next'**
  String get catNextStep;

  /// No description provided for @catNightlyPrice.
  ///
  /// In en, this message translates to:
  /// **'Price per night'**
  String get catNightlyPrice;

  /// No description provided for @catNights.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 night} other{{count} nights}}'**
  String catNights(int count);

  /// No description provided for @catNoRooms.
  ///
  /// In en, this message translates to:
  /// **'Add a room first'**
  String get catNoRooms;

  /// No description provided for @catNoSupplier.
  ///
  /// In en, this message translates to:
  /// **'Choose a supplier'**
  String get catNoSupplier;

  /// No description provided for @catNotSaved.
  ///
  /// In en, this message translates to:
  /// **'Not saved yet'**
  String get catNotSaved;

  /// No description provided for @catOrders.
  ///
  /// In en, this message translates to:
  /// **'Bookings & orders'**
  String get catOrders;

  /// No description provided for @catPhotoHint.
  ///
  /// In en, this message translates to:
  /// **'{count} of {max} · long-press and drag to reorder · the first photo is the cover'**
  String catPhotoHint(int count, int max);

  /// No description provided for @catPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get catPrice;

  /// No description provided for @catPriceReasonBody.
  ///
  /// In en, this message translates to:
  /// **'{from} to {to} is a change of more than 30%. Say why.'**
  String catPriceReasonBody(String from, String to);

  /// No description provided for @catPriceReasonTitle.
  ///
  /// In en, this message translates to:
  /// **'Large price change'**
  String get catPriceReasonTitle;

  /// No description provided for @catPublish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get catPublish;

  /// No description provided for @catPublishChanges.
  ///
  /// In en, this message translates to:
  /// **'Publish changes'**
  String get catPublishChanges;

  /// No description provided for @catPublishedToast.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get catPublishedToast;

  /// No description provided for @catRangeHint.
  ///
  /// In en, this message translates to:
  /// **'Tap a day, or long-press and drag across days, then set the price or close them.'**
  String get catRangeHint;

  /// No description provided for @catRates.
  ///
  /// In en, this message translates to:
  /// **'Rates calendar'**
  String get catRates;

  /// No description provided for @catRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get catRequired;

  /// No description provided for @catRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get catRestore;

  /// No description provided for @catRestoredToast.
  ///
  /// In en, this message translates to:
  /// **'Restored'**
  String get catRestoredToast;

  /// No description provided for @catRooms.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get catRooms;

  /// No description provided for @catSaveDraft.
  ///
  /// In en, this message translates to:
  /// **'Save draft'**
  String get catSaveDraft;

  /// No description provided for @catSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Not saved. Retrying on the next edit.'**
  String get catSaveFailed;

  /// No description provided for @catSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get catSaving;

  /// No description provided for @catSearchSuppliers.
  ///
  /// In en, this message translates to:
  /// **'Search suppliers'**
  String get catSearchSuppliers;

  /// No description provided for @catSection.
  ///
  /// In en, this message translates to:
  /// **'Section'**
  String get catSection;

  /// No description provided for @catSlots.
  ///
  /// In en, this message translates to:
  /// **'Departures'**
  String get catSlots;

  /// No description provided for @catSlotsHint.
  ///
  /// In en, this message translates to:
  /// **'Long-press and drag across days to set times and capacity, or close them.'**
  String get catSlotsHint;

  /// No description provided for @catStatusArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get catStatusArchived;

  /// No description provided for @catStatusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get catStatusDraft;

  /// No description provided for @catStatusHidden.
  ///
  /// In en, this message translates to:
  /// **'Hidden'**
  String get catStatusHidden;

  /// No description provided for @catStatusPublished.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get catStatusPublished;

  /// No description provided for @catStatusReview.
  ///
  /// In en, this message translates to:
  /// **'In review'**
  String get catStatusReview;

  /// No description provided for @catStepBasics.
  ///
  /// In en, this message translates to:
  /// **'Basics'**
  String get catStepBasics;

  /// No description provided for @catStepPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get catStepPhotos;

  /// No description provided for @catStepPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get catStepPrice;

  /// No description provided for @catSubmitReview.
  ///
  /// In en, this message translates to:
  /// **'Submit for review'**
  String get catSubmitReview;

  /// No description provided for @catSubmittedToast.
  ///
  /// In en, this message translates to:
  /// **'Sent to Dahab for review'**
  String get catSubmittedToast;

  /// No description provided for @catTimes.
  ///
  /// In en, this message translates to:
  /// **'Start times'**
  String get catTimes;

  /// No description provided for @catUnsaved.
  ///
  /// In en, this message translates to:
  /// **'Unsaved changes'**
  String get catUnsaved;

  /// No description provided for @catUntitled.
  ///
  /// In en, this message translates to:
  /// **'Untitled'**
  String get catUntitled;

  /// No description provided for @catWeekdays.
  ///
  /// In en, this message translates to:
  /// **'Apply on'**
  String get catWeekdays;

  /// No description provided for @killPaymentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get killPaymentsTitle;

  /// No description provided for @killPaymentsDesc.
  ///
  /// In en, this message translates to:
  /// **'Stops checkout and payment capture'**
  String get killPaymentsDesc;

  /// No description provided for @killBookingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get killBookingsTitle;

  /// No description provided for @killBookingsDesc.
  ///
  /// In en, this message translates to:
  /// **'Stops new holds, bookings and orders'**
  String get killBookingsDesc;

  /// No description provided for @killAiTitle.
  ///
  /// In en, this message translates to:
  /// **'AI features'**
  String get killAiTitle;

  /// No description provided for @killAiDesc.
  ///
  /// In en, this message translates to:
  /// **'Stops AI-backed endpoints (DayGI, trip generation)'**
  String get killAiDesc;

  /// No description provided for @killSmsTitle.
  ///
  /// In en, this message translates to:
  /// **'Outbound SMS'**
  String get killSmsTitle;

  /// No description provided for @killSmsDesc.
  ///
  /// In en, this message translates to:
  /// **'Stops outbound SMS'**
  String get killSmsDesc;

  /// No description provided for @killSupplierSignupTitle.
  ///
  /// In en, this message translates to:
  /// **'Supplier sign-up'**
  String get killSupplierSignupTitle;

  /// No description provided for @killSupplierSignupDesc.
  ///
  /// In en, this message translates to:
  /// **'Stops supplier self-signup'**
  String get killSupplierSignupDesc;

  /// No description provided for @flagMaintenanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Maintenance mode'**
  String get flagMaintenanceTitle;

  /// No description provided for @flagMaintenanceDesc.
  ///
  /// In en, this message translates to:
  /// **'Non-staff API calls get 503'**
  String get flagMaintenanceDesc;

  /// No description provided for @actorSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get actorSystem;

  /// No description provided for @allPermissions.
  ///
  /// In en, this message translates to:
  /// **'All permissions'**
  String get allPermissions;

  /// No description provided for @listSeparator.
  ///
  /// In en, this message translates to:
  /// **', '**
  String get listSeparator;

  /// No description provided for @roleTraveler.
  ///
  /// In en, this message translates to:
  /// **'Traveler'**
  String get roleTraveler;

  /// No description provided for @roleSupplier.
  ///
  /// In en, this message translates to:
  /// **'Supplier'**
  String get roleSupplier;

  /// No description provided for @roleOperations.
  ///
  /// In en, this message translates to:
  /// **'Operations'**
  String get roleOperations;

  /// No description provided for @roleProduct.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get roleProduct;

  /// No description provided for @roleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get roleAdmin;

  /// No description provided for @ccHubSubtitle.
  ///
  /// In en, this message translates to:
  /// **'One desk for the web and both apps'**
  String get ccHubSubtitle;

  /// No description provided for @ccGroupApp.
  ///
  /// In en, this message translates to:
  /// **'App & content'**
  String get ccGroupApp;

  /// No description provided for @ccGroupPlatform.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get ccGroupPlatform;

  /// No description provided for @ccTileExperience.
  ///
  /// In en, this message translates to:
  /// **'App experience'**
  String get ccTileExperience;

  /// No description provided for @ccTileExperienceSub.
  ///
  /// In en, this message translates to:
  /// **'Maintenance, banner, switches, versions'**
  String get ccTileExperienceSub;

  /// No description provided for @ccTileHomepage.
  ///
  /// In en, this message translates to:
  /// **'Homepage sections'**
  String get ccTileHomepage;

  /// No description provided for @ccTileHomepageSub.
  ///
  /// In en, this message translates to:
  /// **'Order, visibility and section config'**
  String get ccTileHomepageSub;

  /// No description provided for @ccTileProgrammes.
  ///
  /// In en, this message translates to:
  /// **'Trip programmes'**
  String get ccTileProgrammes;

  /// No description provided for @ccTileProgrammesSub.
  ///
  /// In en, this message translates to:
  /// **'The ready-made trips both apps render'**
  String get ccTileProgrammesSub;

  /// No description provided for @ccTileNavigation.
  ///
  /// In en, this message translates to:
  /// **'Navigation menus'**
  String get ccTileNavigation;

  /// No description provided for @ccTileNavigationSub.
  ///
  /// In en, this message translates to:
  /// **'The CMS-managed web menus'**
  String get ccTileNavigationSub;

  /// No description provided for @ccTileCmsSub.
  ///
  /// In en, this message translates to:
  /// **'Pages, publishing and media'**
  String get ccTileCmsSub;

  /// No description provided for @ccTileSettingsSub.
  ///
  /// In en, this message translates to:
  /// **'Typed settings with history and rollback'**
  String get ccTileSettingsSub;

  /// No description provided for @ccTileFlagsSub.
  ///
  /// In en, this message translates to:
  /// **'Feature flags and targeting'**
  String get ccTileFlagsSub;

  /// No description provided for @ccTileIntegrationsSub.
  ///
  /// In en, this message translates to:
  /// **'Live provider health'**
  String get ccTileIntegrationsSub;

  /// No description provided for @ccTileApprovalsSub.
  ///
  /// In en, this message translates to:
  /// **'Queued changes awaiting a second admin'**
  String get ccTileApprovalsSub;

  /// No description provided for @ccTileUsers.
  ///
  /// In en, this message translates to:
  /// **'Users & roles'**
  String get ccTileUsers;

  /// No description provided for @ccTileUsersSub.
  ///
  /// In en, this message translates to:
  /// **'Accounts, roles and overrides'**
  String get ccTileUsersSub;

  /// No description provided for @ccTileAuditSub.
  ///
  /// In en, this message translates to:
  /// **'Every change, who made it and why'**
  String get ccTileAuditSub;

  /// No description provided for @ccMaintenanceOn.
  ///
  /// In en, this message translates to:
  /// **'Platform under maintenance'**
  String get ccMaintenanceOn;

  /// No description provided for @ccMaintenanceOnSub.
  ///
  /// In en, this message translates to:
  /// **'Travelers see the maintenance screen until you lift it.'**
  String get ccMaintenanceOnSub;

  /// No description provided for @ccKillsOn.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 capability switched off} other{{count} capabilities switched off}}'**
  String ccKillsOn(num count);

  /// No description provided for @ccAllClear.
  ///
  /// In en, this message translates to:
  /// **'Everything is live'**
  String get ccAllClear;

  /// No description provided for @ccAllClearSub.
  ///
  /// In en, this message translates to:
  /// **'No maintenance, no engaged switches.'**
  String get ccAllClearSub;

  /// No description provided for @ccReadingApprovals.
  ///
  /// In en, this message translates to:
  /// **'Approvals'**
  String get ccReadingApprovals;

  /// No description provided for @ccReadingKills.
  ///
  /// In en, this message translates to:
  /// **'Switches off'**
  String get ccReadingKills;

  /// No description provided for @ccReadingIntegrations.
  ///
  /// In en, this message translates to:
  /// **'Degraded'**
  String get ccReadingIntegrations;

  /// No description provided for @previewQuiet.
  ///
  /// In en, this message translates to:
  /// **'Travelers see the app normally'**
  String get previewQuiet;

  /// No description provided for @ccSaveSettingTitle.
  ///
  /// In en, this message translates to:
  /// **'Change {key}?'**
  String ccSaveSettingTitle(Object key);

  /// No description provided for @ccMaintenanceHint.
  ///
  /// In en, this message translates to:
  /// **'Flips every client to the maintenance screen.'**
  String get ccMaintenanceHint;

  /// No description provided for @ccPreviewEn.
  ///
  /// In en, this message translates to:
  /// **'Preview - English'**
  String get ccPreviewEn;

  /// No description provided for @ccPreviewAr.
  ///
  /// In en, this message translates to:
  /// **'Preview - Arabic'**
  String get ccPreviewAr;

  /// No description provided for @ccAnnouncementTitle.
  ///
  /// In en, this message translates to:
  /// **'Announcement banner'**
  String get ccAnnouncementTitle;

  /// No description provided for @ccAnnouncementNote.
  ///
  /// In en, this message translates to:
  /// **'Shown at the top of every client'**
  String get ccAnnouncementNote;

  /// No description provided for @ccBannerOn.
  ///
  /// In en, this message translates to:
  /// **'Banner is live'**
  String get ccBannerOn;

  /// No description provided for @ccBannerOff.
  ///
  /// In en, this message translates to:
  /// **'No banner'**
  String get ccBannerOff;

  /// No description provided for @ccBannerInfo.
  ///
  /// In en, this message translates to:
  /// **'Tone: info'**
  String get ccBannerInfo;

  /// No description provided for @ccBannerWarn.
  ///
  /// In en, this message translates to:
  /// **'Tone: warning'**
  String get ccBannerWarn;

  /// No description provided for @ccBannerEnable.
  ///
  /// In en, this message translates to:
  /// **'Show the announcement banner?'**
  String get ccBannerEnable;

  /// No description provided for @ccBannerDisable.
  ///
  /// In en, this message translates to:
  /// **'Hide the announcement banner?'**
  String get ccBannerDisable;

  /// No description provided for @ccFeatureFlags.
  ///
  /// In en, this message translates to:
  /// **'Feature flags'**
  String get ccFeatureFlags;

  /// No description provided for @ccFlagsManageAll.
  ///
  /// In en, this message translates to:
  /// **'Manage all'**
  String get ccFlagsManageAll;

  /// No description provided for @ccRolloutReading.
  ///
  /// In en, this message translates to:
  /// **'{value} rollout'**
  String ccRolloutReading(Object value);

  /// No description provided for @ccFlagOn.
  ///
  /// In en, this message translates to:
  /// **'ON'**
  String get ccFlagOn;

  /// No description provided for @ccFlagOff.
  ///
  /// In en, this message translates to:
  /// **'OFF'**
  String get ccFlagOff;

  /// No description provided for @ccFlagEnable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get ccFlagEnable;

  /// No description provided for @ccFlagDisable.
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get ccFlagDisable;

  /// No description provided for @ccFlagEnableTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable {key}?'**
  String ccFlagEnableTitle(Object key);

  /// No description provided for @ccFlagDisableTitle.
  ///
  /// In en, this message translates to:
  /// **'Disable {key}?'**
  String ccFlagDisableTitle(Object key);

  /// No description provided for @ccFlagEngaged.
  ///
  /// In en, this message translates to:
  /// **'OFF'**
  String get ccFlagEngaged;

  /// No description provided for @ccFlagNormal.
  ///
  /// In en, this message translates to:
  /// **'LIVE'**
  String get ccFlagNormal;

  /// No description provided for @ccKillEngageTitle.
  ///
  /// In en, this message translates to:
  /// **'Switch off {title}?'**
  String ccKillEngageTitle(Object title);

  /// No description provided for @ccKillReleaseTitle.
  ///
  /// In en, this message translates to:
  /// **'Switch {title} back on?'**
  String ccKillReleaseTitle(Object title);

  /// No description provided for @ccGatesTitle.
  ///
  /// In en, this message translates to:
  /// **'App version gates'**
  String get ccGatesTitle;

  /// No description provided for @ccGatesNote.
  ///
  /// In en, this message translates to:
  /// **'Forces or nudges app updates'**
  String get ccGatesNote;

  /// No description provided for @ccPlatformAndroid.
  ///
  /// In en, this message translates to:
  /// **'Android'**
  String get ccPlatformAndroid;

  /// No description provided for @ccPlatformIos.
  ///
  /// In en, this message translates to:
  /// **'iOS'**
  String get ccPlatformIos;

  /// No description provided for @ccMinVersion.
  ///
  /// In en, this message translates to:
  /// **'Minimum version'**
  String get ccMinVersion;

  /// No description provided for @ccLatestVersion.
  ///
  /// In en, this message translates to:
  /// **'Latest version'**
  String get ccLatestVersion;

  /// No description provided for @ccStoreUrl.
  ///
  /// In en, this message translates to:
  /// **'Store URL'**
  String get ccStoreUrl;

  /// No description provided for @ccSimulatorTitle.
  ///
  /// In en, this message translates to:
  /// **'Simulate a build'**
  String get ccSimulatorTitle;

  /// No description provided for @ccSimulatorHint.
  ///
  /// In en, this message translates to:
  /// **'App version, e.g. 1.2.0'**
  String get ccSimulatorHint;

  /// No description provided for @ccSimulatorEmpty.
  ///
  /// In en, this message translates to:
  /// **'Type a version to see the gate verdict.'**
  String get ccSimulatorEmpty;

  /// No description provided for @ccVersionInvalid.
  ///
  /// In en, this message translates to:
  /// **'Use a dotted version like 1.2.0.'**
  String get ccVersionInvalid;

  /// No description provided for @ccGateBlocked.
  ///
  /// In en, this message translates to:
  /// **'UPDATE BLOCKED'**
  String get ccGateBlocked;

  /// No description provided for @ccGateUpdate.
  ///
  /// In en, this message translates to:
  /// **'UPDATE SUGGESTED'**
  String get ccGateUpdate;

  /// No description provided for @ccGateOk.
  ///
  /// In en, this message translates to:
  /// **'UP TO DATE'**
  String get ccGateOk;

  /// No description provided for @ccHomepageEmpty.
  ///
  /// In en, this message translates to:
  /// **'No homepage sections yet'**
  String get ccHomepageEmpty;

  /// No description provided for @ccHomepageHint.
  ///
  /// In en, this message translates to:
  /// **'Drag to reorder. Order and visibility go live on the web instantly.'**
  String get ccHomepageHint;

  /// No description provided for @ccHomepageReordered.
  ///
  /// In en, this message translates to:
  /// **'Order saved.'**
  String get ccHomepageReordered;

  /// No description provided for @ccVisible.
  ///
  /// In en, this message translates to:
  /// **'Visible'**
  String get ccVisible;

  /// No description provided for @ccTitleEn.
  ///
  /// In en, this message translates to:
  /// **'Title (English)'**
  String get ccTitleEn;

  /// No description provided for @ccTitleAr.
  ///
  /// In en, this message translates to:
  /// **'Title (Arabic)'**
  String get ccTitleAr;

  /// No description provided for @ccConfigJson.
  ///
  /// In en, this message translates to:
  /// **'Section config (JSON)'**
  String get ccConfigJson;

  /// No description provided for @ccInvalidJson.
  ///
  /// In en, this message translates to:
  /// **'This is not valid JSON.'**
  String get ccInvalidJson;

  /// No description provided for @ccConfigMustBeObject.
  ///
  /// In en, this message translates to:
  /// **'The config must be a JSON object.'**
  String get ccConfigMustBeObject;

  /// No description provided for @ccProgrammeNew.
  ///
  /// In en, this message translates to:
  /// **'New programme'**
  String get ccProgrammeNew;

  /// No description provided for @ccAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get ccAll;

  /// No description provided for @ccAllDestinations.
  ///
  /// In en, this message translates to:
  /// **'All destinations'**
  String get ccAllDestinations;

  /// No description provided for @ccDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get ccDraft;

  /// No description provided for @ccArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get ccArchived;

  /// No description provided for @ccDestDahab.
  ///
  /// In en, this message translates to:
  /// **'Dahab'**
  String get ccDestDahab;

  /// No description provided for @ccDestNuweiba.
  ///
  /// In en, this message translates to:
  /// **'Nuweiba'**
  String get ccDestNuweiba;

  /// No description provided for @ccDestSiwa.
  ///
  /// In en, this message translates to:
  /// **'Siwa'**
  String get ccDestSiwa;

  /// No description provided for @ccProgrammesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No programmes match'**
  String get ccProgrammesEmpty;

  /// No description provided for @ccProgrammesEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Adjust the filters, or create a new programme.'**
  String get ccProgrammesEmptyBody;

  /// No description provided for @ccProgrammeId.
  ///
  /// In en, this message translates to:
  /// **'ID (stable, e.g. dahab-slow-weekend)'**
  String get ccProgrammeId;

  /// No description provided for @ccTaglineEn.
  ///
  /// In en, this message translates to:
  /// **'Tagline (English)'**
  String get ccTaglineEn;

  /// No description provided for @ccTaglineAr.
  ///
  /// In en, this message translates to:
  /// **'Tagline (Arabic)'**
  String get ccTaglineAr;

  /// No description provided for @ccDestination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get ccDestination;

  /// No description provided for @ccPace.
  ///
  /// In en, this message translates to:
  /// **'Pace'**
  String get ccPace;

  /// No description provided for @ccBudget.
  ///
  /// In en, this message translates to:
  /// **'Default budget'**
  String get ccBudget;

  /// No description provided for @ccDurationDays.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get ccDurationDays;

  /// No description provided for @ccPriceEgp.
  ///
  /// In en, this message translates to:
  /// **'From price (EGP)'**
  String get ccPriceEgp;

  /// No description provided for @ccPriceEstimate.
  ///
  /// In en, this message translates to:
  /// **'Price is an estimate'**
  String get ccPriceEstimate;

  /// No description provided for @ccPriceEstimateHint.
  ///
  /// In en, this message translates to:
  /// **'True while no supplier quotes it yet'**
  String get ccPriceEstimateHint;

  /// No description provided for @ccIdealForEn.
  ///
  /// In en, this message translates to:
  /// **'Ideal for (English)'**
  String get ccIdealForEn;

  /// No description provided for @ccIdealForAr.
  ///
  /// In en, this message translates to:
  /// **'Ideal for (Arabic)'**
  String get ccIdealForAr;

  /// No description provided for @ccHighlightsEn.
  ///
  /// In en, this message translates to:
  /// **'Highlights (English)'**
  String get ccHighlightsEn;

  /// No description provided for @ccHighlightsAr.
  ///
  /// In en, this message translates to:
  /// **'Highlights (Arabic)'**
  String get ccHighlightsAr;

  /// No description provided for @ccCommaSeparated.
  ///
  /// In en, this message translates to:
  /// **'Separate items with commas'**
  String get ccCommaSeparated;

  /// No description provided for @ccDayByDay.
  ///
  /// In en, this message translates to:
  /// **'Day by day'**
  String get ccDayByDay;

  /// No description provided for @ccAddDay.
  ///
  /// In en, this message translates to:
  /// **'Add day'**
  String get ccAddDay;

  /// No description provided for @ccNoDaysYet.
  ///
  /// In en, this message translates to:
  /// **'No days planned yet.'**
  String get ccNoDaysYet;

  /// No description provided for @ccSubtitleEn.
  ///
  /// In en, this message translates to:
  /// **'Subtitle (English)'**
  String get ccSubtitleEn;

  /// No description provided for @ccTimeEstimate.
  ///
  /// In en, this message translates to:
  /// **'Time estimate'**
  String get ccTimeEstimate;

  /// No description provided for @ccCreate.
  ///
  /// In en, this message translates to:
  /// **'Create programme'**
  String get ccCreate;

  /// No description provided for @ccProgrammeCreateConfirm.
  ///
  /// In en, this message translates to:
  /// **'Create this programme?'**
  String get ccProgrammeCreateConfirm;

  /// No description provided for @ccProgrammePublishConfirm.
  ///
  /// In en, this message translates to:
  /// **'Publish this programme?'**
  String get ccProgrammePublishConfirm;

  /// No description provided for @ccProgrammePublishBody.
  ///
  /// In en, this message translates to:
  /// **'It appears on the web and the REHLA app immediately.'**
  String get ccProgrammePublishBody;

  /// No description provided for @ccProgrammeArchiveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Archive this programme?'**
  String get ccProgrammeArchiveConfirm;

  /// No description provided for @ccProgrammeArchiveBody.
  ///
  /// In en, this message translates to:
  /// **'It disappears from both apps but stays in the dashboard.'**
  String get ccProgrammeArchiveBody;

  /// No description provided for @ccArchivedToast.
  ///
  /// In en, this message translates to:
  /// **'Programme archived.'**
  String get ccArchivedToast;

  /// No description provided for @ccProgrammeDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this programme?'**
  String get ccProgrammeDeleteConfirm;

  /// No description provided for @ccProgrammeDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone. Consider archiving instead.'**
  String get ccProgrammeDeleteBody;

  /// No description provided for @ccProgrammeDeleted.
  ///
  /// In en, this message translates to:
  /// **'Programme deleted.'**
  String get ccProgrammeDeleted;

  /// No description provided for @deleteLabel.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteLabel;

  /// No description provided for @noticeFailed.
  ///
  /// In en, this message translates to:
  /// **'The change could not be made.'**
  String get noticeFailed;

  /// No description provided for @ccNavItemNew.
  ///
  /// In en, this message translates to:
  /// **'New navigation item'**
  String get ccNavItemNew;

  /// No description provided for @ccNavItemEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit navigation item'**
  String get ccNavItemEdit;

  /// No description provided for @ccNavEmpty.
  ///
  /// In en, this message translates to:
  /// **'No items in this menu'**
  String get ccNavEmpty;

  /// No description provided for @ccNavEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Create the first item for this menu.'**
  String get ccNavEmptyBody;

  /// No description provided for @ccNavRoute.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get ccNavRoute;

  /// No description provided for @ccNavRouteHint.
  ///
  /// In en, this message translates to:
  /// **'In-app path like /hotels'**
  String get ccNavRouteHint;

  /// No description provided for @ccNavExternal.
  ///
  /// In en, this message translates to:
  /// **'External URL'**
  String get ccNavExternal;

  /// No description provided for @ccNavOrder.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get ccNavOrder;

  /// No description provided for @ccHidden.
  ///
  /// In en, this message translates to:
  /// **'HIDDEN'**
  String get ccHidden;

  /// No description provided for @ccNavDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {label}?'**
  String ccNavDeleteTitle(Object label);

  /// No description provided for @ccNavLabelRequired.
  ///
  /// In en, this message translates to:
  /// **'A label is required.'**
  String get ccNavLabelRequired;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
