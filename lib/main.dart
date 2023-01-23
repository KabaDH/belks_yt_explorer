import 'package:belks_tube/data/providers/app_config.dart';
import 'package:belks_tube/data/repo/local/prefs_provider.dart';
import 'package:belks_tube/ui/screens/home/home_screen.dart';
import 'package:belks_tube/ui/screens/privacy_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/repo/remote/http/dio_provider.dart';
import 'package:flutter/services.dart';
import 'services/popup_window.dart';
import 'dart:io';

///For the lunch icon thanks to https://icons8.com/
//color #FF0000 padding 20%

@pragma('vm:entry-point')
void androidWindow() {
  if (Platform.isAndroid) {
    runApp(const AndroidWindowApp());
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.instance.load();
  await initSharedPreferences();
  initDio();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    statusBarColor: Colors.transparent,
  ));
  // SystemChrome.setPreferredOrientations(
  //         [DeviceOrientation.portraitUp, DeviceOrientation.landscapeLeft])
  //     .then((_) => runApp(MyApp(acceptedPrivacy: k)));
  runApp(const ProviderScope(
      // overrides: [
      // sharedPreferencesProvider.overrideWithValue(prefs),
      // ],
      child: MyApp()));
}

class MyApp extends ConsumerWidget {
  // final bool acceptedPrivacy;

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool acceptedPrivacy =
        ref.watch(prefsProvider).containsKey('PrivatePolicyAccepted');

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green,
        scaffoldBackgroundColor: Colors.green.shade100,
      ),
      home: acceptedPrivacy
          ? const HomeScreen()
          : PrivacyScreen(
              acceptedPrivacy: acceptedPrivacy,
            ),
    );
  }
}
