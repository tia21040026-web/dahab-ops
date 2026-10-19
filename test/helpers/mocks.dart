import 'package:dahab_ops/core/api/models/auth_models.dart';
import 'package:dahab_ops/core/platform/device_info_service.dart';
import 'package:dahab_ops/features/auth/data/auth_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class FakeDeviceInfo implements DeviceInfoService {
  @override
  Future<DeviceDescription> describe() async =>
      const DeviceDescription(name: 'Test Phone', platform: 'ios');
}

const opsUser = User(id: 'u1', email: 'ops@dahab.travel', name: 'Nour Ops', role: 'Operations');
const supplierUser =
    User(id: 'u2', email: 'desk@lagoon.eg', name: 'Lagoon Desk', role: 'Supplier', supplierId: 's1');
const adminUser = User(id: 'u0', email: 'admin@dahab.travel', name: 'Admin', role: 'Admin');

LoginResponse loginResponse(User user, List<String> permissions) => LoginResponse(
      user: user,
      accessToken: 'a',
      refreshToken: 'r',
      permissions: permissions,
    );

MeResponse meResponse(User user, List<String> permissions, {ViewAs? viewAs}) =>
    MeResponse(user: user, permissions: permissions, viewAs: viewAs);
