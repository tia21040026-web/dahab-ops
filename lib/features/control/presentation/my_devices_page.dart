import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/api/models/auth_models.dart';
import '../../../core/api/models/paged.dart';
import '../../../core/design/app_theme.dart';
import '../../../core/design/components/confirm_danger_sheet.dart';
import '../../../core/design/components/error_view.dart';
import '../../../core/design/components/primitives.dart';
import '../../../core/design/components/status_badge.dart';
import '../../../core/design/spacing.dart';
import '../../../core/format/formatters.dart';
import '../../../core/list/async_list_view.dart';
import '../../../core/list/list_cubit.dart';
import '../../../l10n/l10n.dart';
import '../../auth/data/auth_repository.dart';
import '../../../core/router/shell_leading.dart';

/// The caller's device sessions with revoke. The current device cannot be
/// revoked here (sign out instead).
@RoutePage()
class MyDevicesPage extends StatelessWidget {
  const MyDevicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = GetIt.I<AuthRepository>();
    final l = context.l10n;
    return BlocProvider(
      create: (_) => ListCubit<DeviceSession>((_) async => Paged(items: await auth.devices()))..start(),
      child: Scaffold(
        appBar: AppBar(leading: shellLeading(context),
        automaticallyImplyLeading: false, title: Text(l.myDevices)),
        body: AsyncListView<DeviceSession>(
          emptyIcon: Icons.devices_outlined,
          emptyTitle: l.devicesEmpty,
          itemBuilder: (context, d) => DeviceTile(
            device: d,
            onRevoke: d.current
                ? null
                : () async {
                    final reason = await showConfirmDangerSheet(context,
                        title: l.revokeDevice, body: d.name, biometric: false);
                    if (reason == null || !context.mounted) return;
                    try {
                      await auth.revokeDevice(d.id);
                      if (!context.mounted) return;
                      context.read<ListCubit<DeviceSession>>().removeWhere((x) => x.id == d.id);
                      showToast(context, l.deviceRevoked, tone: Tone.positive);
                    } catch (e) {
                      if (context.mounted) showErrorToast(context, e);
                    }
                  },
          ),
        ),
      ),
    );
  }
}

/// A device session row, shared with the admin user detail.
class DeviceTile extends StatelessWidget {
  const DeviceTile({super.key, required this.device, this.onRevoke});

  final DeviceSession device;
  final VoidCallback? onRevoke;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final l = context.l10n;
    final icon = switch (device.platform) {
      'ios' => Icons.phone_iphone,
      'android' => Icons.phone_android,
      _ => Icons.laptop_mac,
    };
    return Column(children: [
      ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: Space.gutter),
        leading: Icon(icon, color: t.ink2),
        title: Row(children: [
          Flexible(child: Text(device.name ?? device.platform ?? device.id, overflow: TextOverflow.ellipsis)),
          if (device.current) ...[
            Gap.w8,
            StatusBadge(label: l.thisDevice, tone: Tone.positive),
          ],
        ]),
        subtitle: Text(l.lastSeen(Fmt.ago(context, device.lastSeenAt ?? device.createdAt)),
            style: context.type.caption.copyWith(color: t.ink3)),
        trailing: onRevoke == null
            ? null
            : TextButton(
                onPressed: onRevoke,
                style: TextButton.styleFrom(foregroundColor: t.critical),
                child: Text(l.revokeDevice),
              ),
      ),
      const Hairline(indent: Space.gutter + 40),
    ]);
  }
}
