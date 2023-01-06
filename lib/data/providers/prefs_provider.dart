import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'prefs_provider.g.dart';

late final SharedPreferences _perfs;

Future<void> initSharedPreferences() async {
  _perfs = await SharedPreferences.getInstance();
}


/// init this provider in main
@riverpod
SharedPreferences prefs(PrefsRef ref) => _perfs;

// final sharedPreferencesProvider = Provider<SharedPreferences>((_) => _perfs);
