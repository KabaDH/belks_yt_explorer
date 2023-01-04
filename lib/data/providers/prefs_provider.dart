import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// set this provider on App init stage
final sharedPreferencesProvider =
Provider<SharedPreferences>((ref) => throw UnimplementedError());
