import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import '../../../core/api/models/admin_models.dart';
import '../../../core/design/app_theme.dart';
import '../../../core/design/components/dahab_button.dart';
import '../../../core/design/components/dahab_text_field.dart';
import '../../../core/design/components/error_view.dart';
import '../../../core/design/components/permission_gate.dart';
import '../../../core/design/components/primitives.dart';
import '../../../core/design/spacing.dart';
import '../../../l10n/l10n.dart';
import 'role_labels.dart';
import '../data/access_repository.dart';
import '../domain/permissions.dart';
import '../../../core/router/shell_leading.dart';

/// Invite a staff member. The temporary password is shown exactly once and
/// is never kept in state after this screen closes.
@RoutePage()
class InviteStaffPage extends StatefulWidget {
  const InviteStaffPage({super.key});

  @override
  State<InviteStaffPage> createState() => _InviteStaffPageState();
}

class _InviteStaffPageState extends State<InviteStaffPage> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _supplier = TextEditingController();
  final _repo = GetIt.I<AccessRepository>();
  List<Role> _roles = const [];
  String? _roleId;
  bool _busy = false;
  InviteResult? _result;

  @override
  void initState() {
    super.initState();
    _repo.roles().then((r) {
      if (mounted) setState(() => _roles = r);
    }, onError: (Object _) {});
  }

  @override
  void dispose() {
    for (final c in [_email, _name, _phone, _supplier]) {
      c.dispose();
    }
    super.dispose();
  }

  Role? get _role => _roles.where((r) => r.id == _roleId).firstOrNull;

  Future<void> _submit() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() => _busy = true);
    try {
      final r = await _repo.invite(
        email: _email.text.trim(),
        name: _name.text.trim(),
        phone: _phone.text.trim(),
        roleId: _roleId!,
        supplierId: _supplier.text.trim(),
      );
      if (mounted) setState(() => _result = r);
    } catch (e) {
      if (mounted) showErrorToast(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(leading: shellLeading(context),
        automaticallyImplyLeading: false, title: Text(l.inviteStaff)),
      body: PermissionGate(
        permission: P.usersManage,
        explain: true,
        child: _result != null ? _Done(result: _result!) : _formView(context),
      ),
    );
  }

  Widget _formView(BuildContext context) {
    final l = context.l10n;
    final emailRe = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    final supplierRole = _role?.name == 'Supplier';
    return Form(
      key: _form,
      child: ListView(padding: const EdgeInsets.all(Space.gutter), children: [
        DahabTextField(
          label: l.email,
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.email],
          validator: (v) => emailRe.hasMatch(v?.trim() ?? '') ? null : l.emailInvalid,
        ),
        Gap.h12,
        DahabTextField(
          label: l.name,
          controller: _name,
          validator: (v) => (v?.trim().isEmpty ?? true) ? l.nameRequired : null,
        ),
        Gap.h12,
        DahabTextField(
          label: '${l.phone} (${l.optional})',
          controller: _phone,
          mono: true,
          keyboardType: TextInputType.phone,
        ),
        Gap.h12,
        DropdownButtonFormField<String>(
          initialValue: _roleId,
          decoration: InputDecoration(labelText: l.role),
          items: [for (final r in _roles) DropdownMenuItem(value: r.id, child: Text(RoleLabels.of(l, r)))],
          validator: (v) => v == null ? l.roleRequired : null,
          onChanged: (v) => setState(() => _roleId = v),
        ),
        if (supplierRole) ...[
          Gap.h12,
          DahabTextField(label: l.supplierId, controller: _supplier, mono: true),
        ],
        Gap.h24,
        DahabButton(label: l.invite, expand: true, loading: _busy, onPressed: _submit),
      ]),
    );
  }
}

class _Done extends StatelessWidget {
  const _Done({required this.result});

  final InviteResult result;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    final type = context.type;
    return ListView(padding: const EdgeInsets.all(Space.xl), children: [
      Icon(Icons.mark_email_read_outlined, size: 40, color: t.positive),
      Gap.h12,
      Text(l.inviteDone, style: type.heading, textAlign: TextAlign.center),
      Text(result.user.email, style: type.bodySm.copyWith(color: t.ink2), textAlign: TextAlign.center),
      Gap.h24,
      Panel(
        color: t.warningWash,
        borderColor: t.warning.withValues(alpha: 0.35),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l.tempPasswordTitle, style: type.bodyStrong),
          Gap.h4,
          Text(l.tempPasswordBody, style: type.caption.copyWith(color: t.ink2)),
          Gap.h12,
          SelectableText(
            result.tempPassword,
            textDirection: TextDirection.ltr,
            style: type.mono.copyWith(fontSize: 20, color: t.ink, fontWeight: FontWeight.w600),
          ),
          Gap.h8,
          DahabButton.ghost(
            label: l.copyPassword,
            icon: Icons.copy_rounded,
            compact: true,
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: result.tempPassword));
              if (context.mounted) showToast(context, l.copied);
            },
          ),
        ]),
      ),
      Gap.h24,
      DahabButton(label: l.done, expand: true, onPressed: () => context.router.maybePop()),
    ]);
  }
}
