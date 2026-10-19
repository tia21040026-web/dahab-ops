# Dahab Ops

The staff dashboard for the Dahab travel platform, as a Flutter app for iOS and
Android. Operations, suppliers, product and admins use it; travellers never do.
It talks to the same backend as the web command center, using the native auth
flow in `../docs/OPS_API_CONTRACT.md`.

Visual direction: "Lagoon Instrument". Depth comes from hairlines, not shadows.
Each screen has one filled action. Display numbers use Fraunces (Alexandria for
Arabic) and IDs use IBM Plex Mono. Colour is reserved for status and action.
Arabic is fully RTL.

## Before you start: the path junction (Windows)

The repository lives under `D:\dahab-—-travel-platform\…`. The Dart analysis
server crashes on the em dash in that path. Always work through the ASCII
junction:

```
C:\src\dahab-ops  →  D:\dahab-—-travel-platform\Travel.eg\dahab-ops
```

To recreate the junction (cmd, once):
`mklink /J C:\src\dahab-ops "D:\dahab-—-travel-platform\Travel.eg\dahab-ops"`.
Open that path in your IDE, and `cd` into it before running any tool.

**Android builds need a `subst` drive, not the junction.** Gradle resolves the
junction back to the em-dash path, and the APK is then packaged without
`flutter_assets` (no Material icon font: icons render as random glyphs) and
`aapt` cannot read the APK, so `flutter run` cannot install it. A `subst` drive
keeps the path ASCII all the way down:

```
subst O: "D:\dahab-—-travel-platform\Travel.eg\dahab-ops"
```

Then build, run and install from `O:\`. `subst` does not survive a reboot, so
run it again after restarting Windows.

## Toolchain

The app is pinned to Flutter **3.44.7** through fvm (Dart 3.12). Do not use an
older Flutter that may be on `PATH`. In Git Bash:

```bash
export PATH="/c/Program Files/PowerShell/7:/c/Windows/System32:$PATH"   # flutter.bat needs pwsh
F=/c/Users/mohamed/fvm/versions/3.44.7/bin
cd /c/src/dahab-ops

$F/flutter.bat pub get
$F/flutter.bat gen-l10n                                          # after editing lib/l10n/*.arb
$F/cache/dart-sdk/bin/dart.exe run build_runner build --delete-conflicting-outputs   # routes, DI, freezed
$F/cache/dart-sdk/bin/dart.exe analyze                           # must stay at 0 errors, 0 warnings
$F/flutter.bat test                                              # unit + widget + golden
$F/flutter.bat test --update-goldens test/golden                 # only after an intended visual change
```

With fvm on `PATH`, `fvm flutter …` and `fvm dart …` do the same thing.

## Running

```bash
fvm flutter run                                    # dev: Android emulator → http://10.0.2.2:3000
fvm flutter run --dart-define=DAHAB_ENV=staging    # https://staging.dahab.travel
fvm flutter run --dart-define=DAHAB_ENV=prod       # https://dahab.travel
fvm flutter run --dart-define=DAHAB_API_BASE=http://192.168.1.20:3000   # a device on your LAN
```

| Define | Values | Default |
|---|---|---|
| `DAHAB_ENV` | `dev`, `staging`, `prod` | `dev` |
| `DAHAB_API_BASE` | API origin with no `/api` | taken from the env |

The definitions live in `lib/env/env.dart`. HTTP logging is on in debug dev
builds only, and it never logs headers or bodies.

## Architecture

```
lib/
  app.dart                 MaterialApp.router, theme/locale, app lock, view-as shell
  env/                     build environments
  core/
    api/                   ApiClient (Dio), ApiError (RFC7807), AuthInterceptor
                           (single-flight refresh), RetryInterceptor, Idempotency,
                           TokenStore, models/ (freezed contract models, JsonRecord)
    design/                tokens (generated from web tokens.css), AppTheme, typography,
                           components/ (see below)
    list/                  ListCubit<T>, AsyncListView<T>, SectionScaffold, DetailSheet
    realtime/              SSE client + parser, polling fallback
    router/                auto_route config, AuthGuard, TabsPage (role-aware), MorePage
    di/                    get_it + injectable
    connectivity/, preferences/, platform/ (biometrics, device), storage/
  features/
    auth/                  login, splash, app lock
    access/                session (can()), users, user detail, invite, role matrix,
                           overrides editor, view-as banner
    control/               hub, settings (typed + history/rollback), flags & kill
                           switches, maintenance, integrations, approvals, audit, devices
    pulse/, queue/, booking/, refund/, search/
    ops/<section>/         live, exceptions, commerce, support, messaging (notifications,
                           SMS), suppliers, stays, pricing, dining, system (jobs, health),
                           insight (knowledge, opportunities, market intelligence)
    supplier/              inbox, plus portal: inventory/calendar, stays, rentals,
                           revenue (fl_chart), reliability, audit
    cms/                   pages list, page editor (content/SEO), publish, media upload,
                           revisions
  l10n/                    intl_en.arb (template), intl_ar.arb, generated/
test/
  unit/                    session/permissions, AuthInterceptor, ApiError, SSE, LoginCubit,
                           ListCubit
  widget/                  PermissionGate, ConfirmDangerSheet, RefundSheet, tabs per role,
                           KpiCard RTL, AsyncListView
  golden/                  KpiCard + StatusStrip × abyss/salt × en/ar
  helpers/                 fake Dio adapter, mocks, testApp() + offline test fonts
```

The main rules:

- **State.** Each screen gets a cubit from `flutter_bloc`. Screens that are only
  lists use the generic `ListCubit<T>`, which handles first load, refresh,
  cursor paging, filters, sort and search. You pass it the repository call.
- **Errors.** Every failure becomes an `ApiError`. Show it with `ErrorView`
  (full screen) or `showErrorToast` (inline). Both show the `correlationId`,
  and people can copy it.
- **Permissions.** `SessionCubit.can('area.section.action')` supports `*` and
  `ops.*`. Wrap any UI that needs a permission in `PermissionGate`. The server
  still enforces every key; the gate only hides what would answer 403. A plain
  403 makes the app re-read `/api/auth/me`.
- **Dangerous actions.** These use `showConfirmDangerSheet`. It asks for a
  reason of 3–500 characters and can add a Face ID check. Pass
  `requiresApproval: true` to show the "needs a second admin" notice. A 403
  `approval-required` is treated as queued, not as a failure.
- **Money and messages.** These send an `Idempotency-Key`, one per user intent.
  A retry reuses the same key, so the server replays the first result (see
  `SmsComposer` and `RefundRepository`).
- **Legacy endpoints.** Ops endpoints that predate the contract (`{ trips }`,
  `{ bookings }` and so on) are wrapped in `JsonRecord` subclasses with typed
  getters, and read with `pagedFrom()`. They have no codegen model.
- **RTL.** Lay out with `EdgeInsetsDirectional` and `AlignmentDirectional`.
  IDs, amounts and charts stay LTR (`MonoText`, and charts wrapped in
  `Directionality.ltr`). Arabic is never tracked or uppercased.

Core components live in `lib/core/design/components/`: `KpiCard`,
`StatusStrip`, `StatusBadge`, `SectionHeader`, `DahabButton`, `DahabTextField`,
`Panel`/`MonoText`/`StatusDot`/`Hairline`/`Monogram`, `ConfirmDangerSheet`,
`PermissionGate`/`NoAccessView`, `EmptyState`, `SkeletonList` (shimmer),
`ErrorView`/`CorrelationChip`, `OfflineBanner`, `FilterBar` and `SortSheet`,
`DataCard`/`FieldList`, `SlaRing`, `Timeline`.

## Adding a section

1. **Repository.** Create `lib/features/ops/<name>/<name>_repository.dart`,
   annotated with `@lazySingleton` and taking `ApiClient`. Model the rows as
   `class Row extends JsonRecord` with typed getters. Return
   `Future<Paged<Row>> list(ListQuery q)`, using `pagedFrom(json, ['legacyKey'], Row.new)`.
2. **Page.** Create `<name>_page.dart` with a `@RoutePage()` class. Provide
   `ListCubit<Row>(repo.list)..start()`. Render
   `SectionScaffold(title, permission: 'ops.<name>.view', body: AsyncListView<Row>(…))`
   with a `FilterBar` header and `DataCard` rows. Open details with
   `showDetailSheet`. Gate each mutating action with `PermissionGate` or
   `session.can`, and confirm it with `showConfirmDangerSheet`.
3. **Route.** Add `AutoRoute(page: <Name>Route.page, path: '/ops/<name>', guards: [guard])`
   to `lib/core/router/app_router.dart`. Note that the generator replaces every
   "Page" in the class name with "Route", so `CmsPagesPage` would become
   `CmsRoutesRoute`.
4. **More list.** Add a `MoreLink` to the right group in `MorePage.groups`,
   with its permission keys.
5. **Strings.** Add every new string to **both** `intl_en.arb` and
   `intl_ar.arb`, then run `gen-l10n`.
6. **Generate and check.** Run `build_runner build`, then `dart analyze`
   (0 errors, 0 warnings), then add a test.

## Testing notes

- Tests never fetch fonts. `setUpTestFonts()` sets
  `GoogleFonts.config.allowRuntimeFetching = false` and
  `DahabFonts.useGoogleFonts = false`. It loads Roboto and Material Icons from
  the Flutter SDK cache, and Tahoma for Arabic when the host has it
  (Windows). Goldens are therefore host-specific: regenerate them on the
  machine that runs CI.
- `test/helpers/fake_adapter.dart` is an in-memory Dio `HttpClientAdapter`.
  Use it for interceptor and repository tests.
