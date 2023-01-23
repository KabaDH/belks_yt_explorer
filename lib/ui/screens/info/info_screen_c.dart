import 'package:belks_tube/data/config/app_config.dart';
import 'package:belks_tube/domain/user/user_model.dart';
import 'package:belks_tube/services/providers/user.dart';
import 'package:belks_tube/ui/screens/privacy/privacy_screen.dart';
import 'package:belks_tube/ui/screens/terms/terms_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoScreenController extends StateNotifier<User> {
  InfoScreenController(this._ref) : super(_ref.read(userProvider)) {
    init();
  }

  final Ref _ref;
  late final ProviderSubscription userSub;
  final Uri flutterUri = Uri.parse('https://flutter.dev');

  String get appVersion => AppConfig.instance.version;
  String get appBuild => AppConfig.instance.buildNumber;

  final Map<String, Widget> screens = {
    'Privacy Policy': const PrivacyScreen(acceptedPrivacy: true),
    'Terms of Use': const TermsOfUse(), // Terms of Use
  };

  void init() {
    userSub = _ref.listen(userProvider, (_, v) {
      state = v as User;
    });
  }

  @override
  void dispose() {
    userSub.close();
    super.dispose();
  }

  static final provider =
      StateNotifierProvider<InfoScreenController, User>((ref) {
    return InfoScreenController(ref);
  });

  void setCanPlayBlackScreen(bool v) =>
      _ref.read(userProvider.notifier).setCanPlayBlackScreen(v);

  Future<void> onFlutterTap() async {
    if (await canLaunchUrl(flutterUri)) {
      launchUrl(
        flutterUri,
      );
    } else {
      throw 'Can`t load url';
    }
  }
}
