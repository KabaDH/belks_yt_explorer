import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppConfig {
  AppConfig._instantiate();

  static final AppConfig instance = AppConfig._instantiate();

  static String get apiKey => dotenv.env['API_KEY'] ?? '';
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';
  static String get defChannel => dotenv.env['DEF_CHANNEL'] ?? '';

  late final PackageInfo _packageInfo;

  void load() async {
    await dotenv.load(fileName: 'assets/.env');
    _packageInfo = await PackageInfo.fromPlatform();
  }

  String get buildNumber => _packageInfo.buildNumber;
  String get version => _packageInfo.version;
}
