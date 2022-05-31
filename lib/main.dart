import 'package:flutter/material.dart';
import 'screens/screens.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

///For the lunch icon thanks to https://icons8.com/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    statusBarColor: Colors.transparent,
  ));
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool k = prefs.containsKey('PrivatePolicyAccepted');
  runApp(MyApp(acceptedPrivacy: k));
}

class MyApp extends StatelessWidget {
  final bool acceptedPrivacy;

  const MyApp({Key? key, required this.acceptedPrivacy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green,
        scaffoldBackgroundColor: Colors.green.shade100,
      ),
      home: acceptedPrivacy
          ? HomeScreen()
          : PrivacyScreen(
              acceptedPrivacy: acceptedPrivacy,
            ),
    );
  }
}
