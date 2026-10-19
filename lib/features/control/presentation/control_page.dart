import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/design/components/dg_icons.dart';
import '../../../core/design/components/error_view.dart';
import '../../../core/design/components/instrument.dart';
import '../../../core/design/components/modern.dart';
import '../../../core/design/components/offline_banner.dart';
import '../../../core/design/components/primitives.dart';
import '../../../core/design/components/skeleton_list.dart';
import '../../../core/design/spacing.dart';
import '../../../core/router/app_router.gr.dart';
import '../../../l10n/l10n.dart';
import '../../access/domain/permissions.dart';
import '../../access/presentation/session_cubit.dart';
import 'control_cubit.dart';
import 'flag_labels.dart';

/// The Control Center (`/control`): one hub for everything the desk
/// controls on the web and both apps — the live platform verdict up top,
/// then permission-gated tiles into each control surface. Colour is status;
/// hairlines do the rest.
@RoutePage()
class ControlPage extends StatelessWidget {
  const ControlPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<ControlCubit>()..start(),
      child: const _ControlView(),
    );
  }
}

class _ControlView extends StatelessWidget {
  const _ControlView();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final session = context.watch<SessionCubit>().state;
    return Scaffold(
      appBar: DgTopBar(title: l.controlTitle, subtitle: l.ccHubSubtitle),
      body: BlocBuilder<ControlCubit, ControlState>(
        builder: (context, s) {
          if (s.status == ControlStatus.initial || s.status == ControlStatus.loading) {
            return const SkeletonList(count: 8, lines: 1);
          }
          if (s.status == ControlStatus.failure) {
            return ErrorView(error: s.error!, onRetry: context.read<ControlCubit>().refresh);
          }
          return RefreshIndicator(
            onRefresh: context.read<ControlCubit>().refresh,
            child: ListView(children: [
              const OfflineBanner(),
              _Hero(session: session, s: s),
              if (session.canAny(const [P.settingsManage, P.flagsManage, P.opsFlags])) ...[
                DgGroupTitle(l.ccGroupApp),
                _Tile(
                  icon: DgIcons.power,
                  title: l.ccTileExperience,
                  subtitle: l.ccTileExperienceSub,
                  onTap: () => context.router.push(const AppExperienceRoute()),
                ),
              ],
              if (session.can('cms.content.edit')) ...[
                _Tile(
                  icon: DgIcons.grid,
                  title: l.ccTileHomepage,
                  subtitle: l.ccTileHomepageSub,
                  onTap: () => context.router.push(const HomepageEditorRoute()),
                ),
                _Tile(
                  icon: DgIcons.activity,
                  title: l.ccTileProgrammes,
                  subtitle: l.ccTileProgrammesSub,
                  onTap: () => context.router.push(const ProgrammesRoute()),
                ),
                _Tile(
                  icon: DgIcons.sort,
                  title: l.ccTileNavigation,
                  subtitle: l.ccTileNavigationSub,
                  onTap: () => context.router.push(const NavigationEditorRoute()),
                ),
              ],
              if (session.can('cms.content.view'))
                _Tile(
                  icon: DgIcons.msg,
                  title: l.sectionCms,
                  subtitle: l.ccTileCmsSub,
                  onTap: () => context.router.push(const CmsListRoute()),
                ),
              DgGroupTitle(l.ccGroupPlatform),
              if (session.can(P.settingsView))
                _Tile(
                  icon: DgIcons.wrench,
                  title: l.settingsTitle,
                  subtitle: l.ccTileSettingsSub,
                  onTap: () => context.router.push(const SettingsRoute()),
                ),
              if (session.canAny(const [P.flagsManage, P.opsFlags]))
                _Tile(
                  icon: DgIcons.shield,
                  title: l.killSwitches,
                  subtitle: l.ccTileFlagsSub,
                  trailing: _FlagPill(s: s, session: session),
                  onTap: () => context.router.push(const FlagsRoute()),
                ),
              if (session.can(P.integrationsView))
                _Tile(
                  icon: DgIcons.server,
                  title: l.integrationsTitle,
                  subtitle: l.ccTileIntegrationsSub,
                  onTap: () => context.router.push(const IntegrationsRoute()),
                ),
              if (session.can(P.approvalsDecide))
                _Tile(
                  icon: DgIcons.check,
                  title: l.approvalsTitle,
                  subtitle: l.ccTileApprovalsSub,
                  trailing: s.approvals.isEmpty
                      ? null
                      : StatusPill('${s.approvals.length}', tone: Tone.warning, pulse: true),
                  onTap: () => context.router.push(const ApprovalsRoute()),
                ),
              if (session.can(P.usersView))
                _Tile(
                  icon: DgIcons.users,
                  title: l.ccTileUsers,
                  subtitle: l.ccTileUsersSub,
                  onTap: () => context.router.push(const UsersRoute()),
                ),
              if (session.can(P.opsAudit))
                _Tile(
                  icon: DgIcons.cal,
                  title: l.sectionAudit,
                  subtitle: l.ccTileAuditSub,
                  onTap: () => context.router.push(AuditRoute()),
                ),
              Gap.h32,
            ]),
          );
        },
      ),
    );
  }
}

/// The live verdict: maintenance dominates, then engaged kill switches,
/// then all-clear. Readings are mono meters under the headline.
class _Hero extends StatelessWidget {
  const _Hero({required this.session, required this.s});

  final SessionState session;
  final ControlState s;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final maintenance = s.flags.where((f) => f.isMaintenance).firstOrNull;    final kills = s.flags.where((f) => f.isKillSwitch && f.enabled).toList();
    final degraded = s.integrations.where((i) => i.status == 'degraded' || i.status == 'down').length;

    final (tone, title, subtitle) = switch ((maintenance?.enabled ?? false, kills.length)) {
      (true, _) => (
          Tone.critical,
          l.ccMaintenanceOn,
          l.ccMaintenanceOnSub,
        ),
      (false, > 0) => (
          Tone.warning,
          l.ccKillsOn(kills.length),
          kills.map((f) => FlagLabels.title(l, f)).join(' · '),
        ),
      _ => (Tone.positive, l.ccAllClear, l.ccAllClearSub),
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(Space.gutter, Space.md, Space.gutter, Space.xs),
      child: HeroStatusCard(
        tone: tone,
        title: title,
        subtitle: subtitle,
        readings: [
          (l.ccReadingApprovals, '${s.approvals.length}'),
          if (session.canAny(const [P.flagsManage, P.opsFlags])) (l.ccReadingKills, '${kills.length}'),
          if (session.can(P.integrationsView) && degraded > 0) (l.ccReadingIntegrations, '$degraded'),
        ],
      ),
    );
  }
}

/// Tile wrapper: uniform insets + hairline separation via the list.
class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    required this.onTap,
  });

  final DgIcons icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Space.gutter, Space.xs, Space.gutter, Space.xs),
      child: ActionTile(
        icon: icon,
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}

class _FlagPill extends StatelessWidget {
  const _FlagPill({required this.s, required this.session});

  final ControlState s;
  final SessionState session;

  @override
  Widget build(BuildContext context) {
    final engaged = s.flags.where((f) => f.enabled && (f.isKillSwitch || f.isMaintenance)).length;
    if (!session.canAny(const [P.flagsManage, P.opsFlags]) || engaged == 0) return const SizedBox.shrink();
    return StatusPill('$engaged', tone: Tone.warning, pulse: true);
  }
}
