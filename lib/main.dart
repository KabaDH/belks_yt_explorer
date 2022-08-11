import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/screens.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool k = prefs.containsKey('PrivatePolicyAccepted');
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    statusBarColor: Colors.transparent,
  ));
  // SystemChrome.setPreferredOrientations(
  //         [DeviceOrientation.portraitUp, DeviceOrientation.landscapeLeft])
  //     .then((_) => runApp(MyApp(acceptedPrivacy: k)));
  runApp(MyApp(acceptedPrivacy: k));
}

class MyApp extends StatelessWidget {
  final bool acceptedPrivacy;

  const MyApp({Key? key, required this.acceptedPrivacy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
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
      ),
    );
  }
}
