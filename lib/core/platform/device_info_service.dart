import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceDescription {
  const DeviceDescription({required this.name, required this.platform});

  final String name;

  /// `ios` | `android` | `web` (contract values).
  final String platform;
}

abstract class DeviceInfoService {
  Future<DeviceDescription> describe();
}

class PluginDeviceInfoService implements DeviceInfoService {
  PluginDeviceInfoService([DeviceInfoPlugin? plugin]) : _plugin = plugin ?? DeviceInfoPlugin();

  final DeviceInfoPlugin _plugin;
  DeviceDescription? _cached;

  @override
  Future<DeviceDescription> describe() async {
    if (_cached != null) return _cached!;
    try {
      if (Platform.isIOS) {
        final i = await _plugin.iosInfo;
        return _cached = DeviceDescription(name: i.name, platform: 'ios');
      }
      if (Platform.isAndroid) {
        final a = await _plugin.androidInfo;
        final brand = a.manufacturer.isEmpty
            ? ''
            : '${a.manufacturer[0].toUpperCase()}${a.manufacturer.substring(1)} ';
        return _cached = DeviceDescription(name: '$brand${a.model}'.trim(), platform: 'android');
      }
    } catch (_) {
      // Fall through to a generic description.
    }
    return _cached = DeviceDescription(
      name: 'Dahab Ops',
      platform: Platform.isIOS ? 'ios' : 'android',
    );
  }
}
