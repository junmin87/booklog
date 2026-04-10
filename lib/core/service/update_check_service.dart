import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';

class UpdateCheckService {
  static const _remoteVersionKey = 'app_version';
  static const _defaultVersion = '1.0.0';

  Future<bool> isUpdateRequired() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setDefaults({_remoteVersionKey: _defaultVersion});
    await remoteConfig.fetchAndActivate();

    final remoteVersion = remoteConfig.getString(_remoteVersionKey);
    final currentVersion = (await PackageInfo.fromPlatform()).version;

    return _isNewer(remoteVersion, currentVersion);
  }

  bool _isNewer(String remote, String current) {
    List<int> parse(String v) =>
        v.split('.').map((s) => int.tryParse(s) ?? 0).toList();

    final r = parse(remote);
    final c = parse(current);

    for (int i = 0; i < 3; i++) {
      final rv = i < r.length ? r[i] : 0;
      final cv = i < c.length ? c[i] : 0;
      if (rv > cv) return true;
      if (rv < cv) return false;
    }
    return false;
  }
}
